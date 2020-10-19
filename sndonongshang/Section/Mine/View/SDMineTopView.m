//
//  SDMineTopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineTopView.h"
#import "SDSettingButton.h"
#import "SDArrowButton.h"
#import "SDMyAccountViewController.h"
#import "SDMyCouponsViewController.h"
#import "SDSettingViewController.h"
#import "SDLoginViewController.h"

@interface SDMineTopView ()

@property (nonatomic, strong) UIImageView *greenBGView;
@property (nonatomic, strong) UIImageView *avatorIv;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) SDSettingButton *settingBtn;
@property (nonatomic, strong) SDArrowButton *couponsButton;
@property (nonatomic, strong) UIButton *noLoginBtn;
/** 团长标签 */
@property (nonatomic, strong) UIButton *grouperBtn;

@end

@implementation SDMineTopView

static CGFloat const avaterWH = 50;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUserData) name:kNotifiChangeRoler object:nil];
        [self initSubView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSubView {
    
    [self addSubview:self.greenBGView];
    [self addSubview:self.avatorIv];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.settingBtn];
    [self addSubview:self.noLoginBtn];
    [self addSubview:self.grouperBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.greenBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    self.avatorIv.frame = CGRectMake(15, 10, avaterWH, avaterWH);
    
    [self.noLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.left.mas_equalTo(15 + avaterWH + 20);
        make.top.mas_equalTo(20);
    }];
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

/** 设置电话号码和地址 */
- (void)setupPhone:(NSString *)phone address:(NSString *)address {
    CGFloat x = 15 + avaterWH + 20;
    CGFloat w = SCREEN_WIDTH - x - 65;
    self.phoneLabel.text = phone;
    self.addressLabel.text = address;
    if (!address || [address isEmpty]) {
        self.phoneLabel.frame = CGRectMake(x, 10, w, avaterWH);
    }else {
        self.phoneLabel.frame = CGRectMake(x, 10, w, avaterWH);
        [self.phoneLabel sizeToFit];
        CGFloat marigin = 4;
        CGFloat addressH = [address sizeWithFont:[UIFont fontWithName:kSDPFMediumFont size:12] maxSize:CGSizeMake(w, 35)].height;
        CGFloat totalH = self.phoneLabel.cp_h + marigin + addressH;
        CGFloat phoneY = (avaterWH - totalH) * 0.5 ;
        phoneY = phoneY > 0 ? phoneY : 0;
        self.phoneLabel.cp_x = x;
        self.phoneLabel.cp_y = phoneY;
        CGFloat addressY = CGRectGetMaxY(self.phoneLabel.frame) + marigin;
        self.addressLabel.frame = CGRectMake(x, addressY, w, addressH);
    }
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeGrouper || [SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        self.grouperBtn.hidden = NO;
        self.grouperBtn.frame = CGRectMake(CGRectGetMaxX(self.phoneLabel.frame) + 3, 0, 36, 18);
        if (!address || [address isEmpty]) {
            self.grouperBtn.cp_y = avaterWH * 0.5 - 10;
            CGFloat width = [phone sizeWithFont:[UIFont fontWithName:kSDPFMediumFont size:16] maxSize:CGSizeMake(w, 24)].width;
            self.grouperBtn.cp_x = x + width + 3;
        }
    }else {
        self.grouperBtn.hidden = YES;
    }
}


/** 设置用户数据 */
- (void)setupUserData {
    SDUserModel *userModel = [SDUserModel sharedInstance];
    [self.avatorIv sd_setImageWithURL:[NSURL URLWithString:userModel.header] placeholderImage:[UIImage imageNamed:@"mine_avator"]];
    NSString *phone = [userModel.mobile secretStrFromPhoneStr];
    if (userModel.binded_wechat) {
        phone = userModel.nickname;
    }
    [self setupPhone:phone address:userModel.address];
    self.noLoginBtn.hidden = [SDUserModel sharedInstance].isLogin ? YES : NO;

}


#pragma mark - action
- (void)avaterClick {
    if (![self checkIsLogin]) return;
    SDMyAccountViewController *vc = [[SDMyAccountViewController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)settingClick {
    [SDStaticsManager umEvent:kme_setting];
    SDSettingViewController *vc = [[SDSettingViewController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)noLoginBtnClick {
    [SDStaticsManager umEvent:kme_login];
    if (![self checkIsLogin]);
}

#pragma mark - lazy
- (UIImageView *)greenBGView {
    if (!_greenBGView) {
        _greenBGView = [[UIImageView alloc] init];
        _greenBGView.image = [UIImage cp_imageByCommonGreenWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.cp_h)];
    }
    return _greenBGView;
}

- (UIImageView *)avatorIv {
    if (!_avatorIv) {
        _avatorIv = [[UIImageView alloc] init];
        _avatorIv.contentMode = UIViewContentModeScaleAspectFit;
        _avatorIv.userInteractionEnabled = YES;
        _avatorIv.layer.cornerRadius = avaterWH * 0.5;
        _avatorIv.layer.masksToBounds = YES;
        NSURL *headerURL = [NSURL URLWithString:[SDUserModel sharedInstance].header];
        [_avatorIv sd_setImageWithURL:headerURL placeholderImage:[UIImage imageNamed:@"mine_avator"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterClick)];
        [_avatorIv addGestureRecognizer:tap];
    }
    return _avatorIv;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterClick)];
        [_phoneLabel addGestureRecognizer:tapGes];
        
        SDUserModel *userModel = [SDUserModel sharedInstance];
        _phoneLabel.text = userModel.binded_wechat ? userModel.nickname : userModel.mobile;
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 2;
        _addressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.alpha = 0.8;
        //        _addressLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 * 2 - avaterWH - 20;
    }
    return _addressLabel;
}
- (SDSettingButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [SDSettingButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (UIButton *)noLoginBtn {
    if (!_noLoginBtn) {
        _noLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noLoginBtn setTitle:@"登录或注册" forState:UIControlStateNormal];
        [_noLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _noLoginBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _noLoginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _noLoginBtn.layer.borderWidth = 0.5;
        _noLoginBtn.layer.cornerRadius = 15;
        _noLoginBtn.layer.masksToBounds = YES;
        [_noLoginBtn addTarget:self action:@selector(noLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noLoginBtn;
}

- (UIButton *)grouperBtn {
    if (!_grouperBtn) {
        _grouperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_grouperBtn setTitle:@"团长" forState:UIControlStateNormal];
        [_grouperBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
        _grouperBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
        UIImage *backgroundImage = [UIImage cp_imageWithColor:[UIColor whiteColor] byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadius:9 size:CGSizeMake(36, 18)];
        [_grouperBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        _grouperBtn.userInteractionEnabled = NO;
    }
    return _grouperBtn;
}

@end
