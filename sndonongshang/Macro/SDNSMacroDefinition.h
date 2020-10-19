//
//  BSNSMacroDefinition.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#ifndef SDNSMacroDefinition_h
#define SDNSMacroDefinition_h



//--------------------   日志输出       ----------------//
#ifdef DEBUG
#    define SNDOLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#    define SNDOLOG(...)
#endif


#define UM_KEY @"5c356b8ef1f556de3d000564"
#define UM_AliasType @"yay_user_id"
#define QQ_KEY @"1108102694"
#define QQ_SECRET @"W0nUrbxanASGXdB"

#define WEICHAT_KEY @"wxdc4fa2800211d0d3"
#define WEICHAT_SECRET @"2e0ff2dce44ee115f1968e7c069d256f"


#define SINA_KEY @"2104401357"
#define SINA_SECRET @"a7831edb6adc6a429b04f17314bce6e7"

#define AMap_Api_Key @"25ca3faa3628ff49bd082c6cb5cc03ec"

//-----支付相关----//
#define AlipaySheme @"com.snqu.sdnsalipay"
#define AlipayAPPID @""
#define AlipayMethod @"alipay.trade.app.pay"

#define WxChatPaySheme @""
#define WxChatPayAPPID @"wxdc4fa2800211d0d3"


//字体，颜色标准化
//字体颜色
static NSString * const kSDMainTextColor = @"0x27272c";
static NSString * const kSDGrayTextColor = @"0xc3c4c7";
static NSString * const kSDSecondaryTextColor = @"0x848487";
static NSString * const kSDSeparateLineClolor = @"0xebebed";
static NSString * const kSDTagLabelBGColor = @"0xf6f5f5";
static NSString * const kSDDarkTextColor = @"0xffffff";
static NSString * const kSDGreenTextColor = @"0x16bc2e";
static NSString * const kSDRedTextColor = @"0xf8665a";
static NSString * const kSDOrangeTextColor = @"0xf89c1b";
//字体类型 苹方字体在iOS 9.0以后才引入
static NSString * const kSDPFRegularFont = @"PingFangSC-Regular"; //常规字体
static NSString * const kSDPFBoldFont = @"PingFangSC-Semibold"; //粗体
//static NSString * const kSDPFSemibolFont = @"PingFangSC-Semibold"; // 中粗体
static NSString * const kSDPFMediumFont = @"PingFangSC-Medium"; //黑体
static NSString * const kSDPFLightFont = @"PingFangSC-Light"; //细体
static NSString * const kSDPFUltralightFont = @"PingFangSC-Ultraligh"; //极细体
static NSString * const kSDPFThinFont = @"PingFangSC-Thin"; //纤细体
//字体大小
static CGFloat const kSDTextSize1 = 36;
static CGFloat const kSDTextSize2 = 32;
static CGFloat const kSDTextSize3 = 28;
static CGFloat const kSDTextSize4 = 26;
static CGFloat const kSDTextSize5 = 24;
static CGFloat const kSDTextSize6 = 22;
static CGFloat const kSDTextSize7 = 20;


//--------------------  字体 颜色  ----------------//
#define BackgroundColor [UIColor color]

//--------------------  偏好设置存储  ----------------//
#define KToken @"KToken"
#define KWechatLoginCode @"KWechatLoginCode"
/** 新人优惠券弹窗是否弹出 */
#define KHomePopViewShow @"KHomePopViewShow"
//自提信息本地储存
#define kOderSelfTakePerson @"kOderSelfTakePerson"
#define kOderSelfTakePhone @"kOderSelfTakePhone"
//分享气泡
#define kGoodDetailShowShareTip @"kGoodDetailShowShareTip"
/* App环境类型 */
#define kAppType @"kAppType"
//是否是审核状态
#define KAppVerify @"KAppVerify"
//是否登陆过
#define kAppLogined @"kAppLogined"


//-------------------- 通知  ----------------//
#define KNotifiLoginSuccess @"KNotifiLoginSuccess" //登录成功通知，用于同步购物车信息
#define KNotifiAddressUpdate @"KNotifiAddressUpdate" //地址有更新
#define KNotifiCartGoodSelected @"KNotifiCartGoodSelected" //购物车商品选中通知
#define kNotifiCartPrePayReload @"kNotifiCartPrePayReload"  //刷新预支付通知
#define KNotifiWechatPayResult @"KNotifiWechatPayResult" // 微信支付结果回调
#define KNotifiAlipayResult @"KNotifiAlipayResult" // 支付宝支付结果回调
#define kNotifiRefreshCartGoodCount @"kNotifiRefreshCartGoodCount" //刷新购物车数量，用于刷新商品列表悬浮购物车数量
#define kNotifiLogoutSuccess @"kNotifiLogout" // 退出登录通知
#define kNotifiRefreshCartListTableView @"kNotifiRefreshCartListTableView" //刷新购物车列表,有请求
#define kNotifiReloadCartListTableView @"kNotifiReloadCartListTableView" //刷新购物车列表,无请求
#define kNotifiRefreshOrderTableView @"kNotifiRefreshOrderTableView" //刷新订单列表
#define kNotifiOderRepayCheck @"kNotifiOderRepayCheck" //检查订单数据是否有效
#define kNotifiRefreshListViewWithEndTime @"kNotifiRefreshListViewWithEndTime" //有倒计时，倒计时结束通知
#define kNotifiChangeRoler @"kNotifiChangeRoler" //角色切换通知
#define kNotifiOderWithErrorPrePay @"kNotifiOderWithErrorPrePay" //下单时，服务器数据与当前预下单数据不符
#define kNotifiListRefreshTime @"kNotifiListRefreshTime" //有倒计时table刷新timer与table
#define kNotifiAPPVerifySuccess @"kNotifiAPPVerifySuccess" //审核通过通知
#define kNotifiRefreshGoodDetailVC @"kNotifiRefreshGoodDetailVC" //刷新商品详情页通知

//-------------------- 服务器相关  ----------------//
/** 开发服务器地址 */
#define KSeverDevURL @"http://apifresht.sndo.com/"
/** 测试服务器地址 */
#define KServerTestURL @"http://apifresht.sndo.com/"
/** 线上服务器地址 */
#define KServerReleaseURL @"https://api.9ben.cn/"
/** H5开发服务器地址 */
#define KH5ServerDevURL @"http://h5fresht.sndo.com/"
/** H5测试服务器地址 */
#define KH5ServerTestURL @"http://h5fresht.sndo.com/"
/** H5线上服务器地址 */
#define KH5ServerReleaseURL @"https://m.9ben.cn/"



// ---------------- H5链接 ------------ //
//#define KUserProtocolUrl @"https://apifresht.sndo.com/agreement.html" // 用户协议
//#define KUserPrivateProtocolUrl @"https://apifresht.sndo.com/privacy.html" // 隐私协议
//#define KUserBeGrouperUrl @"https://h5fresht.sndo.com/activity/colonel/index.html"
#define KUserProtocolUrl ([NSString stringWithFormat:@"%@agreement.html", [SDNetConfig sharedInstance].baseUrl]) // 用户协议
#define KUserPrivateProtocolUrl ([NSString stringWithFormat:@"%@privacy.html", [SDNetConfig sharedInstance].baseUrl]) // 隐私协议
#define KUserBeGrouperUrl ([NSString stringWithFormat:@"%@activity/colonel/index.html", [SDNetConfig sharedInstance].htmlUrl])
#define kH5NewUser ([NSString stringWithFormat:@"%@share/invite.html", [SDNetConfig sharedInstance].htmlUrl])

#endif /* BSNSMacroDefinition_h */
