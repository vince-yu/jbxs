//
//  AppDelegate+Config.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "AppDelegate+Config.h"
#import <UserNotifications/UserNotifications.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "SDTabBarViewController.h"
#import "SDMineViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SDPayManager.h"
#import "SDNetConfig.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SDHomeDataManager.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate (Config)

- (void)initWindow {
    [SDHomeDataManager checkVerifyStatus];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.tabVC.tab;
    [self.window makeKeyAndVisible];
    //统计实例
    [SDStaticsManager instance];
    //上传数据
    [SDStaticsManager uploadData];
}
- (BOOL )getVerify{
    BOOL status = NO;
    status = [SDAppManager sharedInstance].status;
    return status;
}
- (void)networkMonitoring {
    [[SDReachability sharedInstance] networkMonitoring];
}

- (void)appearanceConfig {
    UITextField *textField = [UITextField appearance];
    textField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    textField.placeholderColor = [UIColor colorWithHexString:kSDGrayTextColor];
}

- (void)initLocationManager {
    [AMapServices sharedServices].apiKey = AMap_Api_Key;
}

- (void)setupUserAgent {
    NSString *customUserAgent =  @"Ios";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
    [ [NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [ [NSUserDefaults standardUserDefaults] synchronize];
}

- (void)config{
   
    // 添加崩溃调用栈打印,查找崩溃位置
    NSSetUncaughtExceptionHandler(&caughtExceptionHandler);
    
    // 设置App环境类型 AppType_Test 测试环境 AppType_Release 线上环境
    [[NSUserDefaults standardUserDefaults] setInteger:AppType_Release forKey:kAppType];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 网络环境配置 SeverType_Release SeverType_Test SeverType_Dev afa9e2970ed6acb79833b6a71349f02ef7c27570
    [[SDNetConfig sharedInstance] setType:SeverType_Release];
    
    //微信支付
    [WXApi registerApp:WxChatPayAPPID];
    // 友盟统计
    [UMConfigure initWithAppkey:UM_KEY channel:@"App Store"];
#ifdef DEBUG
    [MobClick setCrashReportEnabled:YES];    //关闭错误统计
#else
    [MobClick setCrashReportEnabled:YES];   //打开错误统计
#endif
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEICHAT_KEY appSecret:WEICHAT_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_KEY appSecret:QQ_SECRET redirectURL:@"http://mobile.umeng.com/social"];
//    [WXApi registerApp:WEICHAT_KEY];

    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_KEY /*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    // http://sns.whalecloud.com/sina2/callback 需要跟微博后台高级设置处一致
//    /* 设置新浪的appKey和appSecret  */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINA_KEY  appSecret:SINA_SECRET redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}
// 将得到的deviceToken传给SDK

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [self parseNotificationContent:userInfo];
//}
//
////iOS10新增：处理后台点击通知的代理方法
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于后台时的远程推送接受
//        [self parseNotificationContent:userInfo];
//    }else{
//        //应用处于后台时的本地推送接受
//    }
//}

#pragma mark - 解析启动时候的推送内容
//-(void)parseNotificationContent:(NSDictionary *)userInfo{
//    SNDOLOG(@"解析推送内容userInfo = %@", userInfo);
//    if (userInfo) {
//        NSDictionary *body = [userInfo objectForKey:@"body"];
//        if (body) {
//            NSDictionary *custom = [body objectForKey:@"custom"];
//            if (custom) {
//
//
//            }
//        }
//    }
//}

void caughtExceptionHandler(NSException *exception) {
    // 获取异常崩溃信息
    NSArray *callStatck = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",
                               name,
                               reason,
                               [callStatck componentsJoinedByString:@"\n"]];
    SNDOLOG(@"%s, content:%@", __FUNCTION__, exceptionInfo);
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
     BOOL result = [WXApi handleOpenURL:url delegate:self];
    if (!result) {
        return [self handleOpenUrl:url];
    }
    return result;
}

- (BOOL)handleOpenUrl:(NSURL *)url{
//    if([url.absoluteString rangeOfString:@"snquyay://type=skillDetail"].location
    return YES;
}



-(BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(nonnull UIApplicationExtensionPointIdentifier)extensionPointIdentifier{
    //    YAYLOG(@"%s", __FUNCTION__);
    return YES;
}


//返回URL组装过后的Dic
- (NSMutableDictionary *)handleOfUlr:(NSString *)urlString{
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *array = [urlString componentsSeparatedByString:@"?"];
    for (int i = 1; i < array.count; i ++ ) {
        NSString *title = array[i];
        NSArray*testArray = [title componentsSeparatedByString:@"="];
        if (testArray.count == 2) {
            [dic setValue:testArray[1] forKey:testArray[0]];
        }
    }
    
    return dic;
}

- (void)topViewController{
    
}
#pragma 支付相关
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiAlipayResult object:nil userInfo:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }else{
            [WXApi handleOpenURL:url delegate:[SDPayManager sharedInstance]];
        }
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
//wxdc4fa2800211d0d3://oauth?code=021A7nGM1RyUf81wU6FM1g7aGM1A7nGM&state=wx_oauth_authorization_state
    if (!(result && [url.absoluteString containsString:@"oauth?code="])) {
        [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    }
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiAlipayResult object:nil userInfo:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }else{
            [WXApi handleOpenURL:url delegate:[SDPayManager sharedInstance]];
        }
    }
    return result;
}


- (void)initKeyboard {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
//    keyboardManager.shouldShowTextFieldPlaceholder = NO; // 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字

    //    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类
        SendAuthResp *req = (SendAuthResp *)resp;
        if([req.state isEqualToString:@"wx_oauth_authorization_state"]){//微信授权成功
            NSString *code = req.code;
            NSLog(@"微信授权成功 code %@", code);
            if (code) {
                NSDictionary *info = @{@"code": code};
                [[NSNotificationCenter defaultCenter] postNotificationName:KWechatLoginCode object:nil userInfo:info];
            }
        }
//https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxdc4fa2800211d0d3&secret=001Xk7L90UUdnx16JBM90AV0L90Xk7LF&code=021X3t2C0Hs82i2ICt3C0Nng2C0X3t2-&grant_type=authorization_code
        
    }
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        NSDictionary *resultDic = @{@"errCode" : @(response.errCode)};
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiWechatPayResult object:nil userInfo:resultDic];
    }
}
@end
