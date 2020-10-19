//
//  SDChooseCityPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChooseCityPopView.h"
#import "SDAddressCityCell.h"
#import "SPPickerView.h"
#import "SPPageMenu.h"

@interface SDChooseCityPopView () <SPPickerViewDatasource,SPPickerViewDelegate, SPPageMenuDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, copy) ChooseCityBlock block;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) SPPickerView *pickerView;

@property (nonatomic, assign) NSInteger numerOfComponents;

@property (nonatomic, strong) SDCityModel *selectedProvince;
@property (nonatomic, strong) SDCityModel *selectedCity;

@end

@implementation SDChooseCityPopView

static CGFloat const contentH = 430.0;
static CGFloat const topH = 77.0;
static CGFloat const titleH = 50.0;
static CGFloat const segmentedControlH = 26;
static CGFloat const titleMargin = 30.0;

+ (instancetype)showPopViewWithCitys:(NSArray *)cityArr confirmBlock:(ChooseCityBlock)block {
    return [[self alloc] initWithShowPopViewWithCitys:cityArr confirmBlock:block];
}

- (instancetype)initWithShowPopViewWithCitys:(NSArray *)cityArr confirmBlock:(ChooseCityBlock)block {
    if (self = [super init]) {
        [self addToWindow];
        self.block = block;
        self.cityArr = [cityArr copy];
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
        self.userInteractionEnabled = YES;
        [self initSubView];
    }
    return self;
}

- (void)addToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)initSubView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - contentH - kBottomSafeHeight);
    [self addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)];
    [topView addGestureRecognizer:tap];

    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentH - kBottomSafeHeight, SCREEN_WIDTH, contentH + kBottomSafeHeight);
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择收货城市";
    titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    titleLabel.textColor = [UIColor colorWithRGB:0x131413];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleH);
    self.titleLabel = titleLabel;
    [contentView addSubview:titleLabel];
    
    [self initPageMenu];
    [self initPickerView];
    self.numerOfComponents = 1;
    [self.pickerView sp_reloadAllComponents];

}

- (void)initPageMenu {
    
    self.pageMenu.frame = CGRectMake(0, titleH, SCREEN_WIDTH, segmentedControlH);
    [self.contentView addSubview:self.pageMenu];
}

- (void)initPickerView {
    CGFloat y = topH;
    CGRect frame = CGRectMake(0, y, SCREEN_WIDTH, contentH - y);
    self.pickerView.frame = frame;
    [self.contentView addSubview:self.pickerView];
}

#pragma mark - SPPageMenuDelegate

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    [self.pickerView sp_scrollToComponent:index atComponentScrollPosition:SPPickerViewComponentScrollPositionDefault animated:YES];
}

#pragma mark - SPPickerViewDatasource,SPPickerViewDelegate
// 返回多少列
- (NSInteger)sp_numberOfComponentsInPickerView:(SPPickerView *)pickerView {
    return self.numerOfComponents;
}

// 每一列返回多少行
- (NSInteger)sp_pickerView:(SPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.cityArr.count;
    } else if (component == 1) {
        return self.selectedProvince.citys.count;
    } else {
        return 0;
    }
}

// 每一列每一行的cell，参数systemCell是系统自带的cell，如果想自定义cell，需要先调用- sp_registerClass: forComponent:方法进行注册
- (UITableViewCell *)sp_pickerView:(SPPickerView *)pickerView cellForRow:(NSInteger)row forComponent:(NSInteger)component systemCell:(UITableViewCell *)systemCell {
    if (component == 0) {
        SDAddressCityCell *cell = [pickerView sp_dequeueReusableCellAtRow:row atComponent:component];
        SDCityModel *province = self.cityArr[row];
        cell.model = province;
        return cell;
    } else if (component == 1) { // 第2列直接使用系统的cell
        SDAddressCityCell *cell = [pickerView sp_dequeueReusableCellAtRow:row atComponent:component];
        SDCityModel *cityModel = self.selectedProvince.citys[row];
        cell.model = cityModel;
        return cell;
    }
    return nil;
}

// 行高
- (CGFloat)sp_pickerView:(SPPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

// 行宽
- (CGFloat)sp_pickerView:(SPPickerView *)pickerView rowWidthForComponent:(NSInteger)component {
    return SCREEN_WIDTH;
}

// 点击了哪一列的哪一行
- (void)sp_pickerView:(SPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        for (SDCityModel *chooseProvince in self.cityArr) {
            if (chooseProvince.isChoose) {
                chooseProvince.choose = NO;
                for (SDCityModel *chooseCity in chooseProvince.citys) {
                    if (chooseCity.isChoose) {
                        chooseCity.choose = NO;
                    }
                }
                break;
            }
        }
        self.selectedProvince = self.cityArr[row];
        self.selectedProvince.choose = YES;
        self.selectedCity = [self.selectedProvince.citys firstObject];
        self.numerOfComponents = 2;
        [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
        [self setupPageMenuWithName:self.selectedProvince.name atComponent:component];
    } else if (component == 1) {

        self.selectedCity = self.selectedProvince.citys[row];
        self.selectedCity.choose = YES;
        //[self.pickerView sp_reloadComponent:2];

        self.numerOfComponents = 3;
        [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
        [self setupPageMenuWithName:self.selectedCity.name atComponent:component];
        self.pageMenu.selectedItemIndex = component;
        
        if (self.block) {
            self.block(self.selectedProvince.name, self.selectedCity.name);
        }
        [self closePopView];
    }
}

- (void)setupPageMenuWithName:(NSString *)name atComponent:(NSInteger)component {
    NSString *title = [self.pageMenu titleForItemAtIndex:component];
    if ([title isEqualToString:@"请选择"]) {
        [self.pageMenu insertItemWithTitle:name atIndex:component animated:YES];
    } else {
        // 改变当前item的标题
        [self.pageMenu setTitle:name forItemAtIndex:component];
        // 将下一个置为“请选择”
        [self.pageMenu setTitle:@"请选择" forItemAtIndex:component+1];
        NSInteger itemCount = (self.pageMenu.numberOfItems-1);
        // 保留2个item，2个之后的全部删除
        for (int i = 0; i < itemCount-(component+1); i++) {
            [self.pageMenu removeItemAtIndex:self.pageMenu.numberOfItems-1 animated:YES];
        }
    }
    // 切换选中的item，会执行pageMenu的代理方法，
    self.pageMenu.selectedItemIndex = component + 1;
}

#pragma mark - action
- (void)titleClick:(UIButton *)clickBtn {
    
}

- (void)closePopView {
    [self removeFromSuperview];
}

- (void)confirmBtnClick {
    if(self.block) {
    
    }
    [self closePopView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
   
}

#pragma mark - getter

- (void)setCityArr:(NSArray *)cityArr {
    _cityArr = cityArr;
    self.selectedProvince = self.cityArr.firstObject;
    self.selectedCity = self.selectedProvince.citys.firstObject;
//    [self.pickerView sp_reloadAllComponents];
}

- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.delegate = self;
        [_pageMenu setItems:@[@"请选择"] selectedItemIndex:0];
        _pageMenu.itemTitleFont = [UIFont fontWithName:kSDPFMediumFont size:14];
        _pageMenu.selectedItemTitleColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithRGB:0x131413];
        [_pageMenu setTrackerHeight:2 cornerRadius:0];
        _pageMenu.itemPadding = 30;
        _pageMenu.dividingLine.backgroundColor = [UIColor colorWithRGB:0xededed];
        _pageMenu.bridgeScrollView = self.pickerView.scrollView;
        _pageMenu.tracker.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        ;    }
    return  _pageMenu;
}

- (SPPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[SPPickerView alloc] init];
        [_pickerView sp_hideSeparatorLineForAllComponentls];
        [_pickerView sp_registerClass:[SDAddressCityCell class] forComponent:0]; // 注册第1列cell
        [_pickerView sp_registerClass:[SDAddressCityCell class] forComponent:1];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return  _pickerView;
}



@end
