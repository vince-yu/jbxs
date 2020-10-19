//
//  SDCartCouponsPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartCouponsPopView.h"
#import "SDMyCouponsCell.h"
#import "SDSegmentedControl.h"
#import "SDCartDataManager.h"
#import "SDCartOderModel.h"

@interface SDCartCouponsPopView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) SDSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) YYLabel *tipsLabel;
@property (nonatomic, strong) UIScrollView *bottomSc;
@property (nonatomic, strong) UIButton *confrimBtn;

/* -------- 数据 --------- */

/** 可用优惠数组 */
@property (nonatomic, strong) NSMutableArray *usableCoupons;
/** 不可用优惠数组 */
@property (nonatomic, strong) NSMutableArray *uselessCoupons;
@property (nonatomic, assign) CGFloat contentH;
@property (nonatomic, copy) SDConfirmBlock confirmBlock;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *tableViewArr;

/** 使用普通优惠券Model */
@property (nonatomic, strong) SDCouponsModel *couponModel;
/** 使用运费优惠券Model */
@property (nonatomic, strong) SDCouponsModel *freightModel;
/** 预下单返回的数据 */
@property (nonatomic, strong) SDCartOderModel *orderModel;
/** 预下单请求的数据 */
@property (nonatomic, strong) SDCartOderRequestModel *prepayModel;

@end

@implementation SDCartCouponsPopView

static NSString * const CellID = @"SDMyCouponsCell<##>";

+ (instancetype)popViewWithOrderModel:(SDCartOderModel *)orderModel confirmBlock:(SDConfirmBlock)confirmBlock {
    return [[self alloc] initWithPopViewWithOrderModel:orderModel confirmBlock:confirmBlock];
}


- (instancetype)initWithPopViewWithOrderModel:(SDCartOderModel *)orderModel confirmBlock:(SDConfirmBlock)confirmBlock {
    if (self = [super init]) {
        self.orderModel = [[SDCartOderModel alloc] init];
        [self.orderModel mj_setKeyValues:orderModel];
        self.prepayModel = [[SDCartOderRequestModel alloc] init];
        SDCartOderRequestModel *prepayModel =[SDCartDataManager sharedInstance].prepayModel;
        self.prepayModel = [SDCartOderRequestModel mj_objectWithKeyValues:[prepayModel mj_JSONObject]];
        [self setupCouponData];
        self.confirmBlock = confirmBlock;
        self.contentH = SCREEN_HEIGHT * 0.8;
        [self addToWindow];
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
//        [self addGesture];
        [self initSubView];
        [self showSelf];
        [self setupStatusLabel];
    }
    return self;
}

- (void)setupCouponData {
    [self.usableCoupons removeAllObjects];
    [self.uselessCoupons removeAllObjects];
    self.freightModel = nil;
    self.couponModel = nil;
    for (SDCouponsModel *model in self.orderModel.voucher) {
        if (model.usable) {
            model.displayType = SDCouponsDisplayTypeRadioBox;
            [self.usableCoupons addObject:model];
        }else {
            model.displayType = SDCouponsDisplayTypeNone;
            [self.uselessCoupons addObject:model];
        }
        if (model.used) { // 被使用
            if ([model.type isEqualToString:@"4"]) { // 运费券
                self.freightModel = model;
            }else {
                self.couponModel = model;
            }
        }
    }
    
    if (self.couponModel) {
        for (SDCouponsModel *model in self.usableCoupons) {
            if ([model.type isEqualToString:@"4"]) {
                continue;
            }
            if (![model.couponsId isEqualToString:self.couponModel.couponsId]) {
                model.mutex = YES;
            }
        }
    }
    
    if (self.freightModel) {
        for (SDCouponsModel *model in self.usableCoupons) {
            if (![model.type isEqualToString:@"4"] ) {
                continue;
            }
            if (![model.couponsId isEqualToString:self.freightModel.couponsId]) {
                model.mutex = YES;
            }
        }
    }
    
    [self setupTipsLabelData];
    [self.titleArr removeAllObjects];
    [self.titleArr addObject:[NSString stringWithFormat:@"可用优惠券(%lu张)", (unsigned long)self.usableCoupons.count]];
    [self.titleArr addObject:[NSString stringWithFormat:@"不可用优惠券(%lu张)", (unsigned long)self.uselessCoupons.count]];
}

- (void)setupStatusLabel {
    int count = 0;
    if (self.usableCoupons.count > 0) {
        for (SDCouponsModel *model in self.usableCoupons) {
            if (model.used) {
                count++;
            }
        }
        if (count == 0) {
            self.tipsLabel.text = @"请选择优惠券";
            return;
        }
        NSString *reducePriceStr = [self.orderModel.reducePrice priceStr];
        NSString *tipsStr = [NSString stringWithFormat:@"已选中推荐优惠，使用优惠券%d张，共优惠￥%@元", count, reducePriceStr];
        NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:tipsStr];
        attrM.yy_font = [UIFont fontWithName:kSDPFMediumFont size:11];
        attrM.yy_color = [UIColor colorWithRGB:0x131413];
        NSRange range = NSMakeRange(tipsStr.length - reducePriceStr.length - 1 - 1, reducePriceStr.length + 1);
        [attrM yy_setColor:[UIColor colorWithHexString:kSDGreenTextColor] range:range];
        self.tipsLabel.attributedText = attrM;
    }
}

- (void)setupTipsLabelData {
    int count = 0;
    for (SDCouponsModel *model in self.usableCoupons) {
        if (model.used) {
            count++;
        }
    }
    NSString *reducePriceStr = [self.orderModel.reducePrice priceStr];
    NSString *tipsStr = [NSString stringWithFormat:@"已选择%d张优惠券，共优惠￥%@元", count, reducePriceStr];
    if (count == 0) {
        tipsStr = @"请选择优惠券";
        self.tipsLabel.text = tipsStr;
    }else {
//        已选择x张优惠券，共优惠¥x元
        NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:tipsStr];
        attrM.yy_font = [UIFont fontWithName:kSDPFMediumFont size:11];
        attrM.yy_color = [UIColor colorWithRGB:0x131413];
        NSRange range = NSMakeRange(tipsStr.length - reducePriceStr.length - 1 - 1, reducePriceStr.length + 1);
        [attrM yy_setColor:[UIColor colorWithHexString:kSDGreenTextColor] range:range];
        self.tipsLabel.attributedText = attrM;
    }
    
}

- (void)addToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    self.alpha = 1;
    self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.contentH);
    [window addSubview:self];
}

- (void)addGesture{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewClick)];
    [self addGestureRecognizer:tap];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)initSubView {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.segmentedControl];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.closeBtn];
    [self.contentView addSubview:self.tipsView];
    [self.tipsView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.bottomSc];
    [self.bottomSc addSubview:self.confrimBtn];
    for (int i = 0; i < self.titleArr.count; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = [UIColor colorWithRGB:0xF5F5F7];
        tableView.tag = 100 + i;
        tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        [tableView registerClass:[SDMyCouponsCell class] forCellReuseIdentifier:CellID];
        [self.tableViewArr addObject:tableView];
        [self.bottomSc addSubview:tableView];
    }
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
        make.height.mas_equalTo(85);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 57));
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-5);
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.and.bottom.mas_equalTo(0);
    }];
    
    [self.bottomSc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.top.mas_equalTo(self.tipsView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    for (UITableView *tableView in self.tableViewArr) {
        if (tableView.tag == 100) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(self.bottomSc).mas_equalTo(-86);
                make.left.mas_equalTo(SCREEN_WIDTH * (tableView.tag - 100));
            }];
            
            [self.confrimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
                make.left.mas_equalTo(15);
                make.width.mas_equalTo(SCREEN_WIDTH - 2 * 15);
                make.top.mas_equalTo(tableView.mas_bottom).mas_equalTo(20);
            }];
        }else {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(self.bottomSc);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.left.mas_equalTo(SCREEN_WIDTH * (tableView.tag - 100));
            }];
        }
       
    }
}


#pragma mark - action
- (void)popViewClick {
    [self hideSelf];
}

- (void)closeBtnClick {
    [self hideSelf];
}

- (void)confirmBtnClick {
    [SDStaticsManager umEvent:kpurchase_coupon_sure];
    [SDCartDataManager sharedInstance].preOrderModel = self.orderModel;
    [SDCartDataManager sharedInstance].prepayModel = self.prepayModel;
    if (self.confirmBlock) {
        self.confirmBlock(self.couponModel, self.freightModel);
    }
    [self hideSelf];
}

#pragma mark - network
- (void)prepayNomalOrder:(SDCouponsModel *)usedModel {
    /** 运费券Id */
    NSString *freightId = @" ";
    if (self.freightModel) {
        freightId = self.freightModel.couponsId;
    }
     /** 优惠券Id */
    NSString *coupondsId = @" ";
    if (self.couponModel) {
        coupondsId = self.couponModel.couponsId;
    }
    
    if ([usedModel.type isEqualToString:@"4"]) { // 优惠券
        freightId = usedModel.isUsed ? @"" : usedModel.couponsId;
    }else { // 现金券 满减券 折扣券
        coupondsId = usedModel.isUsed ? @"" : usedModel.couponsId;
    }
    self.prepayModel.voucherId = coupondsId;
    self.prepayModel.freighVoucherId = freightId;
//    if (self.couponModel) {
//        [SDCartDataManager sharedInstance].prepayModel.voucherId = self.couponModel.couponsId;
//    }else {
//        [SDCartDataManager sharedInstance].prepayModel.voucherId = @"";
//    }
//
//    if (self.freightModel) {
//         [SDCartDataManager sharedInstance].prepayModel.freighVoucherId = self.freightModel.couponsId;
//    }else {
//         [SDCartDataManager sharedInstance].prepayModel.freighVoucherId = @"";
//    }
    if (self.prepayModel.type == SDGoodTypeGroup) {
        SD_WeakSelf
        [SDCartDataManager prepaySystemGroupOrderWithOrderRequestModel:self.prepayModel completeBlock: ^(id model){
            SD_StrongSelf;
            self.orderModel = (SDCartOderModel *)model;
            [self setupCouponData];
            [self setupTipsLabelData];
            if (self.orderModel.couponAlert.length) {
                [SDToastView HUDWithWarnString:self.orderModel.couponAlert];
            }
            for (UITableView *tableView in self.tableViewArr) {
                [tableView reloadData];
            }
        } failedBlock:^(id model){
        }];
    }else{
        SD_WeakSelf
        [SDCartDataManager prepayNomalOrderWithOrderRequestModel:self.prepayModel isCartTO:NO completeBlock: ^(id model){
            SD_StrongSelf;
            self.orderModel = (SDCartOderModel *)model;
            if (self.orderModel.couponAlert.length) {
                [SDToastView HUDWithWarnString:self.orderModel.couponAlert];
            }
            [self setupCouponData];
            [self setupTipsLabelData];
            for (UITableView *tableView in self.tableViewArr) {
                [tableView reloadData];
            }
        } failedBlock:^(id model){
        }];
    }
    
}

#pragma mark - lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithRGB:0xF5F5F7];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.userInteractionEnabled = YES;
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:18];
        _titleLabel.textColor = [UIColor colorWithRGB:0x131413];
        _titleLabel.text = @"优惠券";
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
        _tipsView.backgroundColor = [UIColor colorWithRGB:0x16BC2E alpha:0.1];
    }
    return _tipsView;
}

- (YYLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[YYLabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
        _tipsLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
    return _tipsLabel;
}

- (SDSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[SDSegmentedControl alloc] initWithSectionTitles:self.titleArr];
        _segmentedControl.selectedSegmentIndex = 0;
        SD_WeakSelf
        _segmentedControl.block = ^(NSInteger index) {
            SD_StrongSelf
            CGPoint offset = CGPointMake(index * SCREEN_WIDTH, 0);
            if (index) {
                [SDStaticsManager umEvent:kpurchase_coupon_tab2];
            }else{
                [SDStaticsManager umEvent:kpurchase_coupon_tab1];
            }
            [self.bottomSc setContentOffset:offset animated:YES];
        };
        _segmentedControl.userInteractionEnabled = YES;
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x131413], NSFontAttributeName : [UIFont fontWithName:kSDPFRegularFont size: 12]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:kSDGreenTextColor], NSFontAttributeName : [UIFont fontWithName:kSDPFMediumFont size: 12]};
    }
    return _segmentedControl;
}

- (UIScrollView *)bottomSc {
    if (!_bottomSc) {
        _bottomSc = [[UIScrollView alloc] init];
        _bottomSc.backgroundColor = [UIColor colorWithRGB:0xF5F5F7];
        _bottomSc.pagingEnabled = YES;
        _bottomSc.showsHorizontalScrollIndicator = NO;
        _bottomSc.bounces = NO;
        _bottomSc.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleArr.count, 0);
        _bottomSc.delegate = self;
    }
    return _bottomSc;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)tableViewArr {
    if (!_tableViewArr) {
        _tableViewArr = [NSMutableArray array];
    }
    return _tableViewArr;
}

- (UIButton *)confrimBtn {
    if (!_confrimBtn) {
        _confrimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confrimBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        [_confrimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confrimBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confrimBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _confrimBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _confrimBtn.layer.masksToBounds = YES;
        _confrimBtn.layer.cornerRadius = 22;
    }
    return _confrimBtn;
}

- (NSMutableArray *)usableCoupons {
    if (!_usableCoupons) {
        _usableCoupons = [NSMutableArray array];
    }
    return _usableCoupons;
}

- (NSMutableArray *)uselessCoupons {
    if (!_uselessCoupons) {
        _uselessCoupons = [NSMutableArray array];
    }
    return _uselessCoupons;
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
         return self.usableCoupons.count;
    }else {
        return self.uselessCoupons.count;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDMyCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    SDCouponsModel *model = nil;
    if (tableView.tag == 100) {
        model = self.usableCoupons[indexPath.section];
    }else {
        model = self.uselessCoupons[indexPath.section];
    }
    cell.couponsModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        SDCouponsModel *usedModel = self.usableCoupons[indexPath.section];
        if (usedModel.isUsed) {
            [self prepayNomalOrder:usedModel];
            return;
        }
        BOOL existUsed = NO;
        if ([usedModel.type isEqualToString:@"4"]) {
            existUsed = self.freightModel ? YES : NO;
        }else {
            existUsed = self.couponModel ? YES : NO;
        }
        if (existUsed) {
            [SDToastView HUDWithWarnString:@"请先取消已勾选优惠券再选择"];
        }else {
            [self prepayNomalOrder:usedModel];
        }
//        if (usedModel.displayType == SDCouponsDisplayTypeRadioBox) {
//            if (usedModel.isUsed) {
//                usedModel.used = NO;
//                if ([usedModel.type isEqualToString:@"4"]) {
//                    self.freightModel = nil;
//                }else {
//                    self.couponModel = nil;
//                }
//                [self prepayNomalOrder];
//                for (SDCouponsModel *model in self.usableCoupons) {
//                    if ([usedModel.type isEqualToString:@"4"]) {
//                        if (![model.type isEqualToString:@"4"]) {
//                            continue;
//                        }
//                        model.mutex = NO;
//                    }else {
//                        if ([model.type isEqualToString:@"4"]) {
//                            continue;
//                        }
//                        model.mutex = NO;
//                    }
//                }
//                [tableView reloadData];
//            }else {
//                if ([usedModel.type isEqualToString:@"4"]) { // 运费券
//                    BOOL existUsed = NO;
//                    for (SDCouponsModel *model in self.usableCoupons) {
//                        if (![model.type isEqualToString:@"4"]) {
//                            continue;
//                        }
//                        if (model.isUsed) {
//                            existUsed = YES;
//                        }
//                    }
//                    if (existUsed) {
//                        [SDToastView HUDWithWarnString:@"请先取消已勾选优惠券再选择"];
//                    }else {
//                        for (SDCouponsModel *model in self.usableCoupons) {
//                            if (![model.type isEqualToString:@"4"]) {
//                                continue;
//                            }
//                            if ([model.couponsId isEqualToString:usedModel.couponsId]) {
//                                model.used = YES;
//                                model.mutex = NO;
//                                self.freightModel = model;
//                                [self prepayNomalOrder];
//                            }else {
//                                model.used = NO;
//                                model.mutex = YES;
//                            }
//                        }
//                        [tableView reloadData];
//                    }
//                }else {
//                    BOOL existUsed = NO;
//                    for (SDCouponsModel *model in self.usableCoupons) {
//                        if ([model.type isEqualToString:@"4"]) {
//                            continue;
//                        }
//                        if (model.isUsed) {
//                            existUsed = YES;
//                        }
//                    }
//                    if (existUsed) {
//                        [SDToastView HUDWithWarnString:@"请先取消已勾选优惠券再选择"];
//                    }else {
//                        for (SDCouponsModel *model in self.usableCoupons) {
//                            if ([model.type isEqualToString:@"4"]) {
//                                continue;
//                            }
//                            if ([model.couponsId isEqualToString:usedModel.couponsId]) {
//                                model.used = YES;
//                                model.mutex = NO;
//                                self.couponModel = model;
//                                [self prepayNomalOrder];
//                            }else {
//                                model.used = NO;
//                                model.mutex = YES;
//                            }
//                        }
//                        [tableView reloadData];
//                    }
//                }
//            }
//        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        SDCouponsModel *model = self.usableCoupons[indexPath.section];
        if (model.isMutex) {
            return 90 + 19;
        }
        return 90;
    }
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (section == self.usableCoupons.count - 1) {
            return 10;
        }
        return 0.0001;
    }else {
        if (section == self.uselessCoupons.count - 1) {
            return 10;
        }
        return 0.0001;
    }
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

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//        int index = scrollView.contentOffset.x / SCREEN_WIDTH;
//        UIViewController *willShowChildVc = self.childViewControllers[index];
//
//        if (willShowChildVc.isViewLoaded && willShowChildVc.view.window) return;
//
//        willShowChildVc.view.frame = scrollView.bounds;
//        [scrollView addSubview:willShowChildVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    [self scrollViewDidEndScrollingAnimation:scrollView];
    int index = scrollView.contentOffset.x / scrollView.width;
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
}


@end

