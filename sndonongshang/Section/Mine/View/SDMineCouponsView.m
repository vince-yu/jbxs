
//
//  SDMineCouponsView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/27.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineCouponsView.h"
#import "SDArrowButton.h"
#import "SDMyCouponsViewController.h"
#import "SDLoginViewController.h"
#import "SDJumpManager.h"

@interface SDMineCouponsView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SDArrowButton *couponsButton;

@end

@implementation SDMineCouponsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return  self;
}

- (void)initSubView {
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

- (void)setCouponsNum:(NSString *)couponsNum {
    _couponsNum = couponsNum;
    NSString *couponsStr = [NSString stringWithFormat:@"%@张", couponsNum];
    if (couponsNum.integerValue == 0 && [SDUserModel sharedInstance].activiting) {
        couponsStr = @"领取";
    }
    [self.couponsButton setTitle:couponsStr forState:UIControlStateNormal];
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
- (void)couponsBtnClick {
    [SDStaticsManager umEvent:kme_coupon];
    if (![self checkIsLogin]) return;
    if ([self.couponsButton.titleLabel.text isEqualToString:@"领取"] && self.couponsNum.integerValue == 0 && [SDUserModel sharedInstance].activiting) {
        [SDJumpManager jumpUrl:kH5NewUser push:YES parentsController:nil animation:YES];
        return;
    }
    SDMyCouponsViewController *vc  = [[SDMyCouponsViewController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"优惠券";
        _titleLabel.textColor = [UIColor colorWithRGB:0x131413];
        _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    }
    return _titleLabel;
}

- (SDArrowButton *)couponsButton {
    if (!_couponsButton) {
        _couponsButton = [SDArrowButton buttonWithType:UIButtonTypeCustom];
        [_couponsButton setTitle:@"0张" forState:UIControlStateNormal];
        [_couponsButton addTarget:self action:@selector(couponsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _couponsButton;
}

- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
        _iconIv.image = [UIImage imageNamed:@"mine_coupons"];
    }
    return _iconIv;
}

@end
