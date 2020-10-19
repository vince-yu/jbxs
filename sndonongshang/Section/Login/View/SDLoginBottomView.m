//
//  SDLoginBottomView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLoginBottomView.h"
#import "SDWeChatLoginButton.h"
#import <UMShare/UMShare.h>
#import "SDWeChatLoginRequest.h"
#import "SDChangePhoneViewController.h"
#import "WXApi.h"
#import "SDBaseLoginViewController.h"
#import "SDWebViewController.h"

@interface SDLoginBottomView ()

@property (nonatomic, weak) UIView *leftLineView;
@property (nonatomic, weak) UIView *rightLineView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *weChatLoginButton;
@property (nonatomic, weak) YYLabel *protocolLabel;

@end

@implementation SDLoginBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor colorWithRGB:0xf4f4f4];
    self.leftLineView = leftLineView;
    [self addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor colorWithRGB:0xf4f4f4];
    self.rightLineView = rightLineView;
    [self addSubview:rightLineView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"更多登录方式";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRGB:0xc2c3c3];
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    SDWeChatLoginButton *weChatLoginButton = [SDWeChatLoginButton buttonWithType:UIButtonTypeCustom];
    [weChatLoginButton setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [weChatLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [weChatLoginButton addTarget:self action:@selector(wechatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.weChatLoginButton = weChatLoginButton;
    [self addSubview:weChatLoginButton];
    
   YYLabel *protocolLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"登录即代表您同意《九本鲜生用户政策》"];
    NSRange range = NSMakeRange(8, 10);
    text.yy_font = [UIFont systemFontOfSize:12];
//    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle];
//    [text yy_setTextUnderline:decoration range:range];
    text.yy_color = [UIColor colorWithRGB:0x8a8a8b];
    [text yy_setTextHighlightRange:range color: [UIColor colorWithHexString:kSDGreenTextColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [SDStaticsManager umEvent:kagreement];
        SDWebViewController *webview = [[SDWebViewController alloc] init];
        webview.navigationItem.title = @"九本鲜生用户协议";
        webview.showNavigationBar = YES;
        [webview ba_web_loadURL:[NSURL URLWithString:KUserProtocolUrl]];
        [self.viewController.navigationController pushViewController:webview animated:YES];
    }];
    protocolLabel.attributedText = text;
    self.protocolLabel = protocolLabel;
    [self addSubview:protocolLabel];
    
    if(![WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        NSLog(@"微信未安装");
        self.leftLineView.hidden = YES;
        self.rightLineView.hidden = YES;
        self.weChatLoginButton.hidden = YES;
        self.titleLabel.hidden = YES;
    }
}

#pragma mark - action
- (void)wechatBtnClick:(UIButton *)clickBtn {
    [SDStaticsManager umEvent:kwx_login];
    if ([self.viewController isKindOfClass:[SDBaseLoginViewController class]]) {
        SDBaseLoginViewController *vc = (SDBaseLoginViewController *)self.viewController;
        if (vc.timer) {
            [vc invalidateTimer];
        }
    }
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
        [SDStaticsManager umEvent:kwxshouquan_cg];
        SDWeChatLoginRequest *request = [[SDWeChatLoginRequest alloc] init];
        request.wechatCode = code;
        [SDToastView show];
        [request startWithCompletionBlockWithSuccess:^(__kindof SDWeChatLoginRequest * _Nonnull request) {
            NSString *mobile = request.userInfo[@"mobile"];
            if ([mobile isNotEmpty]) {
                SDUserModel *model = [SDUserModel sharedInstance];
                SDUserModel *userModel = [SDUserModel mj_objectWithKeyValues:request.userInfo];
                [model mj_setKeyValues:userModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiLoginSuccess object:nil];
                [self.viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
//                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                appDelegate.tabVC.selectedIndex = 0;
//                [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabVC;
            }else {
                SDChangePhoneViewController *vc = [[SDChangePhoneViewController alloc] init];
                vc.token = request.userInfo[@"token"];
                [self.viewController.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

        }];
    }else{
        [SDStaticsManager umEvent:kwxshouquan_sb];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(self.titleLabel.mas_left).mas_equalTo(-SDSmallMargin);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(SDSmallMargin);
        make.right.mas_equalTo(-SDMargin);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    CGFloat titleSpace = 36;
    if (iPhone5 || iPhone4) {
        titleSpace = 18;
    }
    [self.weChatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(titleSpace);
        make.centerX.mas_equalTo(self);
    }];
    
    CGFloat btnSpace = 33;
    if (iPhone5 || iPhone4) {
        btnSpace = 15;
    }
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weChatLoginButton.mas_bottom).mas_equalTo(btnSpace );
        make.centerX.mas_equalTo(self);
    }];
    
}

@end
