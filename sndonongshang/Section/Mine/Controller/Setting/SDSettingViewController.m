//
//  SDSettingViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSettingViewController.h"
#import "SDSettingCell.h"
#import "SDLogoutRequest.h"

@interface SDSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *logoutBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
/** count > 4 显示切换服务器地址的cell */
@property (nonatomic, assign) int count;


@end

@implementation SDSettingViewController

static NSString * const CellID = @"SDSettingCell<##>";
static CGFloat const BottomViewH = 84;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initBottomView];
    [self initTableView];
}

- (void)initNav {
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    NSInteger appType = [[NSUserDefaults standardUserDefaults] integerForKey:kAppType];
    if (appType == AppType_Release) {
        return;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testClick)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];

}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.tableHeaderView = [self setupHeaderView];
    [tableView registerClass:[SDSettingCell class] forCellReuseIdentifier:CellID];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.logoutBtn.mas_top).mas_equalTo(-20);
    }];
}

- (void)initBottomView {
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
    if ([SDUserModel sharedInstance].isLogin) {
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.backgroundColor = [UIColor colorWithRGB:0xFF675F];
    }else {
        logoutBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
    }
    logoutBtn.layer.cornerRadius = 22;
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-20 - kBottomSafeHeight);
    }];
    self.logoutBtn = logoutBtn;
}

- (UIView *)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    headerView.height = 126;
    
//    UILabel *appNameLabel = [[UILabel alloc] init];
//    appNameLabel.text = [UIApplication sharedApplication].appBundleDisplayName;
//    appNameLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
//    appNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 19];
//    [headerView addSubview:appNameLabel];
//    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(headerView);
//        make.height.mas_equalTo(20);
//        make.top.mas_equalTo(25);
//    }];
    
    UIImageView *logoIv = [[UIImageView alloc] init];
    logoIv.image = [UIImage imageNamed:@"mine_logo"];
    [headerView addSubview:logoIv];
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.centerX.mas_equalTo(headerView);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(124);
    }];
    
    UILabel *appVersionLabel = [[UILabel alloc] init];
    appVersionLabel.text = [NSString stringWithFormat:@"V%@", [UIApplication sharedApplication].appVersion];
    appVersionLabel.textColor = [UIColor colorWithRGB:0x7c7d7c];
    appVersionLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    [headerView addSubview:appVersionLabel];
    [appVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView);
        make.top.mas_equalTo(logoIv.mas_bottom).mas_equalTo(15);
    }];
    
    return headerView;
}

- (void)gotoAppStore {
    NSString *urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?mt=8",@"1456102515"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

#pragma mark - action
/** 退出登录弹窗 */
- (void)logout {
    [SDStaticsManager umEvent:ksetting_logout];
    NSString *tipsStr = @"退出登录后无法购买商品，确定退出吗？";
    SD_WeakSelf
    [SDPopView showPopViewWithContent:tipsStr noTap:NO confirmBlock:^{
        SD_StrongSelf
        SDLogoutRequest *request = [[SDLogoutRequest alloc] init];
        [SDToastView show];
        [request startWithCompletionBlockWithSuccess:^(__kindof SDLogoutRequest * _Nonnull request) {
            [SDToastView HUDWithSuccessString:request.msg];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KToken];
            [SDUserModel destroyInstance];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiLogoutSuccess object:nil];
            
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popViewControllerAnimated:NO];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    } cancelBlock:^{
        
    }];
    
}

- (void)testClick {
    self.count = self.count + 1;
    if (self.count <= 4) {
        return;
    }
    self.count = 0;
    int type = [SDNetConfig sharedInstance].type;
    NSString *serverType = type == SeverType_Release ? @"线上环境" : @"测试环境";
    SDSettingModel *model = [[SDSettingModel alloc] init];
    model.title = serverType;
    [self.dataArr addObject:model];
    [self.tableView reloadData];
}

- (void)setupSeverType {
    int type = [SDNetConfig sharedInstance].type;
    if (type == SeverType_Release) {
        [[SDNetConfig sharedInstance] setType:SeverType_Test];
    }else {
        [[SDNetConfig sharedInstance] setType:SeverType_Release];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiLogoutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiChangeRoler object:nil];
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - network
- (void)logoutNetWork {
    SDLogoutRequest *request = [[SDLogoutRequest alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDLogoutRequest * _Nonnull request) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KToken];
        [SDUserModel destroyInstance];
        [self setupSeverType];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    SDSettingModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [SDStaticsManager umEvent:kagreement];
        SDWebViewController *webview = [[SDWebViewController alloc] init];
        webview.navigationItem.title = @"九本鲜生用户协议";
        webview.showNavigationBar = YES;
        [webview ba_web_loadURL:[NSURL URLWithString:KUserProtocolUrl]];
        [self.navigationController pushViewController:webview animated:YES];
    }else if (indexPath.row == 1) {
//        [SDStaticsManager umEvent:kagreement];
        SDWebViewController *webview = [[SDWebViewController alloc] init];
        webview.navigationItem.title = @"九本鲜生隐私政策";
        webview.showNavigationBar = YES;
        [webview ba_web_loadURL:[NSURL URLWithString:KUserPrivateProtocolUrl]];
        [self.navigationController pushViewController:webview animated:YES];
    }else if (indexPath.row == 2) {
        [SDStaticsManager umEvent:ksetting_version_check];
        [self gotoAppStore];
    }else if (indexPath.row == 3) { // 切换网络环境
        if ([SDUserModel sharedInstance].isLogin) {
            [self logoutNetWork];
            return;
        }
        [self setupSeverType];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}



#pragma mark - lazy
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        NSArray *tempArr = @[@{@"title" : @"用户协议"},
                             @{@"title" : @"隐私政策"},
                             @{@"title" : @"版本更新"}];
        _dataArr = [SDSettingModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    return _dataArr;
}
@end
