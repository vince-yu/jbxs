
//
//  SDHomePopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomePopView.h"
#import "SDHomeCouponsCell.h"
#import "SDLoginViewController.h"
#import "SDHomeDataManager.h"

@interface SDHomePopView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *contentBgIV;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bottomBgIV;
@property (nonatomic, strong) UIButton *receiveBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray *coupons;

@property (nonatomic, assign) CGFloat contentW;
@property (nonatomic, assign) CGFloat contentH;
@property (nonatomic, assign) CGFloat tableViewH;
@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, copy) goReceiveBlock block;

@end

@implementation SDHomePopView

static CGFloat const Margin = 6;
static NSString * const CellID = @"SDHomeCouponsCell<##>";

+ (instancetype)popViewWithCoupons:(NSArray *)coupons block:(goReceiveBlock)block {
    return [[self alloc] initWithPopViewWithCoupons:coupons block:block];
}

- (instancetype)initWithPopViewWithCoupons:(NSArray *)coupons block:(goReceiveBlock)block {
    if (self = [super init]) {
        self.coupons = coupons;
        self.block = block;
        [self countContentWH];
        [self addToWindow];
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.8];
        [self addGesture];
        [self initSubView];
        [self showSelf];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KHomePopViewShow];
    }
    return self;
}

- (void)countContentWH {
    self.contentW = SCREEN_WIDTH - 2 * Margin;
    self.contentH =  self.contentW * 867 / 726;
    self.cellH = 80;
    if (iPhone5 || iPhone4) {
        self.cellH = 70;
    }
    self.tableViewH = self.cellH * 2 + 5 + self.cellH - 5;
    
}

- (void)addToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    self.alpha = 1;
    self.contentBgIV.frame = CGRectMake(Margin, SCREEN_HEIGHT,self.contentW, self.contentH);
    [window addSubview:self];
}


- (void)addGesture{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewClick)];
    [self addGestureRecognizer:tap];
}

- (void)initSubView {
    [self addSubview:self.contentBgIV];
    [self.contentBgIV addSubview:self.titleLabel];
    [self.contentBgIV addSubview:self.tableView];
    [self.contentBgIV addSubview:self.bottomBgIV];
    [self.contentBgIV addSubview:self.receiveBtn];
    [self.contentBgIV addSubview:self.cancelBtn];
}

- (void)showSelf {
    SD_WeakSelf
    CGFloat contentY = (SCREEN_HEIGHT - self.contentH) * 0.5;
    CGFloat x = (SCREEN_WIDTH - self.contentW) * 0.5;
    self.contentBgIV.frame = CGRectMake(x, SCREEN_HEIGHT + contentY, self.contentW, self.contentH);
    [UIView animateWithDuration:0.40 animations:^{
        SD_StrongSelf
        self.alpha = 1;
        self.contentBgIV.frame = CGRectMake(x, contentY, self.contentW, self.contentH);
    } completion:^(BOOL finished) {

    }];
}

- (void)hideSelf {
    SD_WeakSelf
    CGFloat contentY = (SCREEN_HEIGHT - self.contentH) * 0.5;
    CGFloat x = (SCREEN_WIDTH - self.contentW) * 0.5;
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        SD_StrongSelf
        self.alpha = 0;
        self.contentBgIV.frame = CGRectMake(x, SCREEN_HEIGHT + contentY, self.contentW, self.contentH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [SDHomeDataManager sharedInstance].couponsArray = nil;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(self.tableViewH);
        make.bottom.mas_equalTo(self.bottomBgIV.mas_top).mas_equalTo(self.cellH + 5);
    }];
    
    CGFloat bottomBgIVH = self.contentH * 346 / 867;
    [self.bottomBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(bottomBgIVH);
    }];
    
    if (iPhone4 || iPhone5) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.centerX.mas_equalTo(self.contentBgIV.mas_centerX);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
            make.bottom.mas_equalTo(-15);
            make.height.mas_equalTo(40);
        }];
        
        [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
            make.bottom.mas_equalTo(self.cancelBtn.mas_top).mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
    }else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60);
            make.centerX.mas_equalTo(self.contentBgIV.mas_centerX);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(40);
        }];
        
        [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
            make.bottom.mas_equalTo(self.cancelBtn.mas_top).mas_equalTo(-15);
            make.height.mas_equalTo(40);
        }];
    }
    
    
}


#pragma mark - action
- (void)receiveBtnClick {
    if (![SDUserModel sharedInstance].isLogin) {
        self.block();
        [SDLoginViewController present];
    }
    [SDStaticsManager umEvent:kfresher_btn_receive];
    [self hideSelf];
}

- (void)cancelBtnClick {
    [SDStaticsManager umEvent:kfresher_btn_cancel];
    [self hideSelf];
}

- (void)popViewClick {
    [self hideSelf];
}


#pragma mark - lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:23];
        if (iPhone5 || iPhone4) {
            _titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:18];
        }
        _titleLabel.textColor = [UIColor colorWithRGB:0xFFF2C5];
        _titleLabel.text = @"新人享好礼";
    }
    return _titleLabel;
}
- (UIImageView *)contentBgIV {
    if (!_contentBgIV) {
        _contentBgIV = [[UIImageView alloc] init];
        _contentBgIV.userInteractionEnabled = YES;
        _contentBgIV.image = [UIImage imageNamed:@"home_pop_bg"];
    }
    return _contentBgIV;
}

- (UIImageView *)bottomBgIV {
    if (!_bottomBgIV) {
        _bottomBgIV = [[UIImageView alloc] init];
        _bottomBgIV.userInteractionEnabled = YES;
        _bottomBgIV.image = [UIImage imageNamed:@"home_pop_bottom_bg"];
    }
    return _bottomBgIV;
}

- (UIButton *)receiveBtn {
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_receiveBtn setTitle:@"去领取" forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:[UIColor colorWithRGB:0x723600] forState:UIControlStateNormal];
        _receiveBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.layer.cornerRadius = 20.0;
        NSArray *colors = @[[UIColor colorWithRGB:0xfcf3d9], [UIColor colorWithRGB:0xf2df9e]];
        NSArray *points = @[@(CGPointMake(0, 0)), @(CGPointMake(1, 1))];
        UIImage *image = [UIImage cp_gradientImageWithColors:colors points:points rect:CGRectMake(0, 0, 240, 40)];
        [_receiveBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_receiveBtn addTarget:self action:@selector(receiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithRGB:0xf7eabe] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 20.0;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = [UIColor colorWithRGB:0xF7EABE].CGColor;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[SDHomeCouponsCell class] forCellReuseIdentifier:CellID];
    }
    return _tableView;
}

- (NSArray *)coupons {
    if (!_coupons) {
        _coupons = [NSArray array];
    }
    return _coupons;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.coupons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDHomeCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    SDCouponsModel *model = self.coupons[indexPath.section];
    cell.couponsModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.coupons.count == 1) {
            return  (self.cellH  + 5) * 0.5;
        }
        return 0.0001;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.coupons.count - 1) {
        return self.cellH - 5;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}



@end
