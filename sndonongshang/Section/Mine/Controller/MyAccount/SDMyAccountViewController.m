//
//  SDMyAccountViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyAccountViewController.h"
#import "SDSettingModel.h"
#import "SDSettingCell.h"
#import "SDMyAccountPopView.h"
#import "SDRegisterPwdViewController.h"
#import "SDSetUserRequest.h"
#import "SDBindWeChatRequest.h"
#import "WXApi.h"
#import "SDGetUserRequest.h"
#import "SDSetupPwdViewController.h"
#import "SDChangeRolerPopView.h"
#import "SDSetRoleRequest.h"
#import "SDChangePwdViewController.h"

@interface SDMyAccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SDMyAccountViewController

static NSString * const cellID = @"MyAccountCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initTableView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNav {
    self.navigationItem.title = @"我的账户";
}

- (void)initTableView {
    CGRect frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [tableView registerClass:[SDSettingCell class] forCellReuseIdentifier:cellID];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.and.bottom.mas_equalTo(0);
    }];
}

- (UIView *)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.cp_h = 55;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"账号绑定";
    titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    titleLabel.textColor = [UIColor colorWithRGB:0x848488];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(headerView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    return headerView;
}

/** 出生日期选择器 */
- (void)setupDatePickerView {
    SD_WeakSelf
    SDMyAccountPopView *popView = [SDMyAccountPopView showPopViewWithType:MyAccountPopViewTypeDate confirmBlock:^(NSString *chooseValue) {
        SD_StrongSelf
        SNDOLOG(@"chooseValue brithday %@", chooseValue);
        if ([chooseValue isEqualToString:[SDUserModel sharedInstance].birthday]) {
            return ;
        }
        SDSetUserRequest *request = [[SDSetUserRequest alloc] init];
        request.birthday = chooseValue;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SDUserModel sharedInstance].birthday = chooseValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [self changeValue:chooseValue indexPath:indexPath];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }];
    NSString *birthday = [SDUserModel sharedInstance].birthday;
    if (!birthday || [birthday isEmpty]) {
        return;
    }
    NSDate *selectedDate = [NSDate dateWithString:birthday formatString:@"yyyy-MM-dd"];
    popView.selectedDate = selectedDate;
}

/** 性别选择器 */
- (void)setupSexPickerView {
    SD_WeakSelf
    SDMyAccountPopView *popView = [SDMyAccountPopView showPopViewWithType:MyAccountPopViewTypeSex confirmBlock:^(NSString *chooseValue) {
        SD_StrongSelf
        SNDOLOG(@"chooseValue Sex %@", chooseValue);
        int sex = 0;
        if ([chooseValue isEqualToString:@"保密"]) {
            sex = 0;
        }else if ([chooseValue isEqualToString:@"男"]) {
            sex = 1;
        }else if ([chooseValue isEqualToString:@"女"]) {
            sex = 2;
        }
        if (sex == [SDUserModel sharedInstance].sex) {
            return;
        }
        SDSetUserRequest *request = [[SDSetUserRequest alloc] init];
        request.sex = [NSString stringWithFormat:@"%d", sex];
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SDUserModel sharedInstance].sex = sex;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self changeValue:chooseValue indexPath:indexPath];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }];
    popView.selectedSex =  [SDUserModel sharedInstance].sex;
}

- (void)changeValue:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArr = self.dataArr[indexPath.section];
    SDSettingModel *model = sectionArr[indexPath.row];
    model.value = value;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - network
- (void)getUserInfo {
    SDGetUserRequest *user = [[SDGetUserRequest alloc] init];
    [SDToastView show];
    [user startWithCompletionBlockWithSuccess:^(__kindof SDGetUserRequest * _Nonnull request) {
        self.dataArr = nil;
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

/** 切换角色网络请求 */
- (void)changeRole:(NSString *)role {
    SDSetRoleRequest *request = [[SDSetRoleRequest alloc] init];
    request.role = role;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"切换成功"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        NSArray *sectionArr = self.dataArr[indexPath.section];
        SDSettingModel *model = sectionArr[indexPath.row];
        NSString *value = [role isEqualToString:@"0"] ? @"普通用户" : @"团长";
        model.value = value;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [SDUserModel sharedInstance].role = [role intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiChangeRoler object:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - action
- (void)bindWeChat {
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        [WXApi sendReq:req];//发起微信授权请求
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCode:) name:KWechatLoginCode object:nil];
        return;
    }
}

- (void)receiveCode:(NSNotification *)notifi {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *code = notifi.userInfo[@"code"];
    if (code) {
        SDBindWeChatRequest *request = [[SDBindWeChatRequest alloc] init];
        request.wechatCode = code;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self getUserInfo];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.dataArr[section];
    return sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *sectionArr = self.dataArr[indexPath.section];
    SDSettingModel *model = sectionArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        if (indexPath.row == 1) {
            [SDToastView HUDWithString:@"用户名不支持修改"];
        }else if (indexPath.row == 2) {
            [SDStaticsManager umEvent:kuserinfo_sex_btn];
            [self setupSexPickerView];
        }else if (indexPath.row == 3) {
            [SDStaticsManager umEvent:kuserinfo_birthday_btn];
            [self setupDatePickerView];
        }else if (indexPath.row == 0) {
            [SDToastView HUDWithString:@"头像不支持修改"];
        }
    }else if (indexPath.section == -1) {
        if (indexPath.row == 0) {
            if ([SDUserModel sharedInstance].seted_password) { // 已设置密码
                SDChangePwdViewController *vc = [[SDChangePwdViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else { // 未设置密码
                SDSetupPwdViewController *vc = [[SDSetupPwdViewController alloc] init];
                vc.block = ^{
                    [SDUserModel sharedInstance].seted_password = 1;
                    NSArray *sectionArr = self.dataArr[indexPath.section];
                    SDSettingModel *model = sectionArr[indexPath.row];
                    model.value = @"可修改密码";
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (indexPath.section == 1) { // 切换角色 或者绑定微信
        if (![SDUserModel sharedInstance].isRegiment && indexPath.row == 1 && ![SDUserModel sharedInstance].binded_wechat) {
            [SDStaticsManager umEvent:kuserinfo_wx_bind];
             [self bindWeChat];
            return;
        }
        if (indexPath.row == 0) {
            if ([SDUserModel sharedInstance].isRegiment) {
                SD_WeakSelf
                [SDStaticsManager umEvent:kuserinfo_role_switch];
                [SDChangeRolerPopView showPopViewWithConfirmBlock:^(NSString *role) {
                    SD_StrongSelf
                    [self changeRole:role];
                }];
            }
        }
    }else if (indexPath.section == 2) { // 绑定微信
        if (![WXApi isWXAppInstalled]) {
            return;
        }
        if (indexPath.row == 1 && ![SDUserModel sharedInstance].binded_wechat) {
            [SDStaticsManager umEvent:kuserinfo_wx_bind];
            [self bindWeChat];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}


#pragma mark - lazy
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        SDUserModel *userModel = [SDUserModel sharedInstance];
        NSString *sexValue = @"保密";
        if (userModel.sex == 1) {
            sexValue = @"男";
        }else if (userModel.sex == 2) {
            sexValue = @"女";
        }
        NSString *acSafeValue = userModel.seted_password ? @"可修改密码" : @"设置密码";
        NSString *wechatBindValue = @"未绑定";
        BOOL wechatChooseValue = NO;
        if (userModel.binded_wechat) {
            wechatBindValue = @"已绑定";
            wechatChooseValue = YES;
        }
        NSString *roleStr = @"普通用户";
        if (userModel.role == SDUserRolerTypeGrouper || userModel.role == SDUserRolerTypeTaoke) {
            roleStr = @"团长";
        }
        
        NSArray *section1 = @[@{@"title" : @"头像", @"value" : @"", @"hiddenArrow" : @YES, @"showAvator" : @YES, @"avatorUrl" : userModel.header},
                              @{@"title" : @"用户名", @"value" : userModel.nickname,@"hiddenArrow" : @YES,},
                              @{@"title" : @"性别", @"value" : sexValue},
                              @{@"title" : @"出生日期", @"value" : userModel.birthday}
                              ];
        NSArray *section2 = @[@{@"title" : @"账户安全", @"value" : acSafeValue}];
        NSArray *section3 = @[@{@"title" : @"切换角色", @"value" : roleStr}];
        NSArray *section4 = @[
                              @{@"title" : @"手机号", @"value" : @"已绑定", @"valueChoose" : @YES},
                              @{@"title" : @"微信", @"value" : wechatBindValue, @"valueChoose" : @(wechatChooseValue)}
                            ];
        if (![WXApi isWXAppInstalled]) {
            section4 = @[
                         @{@"title" : @"手机号", @"value" : @"已绑定", @"valueChoose" : @YES}
                         ];
        }
//        NSArray *tempArr = @[section1,section2, section3, section4];
        NSArray *tempArr = @[section1, section3, section4];
        if (!userModel.isRegiment) {
            tempArr = @[section1, section4];
        }
        _dataArr = [SDSettingModel mj_objectArrayWithKeyValuesArray:tempArr];

    }
    return _dataArr;
}

@end
