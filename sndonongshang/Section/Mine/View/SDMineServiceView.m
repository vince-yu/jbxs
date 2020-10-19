//
//  SDMineServiceView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineServiceView.h"
#import "SDArrowButton.h"
#import "SDMineButton.h"
#import "SDAddressMgrViewController.h"
#import "SDLoginViewController.h"
#import "SDMineModel.h"
#import "SDRecruitViewController.h"
#import "SDChangeRolerPopView.h"
#import "SDSetRoleRequest.h"
#import "SDGrouperOrdrController.h"
#import "SDJumpManager.h"
#import "SDMyIncomeViewController.h"
#import "SDGrouperTabBarController.h"
#import "SDServerHelpView.h"

@interface SDMineServiceView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *serviceArr;
@property (nonatomic, strong) NSMutableArray *serviceBtnArr;

@end

@implementation SDMineServiceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    for (int i = 0; i < self.serviceArr.count; i++) {
        SDMineModel *mineModel = self.serviceArr[i];
        SDMineButton *serviceBtn = [SDMineButton buttonWithType:UIButtonTypeCustom];
        [serviceBtn setTitle:mineModel.title forState:UIControlStateNormal];
        [serviceBtn setImage:[UIImage imageNamed:mineModel.icon] forState:UIControlStateNormal];
        serviceBtn.margin = 13;
        serviceBtn.tag = 300 + i;
        [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:serviceBtn];
        [self.serviceBtnArr addObject:serviceBtn];
    }
    
}

//- (void)setGrouper:(BOOL)grouper {
//    _grouper = grouper;
//    [self.serviceArr removeAllObjects];
//    for (SDMineButton *serviceBtn in self.serviceBtnArr) {
//        [serviceBtn removeFromSuperview];
//    }
//    [self.serviceBtnArr removeAllObjects];
//
//    self.serviceArr addObject:@{@"title" : @"我是团长", @"icon" : @"mine_address"}
//    NSArray *tempArr = @[@{@"title" : @"收货地址", @"icon" : @"mine_address"},
//                         @{@"title" : @"售后电话", @"icon" : @"mine_service"}
//                         ];
//    //  _serviceArr = @[@"我是团长", @"我的淘客", @"收货地址", @"客服与售后"];
//    _serviceArr = [SDMineModel mj_objectArrayWithKeyValuesArray:tempArr];
//
//}

- (void)addServicesBtn {
    for (int i = 0; i < self.serviceArr.count; i++) {
        SDMineModel *mineModel = self.serviceArr[i];
        SDMineButton *serviceBtn = [SDMineButton buttonWithType:UIButtonTypeCustom];
        [serviceBtn setTitle:mineModel.title forState:UIControlStateNormal];
        [serviceBtn setImage:[UIImage imageNamed:mineModel.icon] forState:UIControlStateNormal];
        serviceBtn.margin = 13;
        serviceBtn.tag = 300 + i;
        [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:serviceBtn];
        [self.serviceBtnArr addObject:serviceBtn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat serviceBtnW = SCREEN_WIDTH / self.serviceArr.count;
//    CGFloat serviceBtnW = SCREEN_WIDTH / 4;
    CGFloat serviceBtnH = 99;
    for (int i = 0; i < self.serviceBtnArr.count; i++) {
//        CGFloat serviceX = serviceBtnW * i + serviceBtnW * 0.5;
        CGFloat serviceX = serviceBtnW * i;
        SDMineButton *serviceBtn = self.serviceBtnArr[i];
        [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(serviceX);
            make.top.mas_equalTo(self.lineView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(serviceBtnW, serviceBtnH));
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

- (void)setupGrouperData {
    NSString *title = @"申请团长";
    if ([SDUserModel sharedInstance].isRegiment || [SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        title = @"我是团长";
    }
    UIButton *grouperBtn = self.serviceBtnArr.firstObject;
    [grouperBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - action
- (void)serviceBtnClick:(SDMineButton *)clickBtn {
    if (![self checkIsLogin]) return;
    if (clickBtn.tag == 300) { // 团长
        
        if (![SDUserModel sharedInstance].isRegiment && [SDUserModel sharedInstance].role == SDUserRolerTypeNormal) {
            [SDStaticsManager umEvent:kme_role_be_tz];
            NSString *string = [SDUserModel sharedInstance].regimentApply;
            if ( string && string.integerValue == 0) {
                [SDToastView HUDWithString:@"申请正在审核中，请耐心等待"];
                return;
            }
            [SDJumpManager jumpUrl:KUserBeGrouperUrl push:YES parentsController:self.viewController animation:YES];
//            NSString *version = [UIApplication sharedApplication].appVersion;
//            NSString *argumentsStr = [NSString stringWithFormat:@"?appVersion=%@&Version=1", version];
//            NSString *urlStr = [KUserBeGrouperUrl stringByAppendingString:argumentsStr];
//            SDWebViewController *webVC = [[SDWebViewController alloc] init];
//            [webVC ba_web_loadURL:[NSURL URLWithString:urlStr]];
//            [self.viewController.navigationController pushViewController:webVC animated:YES];

//            SDRecruitViewController *vc = [[SDRecruitViewController alloc] init];
//            [self.viewController.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal) {
            [SDStaticsManager umEvent:kme_role_to_tz];
            NSString *tips = @"使用团长功能需要切换到团长角色，点击确定即可切换";
            [SDPopView showPopViewWithContent:tips noTap:NO confirmBlock:^{
                SD_WeakSelf
                [SDChangeRolerPopView showPopViewWithConfirmBlock:^(NSString *role) {
                    SD_StrongSelf
                    [self changeRole:role];
                }];
            } cancelBlock:^{
                
            }];
            return;
        }
        if ([SDUserModel sharedInstance].role == SDUserRolerTypeGrouper) {
            SDGrouperOrdrController *vc = [[SDGrouperOrdrController alloc] init];
            vc.onlyShowGrouper = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }else{
//            SDMyIncomeViewController *vc = [[SDMyIncomeViewController alloc] init];
//            vc.onlyShowGrouper = YES;
//            [self.viewController.navigationController pushViewController:vc animated:YES];
            
            self.viewController.view.backgroundColor = [UIColor colorWithRGB:0x39CF11 alpha:0.9];
            [self.viewController.navigationController.navigationBar setHidden:YES];
            self.viewController.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
            SDGrouperTabBarController *tab = [[SDGrouperTabBarController alloc] init];
            //        [self.viewController.navigationController presentViewController:tab animated:YES completion:nil];
            [self.viewController.navigationController pushViewController:tab.tab animated:YES];
        }
        
        SNDOLOG(@"团长点击");
    }
    else if (clickBtn.tag == 301) { // 收货地址
        SDAddressMgrViewController *vc = [[SDAddressMgrViewController alloc] init];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else if (clickBtn.tag == 302) { // 售后电话
        [SDServerHelpView show];
    }
}

#pragma mark - network
/** 切换角色网络请求 */
- (void)changeRole:(NSString *)role {
    SDSetRoleRequest *request = [[SDSetRoleRequest alloc] init];
    request.role = role;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"切换成功"];
        [SDUserModel sharedInstance].role = [role intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiChangeRoler object:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}


#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的服务";
        _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _titleLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _lineView;
}

- (NSMutableArray *)serviceArr {
    if (!_serviceArr) {
        NSString *title = @"申请团长";
        if ([SDUserModel sharedInstance].role == SDUserRolerTypeTaoke || [SDUserModel sharedInstance].isRegiment) {
            title = @"我是团长";
        }
        NSArray *tempArr = @[@{@"title" : title, @"icon" : @"mine_grouper"},
                             @{@"title" : @"收货地址", @"icon" : @"mine_address"},
                             @{@"title" : @"客服帮助", @"icon" : @"mine_service"}
                             ];
        _serviceArr = [SDMineModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    return _serviceArr;
}

- (NSMutableArray *)serviceBtnArr {
    if (!_serviceBtnArr) {
        _serviceBtnArr = [NSMutableArray array];
    }
    return _serviceBtnArr;
}

@end
