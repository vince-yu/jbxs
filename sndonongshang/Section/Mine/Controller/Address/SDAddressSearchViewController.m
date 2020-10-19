//
//  SDAddressSearchViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressSearchViewController.h"
#import "SDChooseCityButton.h"
#import "SDSearchAddrCell.h"
#import "SDChooseCityPopView.h"
#import "SDCityModel.h"

@interface SDAddressSearchViewController () <UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) SDChooseCityButton *cityBtn;
@property (nonatomic, weak) UITextField *searchTextField;

@end

@implementation SDAddressSearchViewController

static CGFloat const searchH = 30.0;
static CGFloat const cancelBtnW = 45.0;
static CGFloat const margin = 15.0;
static CGFloat const cityBtnExtra = 14 + 6 + 13 + 1;
static NSString * const CellID = @"SDSearchAddrCell<##>";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchView];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initSearchView {
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.frame = CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, kNavBarHeight);
    [self.view addSubview:searchView];
    
    CGFloat bgY = (kNavBarHeight - searchH) * 0.5;
    CGFloat bgW = SCREEN_WIDTH - cancelBtnW - margin;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRGB:0xf5f6f7];
    bgView.layer.cornerRadius = searchH * 0.5;
    bgView.layer.masksToBounds = YES;
    bgView.frame = CGRectMake(10, bgY, bgW, searchH);
    [searchView addSubview:bgView];
    
    if (!self.city) {
        self.city = @"成都";
        self.province = @"四川";
    }
    for (SDCityModel *province in self.cityArr) {
        if ([province.name isEqualToString:self.province]) {
            province.choose = YES;
            for (SDCityModel *city in province.citys) {
                if ([city.name isEqualToString:self.city]) {
                    city.choose = YES;
                    break;
                }
            }
            break;
        }
    }
    
    SDChooseCityButton *cityBtn = [SDChooseCityButton buttonWithType:UIButtonTypeCustom];
    [cityBtn addTarget:self action:@selector(chooseCityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setTitle:self.city forState:UIControlStateNormal];
    [bgView addSubview:cityBtn];
    [cityBtn sizeToFit];
    CGFloat cityBtnW = cityBtn.cp_w + cityBtnExtra;
    cityBtn.frame = CGRectMake(0, 0, cityBtnW, searchH);
    self.cityBtn = cityBtn;

    CGFloat textFieldW = bgW - cityBtn.cp_w - 15;
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    searchTextField.backgroundColor = [UIColor colorWithRGB:0xf5f6f7];
    searchTextField.frame = CGRectMake(cityBtnW + 13, 0, textFieldW, searchH);
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    searchTextField.textColor = [UIColor colorWithRGB:0x131413];
    searchTextField.delegate = self;
    [searchTextField becomeFirstResponder];
    [searchTextField addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:searchTextField];
    self.searchTextField = searchTextField;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRGB:0x27272C] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    cancelBtn.frame = CGRectMake(bgW + margin, 0, cancelBtnW, kNavBarHeight);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    [searchView addSubview:lineView];
    lineView.frame = CGRectMake(0, kNavBarHeight - 0.5, SCREEN_WIDTH, 0.5);

}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [tableView registerClass:[SDSearchAddrCell class] forCellReuseIdentifier:CellID];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
}

#pragma mark - action
- (void)chooseCityBtnClick {
    [self.view endEditing:YES];
    [SDChooseCityPopView showPopViewWithCitys:self.cityArr confirmBlock:^(NSString * _Nonnull province, NSString * _Nonnull city) {
        self.province = province;
        self.city = city;
        [self.cityBtn setTitle:city forState:UIControlStateNormal];
        [self.cityBtn sizeToFit];
        self.cityBtn.cp_h = searchH;
        self.cityBtn.cp_w =  self.cityBtn.cp_w + cityBtnExtra;
        CGFloat textFieldW = SCREEN_WIDTH - cancelBtnW - margin - self.cityBtn.cp_w - 15;
        self.searchTextField.frame = CGRectMake(self.cityBtn.cp_w + 13, 0, textFieldW, searchH);
        [self.searchArr removeAllObjects];
        [self.tableView reloadData];
        self.searchTextField.text = nil;
    }];
}

- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textContentChanged:(UITextField*)textField{
    UITextRange * selectedRange = [textField markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
        SNDOLOG( @"text : %@ %@", textField.text, self.city);
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords = textField.text;
        request.city = self.city;
        request.requireExtension = YES;
        request.cityLimit  = YES;
        request.requireSubPOIs = YES;
        [self.search AMapPOIKeywordsSearch:request];
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDSearchAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    AMapPOI *model = self.searchArr[indexPath.row];
    cell.poiModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        SDSearchAddrCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        AMapPOI *poi = self.searchArr[indexPath.row];
        self.block(poi, cell.addressLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    NSLog(@"pois %lu", (unsigned long)response.pois.count);
    [self.searchArr removeAllObjects];
    [self.searchArr addObjectsFromArray:response.pois];
    [self.tableView reloadData];
}

#pragma mark - getter
- (NSMutableArray *)searchArr {
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

@end
