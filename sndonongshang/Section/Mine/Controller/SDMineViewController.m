//
//  SDMineViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineViewController.h"
#import "SDLoginViewController.h"
#import "SDGetUserRequest.h"
#import "SDMineServiceView.h"
#import "SDMineOrderView.h"
#import "SDMineTopView.h"
#import "SDMineCouponsView.h"
#import "SDMineIncomeView.h"

@interface SDMineViewController ()

@property (nonatomic, weak) UIScrollView *sc;

@property (nonatomic, weak) SDMineTopView *topView;

@property (nonatomic, weak) SDMineCouponsView *couponsView;

@property (nonatomic, weak) SDMineIncomeView *incomeView;

@property (nonatomic, weak) SDMineOrderView *myOrderView;

@property (nonatomic, weak) SDMineServiceView *myServiceView;


@end

@implementation SDMineViewController

static CGFloat const couponsH = 58;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initScrollView];
    [self getUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:KNotifiAddressUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCouponsCount:) name:KNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessAction) name:kNotifiLogoutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appVerifySuccess) name:kNotifiAPPVerifySuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    [self getUserInfo];
//    [self.topView setupUserData];
//    self.incomeView.brokerage = [SDUserModel sharedInstance].brokerage;
//    if ([[SDUserModel sharedInstance].voucher_num isNotEmpty]) {
//        self.couponsView.couponsNum = [SDUserModel sharedInstance].voucher_num;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNav {
    self.view.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
}

- (void)initScrollView {
    
    UIScrollView *sc = [[UIScrollView alloc] init];
    sc.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    self.sc = sc;
    [self.view addSubview:sc];
    [sc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.bottom.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
    }];
    SD_WeakSelf
    sc.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SD_StrongSelf;
        [self getUserInfo];
    }];
    
    [self initTopView];
    [self initCouponsView];
    [self initIncomeView];
    [self initMyOrderView];
    [self initMyServiceView];
}


- (void)initTopView {
    CGFloat topViewH = 150 - kNavBarHeight - 20;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, topViewH);
    SDMineTopView *topView = [[SDMineTopView alloc] initWithFrame:frame];
    self.topView = topView;
    [self.sc addSubview:topView];
    self.topView = topView;
}

/** 优惠券 */
- (void)initCouponsView {
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, couponsH);
    SDMineCouponsView *couponsView = [[SDMineCouponsView alloc] initWithFrame:frame];
    self.couponsView = couponsView;
    [self.sc addSubview:self.couponsView];
}

/** 收入 */
- (void)initIncomeView {
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.couponsView.frame), SCREEN_WIDTH, couponsH);
    SDMineIncomeView *incomeView = [[SDMineIncomeView alloc] initWithFrame:frame];
    self.incomeView = incomeView;
    [self.sc addSubview:self.incomeView];
}


/** 我的订单 */
- (void)initMyOrderView {
    CGFloat myOrderViewH = 125;
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.incomeView.frame) + 10, SCREEN_WIDTH, myOrderViewH);
    if (![SDAppManager sharedInstance].status) {
        self.incomeView.hidden = YES;
        frame = CGRectMake(0, CGRectGetMaxY(self.couponsView.frame) + 10, SCREEN_WIDTH, myOrderViewH);
    }
//    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.incomeView.frame) + 10, SCREEN_WIDTH, myOrderViewH);
    SDMineOrderView *myOrderView = [[SDMineOrderView alloc] initWithFrame:frame];
    self.myOrderView = myOrderView;
    [self.sc setContentSize:CGSizeMake(0, CGRectGetMaxY(self.myOrderView.frame))];
    [self.sc addSubview:self.myOrderView];
}

/** 我的服务 */
- (void)initMyServiceView {
    CGFloat myServiceViewH = 150;
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.myOrderView.frame) + 10, SCREEN_WIDTH, myServiceViewH);
    SDMineServiceView *myServiceView = [[SDMineServiceView alloc] initWithFrame:frame];
    self.myServiceView = myServiceView;
    [self.sc addSubview:myServiceView];
    [self.sc setContentSize:CGSizeMake(0, CGRectGetMaxY(myServiceView.frame))];
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


#pragma mark - network
- (void)getUserInfo {
    if (![[SDUserModel sharedInstance] isLogin]) {
        [self.sc.mj_header endRefreshing];
        return;
    }
    SDGetUserRequest *user = [[SDGetUserRequest alloc] init];
    [user startWithCompletionBlockWithSuccess:^(__kindof SDGetUserRequest * _Nonnull request) {
        [self.sc.mj_header endRefreshing];
        [self.topView setupUserData];
        self.incomeView.brokerage = [SDUserModel sharedInstance].brokerage;
        if ([[SDUserModel sharedInstance].voucher_num isNotEmpty]) {
            self.couponsView.couponsNum = [SDUserModel sharedInstance].voucher_num;
        }
        [self.myServiceView setupGrouperData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.sc.mj_header endRefreshing];
    }];
}
#pragma mark 登陆成功刷新优惠券
- (void)updateCouponsCount:(NSNotification *)note{
    if ([[SDUserModel sharedInstance].voucher_num isNotEmpty]) {
        self.couponsView.couponsNum = [SDUserModel sharedInstance].voucher_num;
    }
    if ([[SDUserModel sharedInstance].brokerage isNotEmpty]) {
        self.incomeView.brokerage = [SDUserModel sharedInstance].brokerage;
    }
    
}
- (void)logoutSuccessAction{
    [self.topView setupUserData];
    [self.myServiceView setupGrouperData];
    self.couponsView.couponsNum = @"0";
    self.incomeView.brokerage = @"0";
}
- (void)appVerifySuccess{
    if (self.incomeView.hidden) {
        CGFloat myOrderViewH = 125;
        self.incomeView.hidden = NO;
        CGRect orderFrame = CGRectMake(0, CGRectGetMaxY(self.incomeView.frame) + 10, SCREEN_WIDTH, myOrderViewH);
        self.myOrderView.frame = orderFrame;
        CGFloat myServiceViewH = 150;
        CGRect serverFrame = CGRectMake(0, CGRectGetMaxY(self.myOrderView.frame) + 10, SCREEN_WIDTH, myServiceViewH);
        self.myServiceView.frame = serverFrame;
        [self.sc setContentSize:CGSizeMake(0, CGRectGetMaxY(self.myOrderView.frame))];
    }
}
@end
