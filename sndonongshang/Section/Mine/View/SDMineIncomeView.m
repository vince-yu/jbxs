//
//  SDMineIncomeView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineIncomeView.h"
#import "SDArrowButton.h"
#import "SDLoginViewController.h"
#import "SDGrouperTabBarController.h"

@interface SDMineIncomeView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SDArrowButton *incomeButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SDMineIncomeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return  self;
}

- (void)initSubView {
    [self addSubview:self.lineView];
    [self addSubview:self.couponsButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconIv];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconIv.mas_right).mas_equalTo(6);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.couponsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(0);
    }];
}

- (void)setBrokerage:(NSString *)brokerage {
    _brokerage = brokerage;
    NSString *title = [NSString stringWithFormat:@"%@元", [_brokerage priceStr]];
    if (!brokerage) {
        title = @"0.00元";
    }
    [self.incomeButton setTitle:title forState:UIControlStateNormal];
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
- (void)incomeBtnClick {
    [SDStaticsManager umEvent:kme_commission];
    if (![self checkIsLogin]) return;
        self.viewController.view.backgroundColor = [UIColor colorWithRGB:0x39CF11 alpha:0.9];
        [self.viewController.navigationController.navigationBar setHidden:YES];
        self.viewController.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        SDGrouperTabBarController *tab = [[SDGrouperTabBarController alloc] init];
    //        [self.viewController.navigationController presentViewController:tab animated:YES completion:nil];
        [self.viewController.navigationController pushViewController:tab.tab animated:YES];
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"佣金";
        _titleLabel.textColor = [UIColor colorWithRGB:0x131413];
        _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    }
    return _titleLabel;
}

- (SDArrowButton *)couponsButton {
    if (!_incomeButton) {
        _incomeButton = [SDArrowButton buttonWithType:UIButtonTypeCustom];
        [_incomeButton setTitle:@"" forState:UIControlStateNormal];
        [_incomeButton addTarget:self action:@selector(incomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomeButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _lineView;
}

- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
        _iconIv.image = [UIImage imageNamed:@"mine_income"];
    }
    return _iconIv;
}

@end
