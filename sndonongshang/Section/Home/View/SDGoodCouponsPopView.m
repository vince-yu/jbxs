//
//  SDGoodCouponsPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodCouponsPopView.h"
#import "SDMyCouponsCell.h"
#import "SDJumpManager.h"

@interface SDGoodCouponsPopView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *couponsNumLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, assign) CGFloat contentH;

@end

@implementation SDGoodCouponsPopView

static NSString * const CellID = @"SDMyCouponsCell<##>";

+ (instancetype)popViewWithCoupons:(NSArray *)coupons {
    return [[self alloc] initWithPopViewWithCoupons:coupons];
}

- (instancetype)initWithPopViewWithCoupons:(NSArray *)coupons {
    if (self = [super init]) {
        self.coupons = coupons;
        self.contentH = SCREEN_HEIGHT * 0.8;
        [self addToWindow];
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
        [self addGesture];
        [self initSubView];
        [self showSelf];
    }
    return self;
}

- (void)addToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    self.alpha = 1;
    self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.contentH);
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [window addSubview:self];
}

- (void)addGesture{
    self.bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewClick)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)initSubView {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.couponsNumLabel];
    [self.topView addSubview:self.closeBtn];
    [self.contentView addSubview:self.tableView];
}

- (void)showSelf {
    SD_WeakSelf
    CGFloat contentY = SCREEN_HEIGHT - self.contentH;
    self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT + contentY, SCREEN_WIDTH, self.contentH);
    [UIView animateWithDuration:0.40 animations:^{
        SD_StrongSelf
        self.alpha = 1;
        self.contentView.frame = CGRectMake(0, contentY, SCREEN_WIDTH, self.contentH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSelf {
    SD_WeakSelf
    CGFloat contentY = SCREEN_HEIGHT - self.contentH;
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        SD_StrongSelf
        self.alpha = 0;
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT + contentY,SCREEN_WIDTH, self.contentH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(57);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 57));
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
    }];
    
    [self.couponsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.closeBtn.mas_left).mas_equalTo(-8);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}


#pragma mark - action
- (void)popViewClick {
    [self hideSelf];
}


#pragma mark - lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
       _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
        _titleLabel.textColor = [UIColor colorWithRGB:0x131413];
        _titleLabel.text = @"优惠券";
    }
    return _titleLabel;
}

- (UILabel *)couponsNumLabel {
    if (!_couponsNumLabel) {
        _couponsNumLabel = [[UILabel alloc] init];
        NSInteger voucherCount = [self voucherNum];
        NSString *couponsNum = [NSString stringWithFormat:@"共%lu张", (unsigned long)voucherCount];
        _couponsNumLabel.text = couponsNum;
        _couponsNumLabel.textColor = [UIColor colorWithHexString:kSDGrayTextColor];
        _couponsNumLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
        if ([SDUserModel sharedInstance].activiting && voucherCount <= 0) {
            _couponsNumLabel.hidden = YES;
        }else{
            _couponsNumLabel.hidden = NO;
        }
    }
    return _couponsNumLabel;
}
- (NSInteger )voucherNum{
    NSInteger count = 0;
    for (SDCouponsModel *coupon in self.coupons) {
        if (!coupon.notObtain) {
            count ++;
        }
    }
    return count;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(popViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRGB:0xF5F5F7];
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
        [_tableView registerClass:[SDMyCouponsCell class] forCellReuseIdentifier:CellID];
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
    SDMyCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    SDCouponsModel *model = [self.coupons objectAtIndex:indexPath.section];
    cell.couponsModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDCouponsModel *model = [self.coupons objectAtIndex:indexPath.section];
    if (model.notObtain && [SDUserModel sharedInstance].activiting) {
        [SDJumpManager jumpUrl:kH5NewUser push:YES parentsController:nil animation:YES];
    }
    [self hideSelf];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.coupons.count - 1) {
        return 10;
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
