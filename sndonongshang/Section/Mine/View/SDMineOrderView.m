//
//  SDMineOrderView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineOrderView.h"
#import "SDArrowButton.h"
#import "SDMineButton.h"
#import "SDLoginViewController.h"
#import "SDMyOrderViewController.h"
#import "SDMineModel.h"

@interface SDMineOrderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SDArrowButton *allOrderBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSArray *mineOrderArr;
@property (nonatomic, strong) NSMutableArray *orderBtnArr;
@end

@implementation SDMineOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {

    [self addSubview:self.allOrderBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    
    
    for (int i = 0; i < self.self.mineOrderArr.count; i++) {
        SDMineModel *mineModel = self.mineOrderArr[i];
        SDMineButton *orderBtn = [SDMineButton buttonWithType:UIButtonTypeCustom];
        orderBtn.margin = 10;
        orderBtn.tag = 200 + i;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setTitle:mineModel.title forState:UIControlStateNormal];
        [orderBtn setImage:[UIImage imageNamed:mineModel.icon] forState:UIControlStateNormal];
        [self addSubview:orderBtn];
        [self.orderBtnArr addObject:orderBtn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(0);
    }];
    
    [self.allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat orderBtnW = SCREEN_WIDTH / self.orderBtnArr.count;
    CGFloat orderBtnH = 74;
    for (int i = 0; i < self.orderBtnArr.count; i++) {
        SDMineButton *orderBtn = self.orderBtnArr[i];
        CGFloat orderX = orderBtnW * i;
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(orderBtnW, orderBtnH));
            make.left.mas_equalTo(orderX);
            make.top.mas_equalTo(self.lineView.mas_bottom);
        }];

    }
}

/**
 检查是否登录 没有登录弹出登录页面
 */
- (BOOL)checkIsLogin {
    if (![SDReachability sharedInstance].haveNetworking) {
        [SDToastView HUDWithErrString:@"当前无法访问网络，请检查网络设置!"];
        return NO;
    }
    if (![[SDUserModel sharedInstance] isLogin]) {
        [SDLoginViewController present];
        return NO;
    }
    return YES;
}


#pragma mark - action
- (void)goAllOrderBtnClick {
    [SDStaticsManager umEvent:kme_order_total];
    if (![self checkIsLogin]) return;
    SDMyOrderViewController *vc = [[SDMyOrderViewController alloc] init];
    vc.orderType = SDOrderTypeAll;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)orderBtnClick:(SDMineButton *)clickBtn {
    if (![self checkIsLogin]) return;
    SDMyOrderViewController *vc = [[SDMyOrderViewController alloc] init];
    vc.orderType = clickBtn.tag - 200;
    switch (vc.orderType) {
            case SDOrderTypeAll:
            [SDStaticsManager umEvent:kme_order_all];
            break;
            case SDOrderTypeNoPay:
            [SDStaticsManager umEvent:kme_order_topay];
            break;
            case SDOrderTypeNoReceive:
            [SDStaticsManager umEvent:kme_order_dsh];
            break;
            case SDOrderTypeDone:
            [SDStaticsManager umEvent:kme_order_complete];
            break;
        default:
            break;
    }
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的订单";
        _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _titleLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
    return _titleLabel;
}

- (SDArrowButton *)allOrderBtn {
    if (!_allOrderBtn) {
        _allOrderBtn = [SDArrowButton buttonWithType:UIButtonTypeCustom];
        [_allOrderBtn setTitle:@"全部订单" forState:UIControlStateNormal];
        [_allOrderBtn addTarget:self action:@selector(goAllOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allOrderBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _lineView;
}

- (NSMutableArray *)orderBtnArr {
    if (!_orderBtnArr) {
        _orderBtnArr = [NSMutableArray array];
    }
    return _orderBtnArr;
}

- (NSArray *)mineOrderArr {
    if (!_mineOrderArr) {
        NSArray *tempArr = @[@{@"title" : @"全部", @"icon" : @"mine_order_all"},
                             @{@"title" : @"待付款", @"icon" : @"mine_order_no_pay"},
                             @{@"title" : @"待收货", @"icon" : @"mine_order_goods"},
                             @{@"title" : @"已完成", @"icon" : @"mine_order_finish"}
                             ];
        _mineOrderArr = [SDMineModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    return _mineOrderArr;
}


@end
