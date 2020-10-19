//
//  SDMyIncomeViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyIncomeViewController.h"
#import "SDMyIncomeCell.h"
#import "SDPromoteDataView.h"
#import "SDWithdrawalViewController.h"
#import "SDSettlementViewController.h"
#import "SDSafeVerifyViewController.h"
#import "SDBrokerageInfoRequest.h"
#import "SDBrokerageDataManager.h"
#import "SDBindWeChatRequest.h"
#import "WXApi.h"
#import "SDGetUserRequest.h"

@interface SDMyIncomeViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *greenBGView;
/** 提现金额 label */
@property (nonatomic, strong) UILabel *withdrawalLabel;
@property (nonatomic, strong) UILabel *withdrawalTipsLabel;
/** 冻结金额 label */
@property (nonatomic, strong) UILabel *freezeLabel;
/** 提现按钮n */
@property (nonatomic, strong) UIButton *withdrawalBtn;

@property (nonatomic, strong) SDPromoteDataView *promoteDataView;

@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UILabel *tipsOneLabel;
@property (nonatomic, strong) UILabel *tipsTwoLabel;
@property (nonatomic, strong) UILabel *tipsThreeeLabel;
@property (nonatomic, strong) UILabel *tipsFourLabel;
@property (nonatomic, strong) UILabel *tipsFiveLabel;
@property (nonatomic, strong) UILabel *tipsSixLabel;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SDMyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
    [self getBrokerageInfo];
}

- (void)initNav {
    self.navigationItem.title = @"我的佣金";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
}

- (void)initSubView {
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - kTabBarHeight);
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kTopHeight);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
//    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    [self initTopView];
    [self initPromoteView];
    [self initTipsView];
}

- (void)initTopView {
    CGFloat topViewH = 150 - kNavBarHeight - 20;
    [self.scrollView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.height.mas_equalTo(topViewH);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.topView addSubview:self.greenBGView];
//    [self.topView addSubview:self.withdrawalTipsLabel];
    [self.topView addSubview:self.withdrawalLabel];
    [self.topView addSubview:self.freezeLabel];
    [self.topView addSubview:self.withdrawalBtn];
    
    [self.greenBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.topView);
    }];

//    [self.withdrawalTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.withdrawalLabel.mas_right).mas_equalTo(5);
//        make.top.mas_equalTo(10);
//        make.height.mas_equalTo(18);
//    }];
    
    [self.withdrawalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(@(SCREEN_WIDTH * 0.5));
    }];
    
    [self.freezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.withdrawalLabel);
        make.top.mas_equalTo(self.withdrawalLabel.mas_bottom).mas_equalTo(12);
    }];
    
    [self.withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 30));
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-45);
    }];
}

- (void)initPromoteView {
    [self.scrollView addSubview:self.promoteDataView];
    if ([SDUserModel sharedInstance].role != SDUserRolerTypeNormal) {
        [self.promoteDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(255 + 55);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
    }else{
        [self.promoteDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(255);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
    }
    
}

- (void)initTipsView {
    [self.scrollView addSubview:self.tipsView];
    
    [self.tipsView addSubview:self.noticeLabel];
    [self.tipsView addSubview:self.tipsOneLabel];
    [self.tipsView addSubview:self.tipsTwoLabel];
    [self.tipsView addSubview:self.tipsThreeeLabel];
    [self.tipsView addSubview:self.tipsFourLabel];
    [self.tipsView addSubview:self.tipsFiveLabel];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(self.tipsView.mas_top).mas_equalTo(30);
    }];
    
    [self.tipsOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
        make.top.mas_equalTo(self.noticeLabel.mas_bottom).mas_equalTo(10);
    }];
    
    [self.tipsTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
        make.top.mas_equalTo(self.tipsOneLabel.mas_bottom).mas_equalTo(10);
    }];
    
    [self.tipsThreeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
        CGFloat height = [self.tipsThreeeLabel.text sizeWithFont:self.tipsThreeeLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - 20, 100)].height;
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(self.tipsTwoLabel.mas_bottom).mas_equalTo(10);
    }];
    
    [self.tipsFourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
        CGFloat height = [self.tipsFourLabel.text sizeWithFont:self.tipsFourLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - 20, 100)].height;
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(self.tipsThreeeLabel.mas_bottom).mas_equalTo(10);
    }];
    [self.tipsFiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
        CGFloat height = [self.tipsFiveLabel.text sizeWithFont:self.tipsFiveLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - 20, 100)].height;
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(self.tipsFourLabel.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-20);
    }];
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        [self.scrollView addSubview:self.tipsSixLabel];
        [self.tipsSixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
            CGFloat height = [self.tipsSixLabel.text sizeWithFont:self.tipsSixLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - 20, 100)].height;
            make.height.mas_equalTo(height);
            make.top.mas_equalTo(self.tipsFiveLabel.mas_bottom).mas_equalTo(10);
            make.bottom.mas_equalTo(-50).priorityLow();
        }];
//        UILabel *label = [[UILabel alloc] init];
//        label.text = self.tipsSixLabel.text;
//        [self.scrollView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(20);
//            make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
//            CGFloat height = [self.tipsSixLabel.text sizeWithFont:self.tipsSixLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - 20, 100)].height;
//            make.height.mas_equalTo(20);
//            make.top.mas_equalTo(self.tipsSixLabel.mas_bottom).mas_equalTo(10);
//        }];
    }else{
//        UILabel *label = [[UILabel alloc] init];
//        [self.scrollView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(20);
//            make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
//            make.height.mas_equalTo(20);
//            make.top.mas_equalTo(self.tipsFiveLabel.mas_bottom).mas_equalTo(10);
//        }];
    }
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollView);
        make.top.equalTo(self.promoteDataView.mas_bottom);
        make.height.mas_equalTo(200);
    }];
//    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 1600)];
}

#pragma mark - action
- (void)withdrawalBtnClick {
    [SDStaticsManager umEvent:kincome_withdrawal];
    if ([SDUserModel sharedInstance].binded_wechat) {
        SDSafeVerifyViewController *vc = [[SDSafeVerifyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    SD_WeakSelf
    [SDPopView showPopViewWithContent:@"你没有绑定微信，无法提现，确认去绑定吗？" noTap:NO confirmBlock:^{
        SD_StrongSelf
        [self bindWeChat];
    } cancelBlock:^{
        
    }];
    
}

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
        SD_WeakSelf
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SD_StrongSelf
            [SDStaticsManager umEvent:kwxbangding_cg];
            [SDToastView HUDWithSuccessString:@"“微信账户绑定成功，即将进入安全验证"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SDSafeVerifyViewController *vc = [[SDSafeVerifyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            });
            [self getUserInfo];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SDStaticsManager umEvent:kwxbangding_sb];
        }];
    }
}
- (void)getUserInfo {
    SDGetUserRequest *user = [[SDGetUserRequest alloc] init];
    [SDToastView show];
    [user startWithCompletionBlockWithSuccess:^(__kindof SDGetUserRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - network
- (void)getBrokerageInfo {
    SD_WeakSelf
    [SDBrokerageDataManager getBrokerageInfoWithCompleteBlock:^{
        SD_StrongSelf
        SDBrokerageModel *model = [SDBrokerageDataManager sharedInstance].brokerageModel;
        if (model) {
            self.withdrawalLabel.text = [NSString stringWithFormat:@"￥%@", [model.brokerage priceStr]];
            self.freezeLabel.text = [NSString stringWithFormat:@"冻结金额：￥%@", [model.freezeBrokerage priceStr]];
            [self.promoteDataView setUserData];
        }
        [self.scrollView.mj_header endRefreshing];
    } failedBlock:^{
        SD_StrongSelf
        [self.scrollView.mj_header endRefreshing];
    }];
}


#pragma mark - lazy
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UIImageView *)greenBGView {
    if (!_greenBGView) {
        _greenBGView = [[UIImageView alloc] init];
        _greenBGView.image = [UIImage cp_imageByCommonGreenWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150 - kNavBarHeight - 20)];
    }
    return _greenBGView;
}

- (UILabel *)withdrawalLabel {
    if (!_withdrawalLabel) {
        _withdrawalLabel = [[UILabel alloc] init];
        _withdrawalLabel.font = [UIFont fontWithName:kSDPFMediumFont size:25];
        _withdrawalLabel.textColor = [UIColor whiteColor];
    }
    return _withdrawalLabel;
}

- (UILabel *)withdrawalTipsLabel {
    if (!_withdrawalTipsLabel) {
        _withdrawalTipsLabel = [[UILabel alloc] init];
        _withdrawalTipsLabel.text = @"可提现金额";
        _withdrawalTipsLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _withdrawalTipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
        _withdrawalTipsLabel.backgroundColor = [UIColor whiteColor];
    }
    return _withdrawalTipsLabel;
}

- (UIButton *)withdrawalBtn {
    if (!_withdrawalBtn) {
        _withdrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawalBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
//        _withdrawalBtn.backgroundColor = [UIColor colorWithRGB:0xf8665a];
        _withdrawalBtn.layer.borderWidth = 0.5;
        _withdrawalBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _withdrawalBtn.layer.cornerRadius = 15;
        [_withdrawalBtn addTarget:self action:@selector(withdrawalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawalBtn;
}


- (UILabel *)freezeLabel {
    if (!_freezeLabel) {
        _freezeLabel = [[UILabel alloc] init];
        _freezeLabel.textColor = [UIColor whiteColor];
        _freezeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
    }
    return _freezeLabel;
}

- (SDPromoteDataView *)promoteDataView {
    if (!_promoteDataView) {
        _promoteDataView = [[SDPromoteDataView alloc] init];
    }
    return _promoteDataView;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _noticeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _noticeLabel.text = @"注意：";
    }
    return _noticeLabel;
}

- (UILabel *)tipsOneLabel {
    if (!_tipsOneLabel) {
        _tipsOneLabel = [[UILabel alloc] init];
        _tipsOneLabel.numberOfLines = 0;
        _tipsOneLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _tipsOneLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _tipsOneLabel.text = @"1.可提现金额：可以提现到微信账户的余额。";
    }
    return _tipsOneLabel;
}

- (UILabel *)tipsTwoLabel {
    if (!_tipsTwoLabel) {
        _tipsTwoLabel = [[UILabel alloc] init];
        _tipsTwoLabel.numberOfLines = 0;
        _tipsTwoLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _tipsTwoLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _tipsTwoLabel.text = @"2.冻结金额：未完成的订单佣金，只有好友订单完成后，才会转到可提现金额。";
    }
    return _tipsTwoLabel;
}

- (UILabel *)tipsThreeeLabel {
    if (!_tipsThreeeLabel) {
        _tipsThreeeLabel = [[UILabel alloc] init];
        _tipsThreeeLabel.numberOfLines = 0;
        _tipsThreeeLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _tipsThreeeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _tipsThreeeLabel.text = @"3.拉新：好友注册支付首单的现金奖励。";
    }
    return _tipsThreeeLabel;
}

- (UILabel *)tipsFourLabel {
    if (!_tipsFourLabel) {
        _tipsFourLabel = [[UILabel alloc] init];
        _tipsFourLabel.numberOfLines = 0;
        _tipsFourLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _tipsFourLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _tipsFourLabel.text = @"4.佣金：好友下单的佣金，在好友订单中可查看明细。";
    }
    return _tipsFourLabel;
}
- (UILabel *)tipsFiveLabel {
    if (!_tipsFiveLabel) {
        _tipsFiveLabel = [[UILabel alloc] init];
        _tipsFiveLabel.numberOfLines = 0;
        _tipsFiveLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _tipsFiveLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _tipsFiveLabel.text = @"5.预估总收入：今日或昨日拉新和佣金总的收入。";
    }
    return _tipsFiveLabel;
}
- (UILabel *)tipsSixLabel {
    if (!_tipsSixLabel) {
        _tipsSixLabel = [[UILabel alloc] init];
        _tipsSixLabel.numberOfLines = 0;
        _tipsSixLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        _tipsSixLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _tipsSixLabel.text = @"6.新增好友数：通过你的链接或二维码注册的好友数。";
    }
    return _tipsSixLabel;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        SD_WeakSelf
        self.automaticallyAdjustsScrollViewInsets = false;
        _scrollView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            SD_StrongSelf;
            [self getBrokerageInfo];
        }];
    }
    return _scrollView;
}
- (UIView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
    }
    return _tipsView;
}
@end
