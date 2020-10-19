//
//  SDStaticsManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * _Nullable const kmain_home =    @"main_home";    //    主页面_首页点击
static NSString * _Nullable const kmain_cart =    @"main_cart";    //    主页面_购物车点击
static NSString * _Nullable const kmain_me =    @"main_me";    //    主页面_我的点击
static NSString * _Nullable const kcommission_me =    @"commission_me";   //    我的佣金页面——我的收入点击
static NSString * _Nullable const kcommission_order =    @"commission_order";    //    我的佣金页面——订单管理点击
static NSString * _Nullable const kagreement =    @"agreement";    //    点击用户协议
static NSString * _Nullable const kwx_login =    @"wx_login";    //    点击微信登录按钮
static NSString * _Nullable const kwxshouquan_cg =    @"wxshouquan_cg";    //    微信授权成功
static NSString * _Nullable const kwxshouquan_sb =    @"wxshouquan_sb";    //    微信授权失败
static NSString * _Nullable const kwxshouquan_qx =    @"wxshouquan_qx";    //    微信授权取消
static NSString * _Nullable const kwxbangding_cg =    @"wxbangding_cg";    //    微信绑定成功
static NSString * _Nullable const kwxbangding_sb =    @"wxbangding_sb";    //    微信绑定失败
static NSString * _Nullable const klogin_next =    @"login_next";    //    登录注册页_点击下一步按钮
static NSString * _Nullable const klogin_pwd_code=    @"login_pwd_code";     //    账户密码页_验证码登录按钮
static NSString * _Nullable const klogin_pwd_forget =    @"login_pwd_forget";    //    账户密码页_忘记密码按钮
static NSString * _Nullable const klogin_pwd_login =    @"login_pwd_login";    //    账户密码页_登录按钮点击
static NSString * _Nullable const kforget_pwd_code =    @"forget_pwd_code";    //    忘记密码_输入验证码点击下一步
static NSString * _Nullable const kforget_pwd_save =    @"forget_pwd_save";    //    忘记密码_保存新密码
static NSString * _Nullable const klogin_code_login =    @"login_code_login";    //    输入验证码_登录按钮点击
static NSString * _Nullable const klogin_code_pwd =    @"login_code_pwd";    //    输入验证码_密码登录点击
static NSString * _Nullable const klogin_code_misscode =    @"login_code_misscode";    //    注册页_收不到验证码
static NSString * _Nullable const klogin_code_next =    @"login_code_next";    //    注册页_下一步
static NSString * _Nullable const kreg_complete =    @"reg_complete";    //    注册页_完成按钮
static NSString * _Nullable const kreg_skip =    @"reg_skip";    //    注册页_跳过密码设置
static NSString * _Nullable const kbd_get_code =    @"bd_get_code";    //    绑定手机页面_获取验证码按钮
static NSString * _Nullable const kbd_login_btn =    @"bd_login_btn";    //    绑定手机页面_绑定手机按钮
static NSString * _Nullable const kbd_success =    @"bd_success";    //    绑定手机页面_成功
static NSString * _Nullable const kbd_fail =    @"bd_fail";    //    绑定手机页面_失败
static NSString * _Nullable const kbanner =    @"banner";       //参数加id    //    首页_banner点击
static NSString * _Nullable const kcommander_btn_sure =    @"commander_btn_sure";    //    团长招募令_我要成为团长按钮点击
static NSString * _Nullable const kcommander_address =    @"commander_address";    //    团长申请_选择收货地址点击
static NSString * _Nullable const kcommander_info_submit =    @"commander_info_submit";    //    团长申请_提交按钮点击
static NSString * _Nullable const khome_channel =    @"home_channel"; //参数加id,name    //    首页_频道item点击
static NSString * _Nullable const khome_floor =    @"home_floor";   //参数加id,name    //    首页_楼层_更多入口点击
static NSString * _Nullable const kfresher_dialog =    @"fresher_dialog";    //    新人_弹窗
static NSString * _Nullable const kfresher_btn_receive =    @"fresher_btn_receive";    //    新人_去领取点击
static NSString * _Nullable const kfresher_btn_cancel =    @"fresher_btn_cancel";    //    新人_取消点击
static NSString * _Nullable const kfresher_reg_success =    @"fresher_reg_success";    //    新人_注册成功
static NSString * _Nullable const kfresher_reg_fail =    @"fresher_reg_fail";    //    新人_注册失败
static NSString * _Nullable const kfresher_coupon_distribution =    @"fresher_coupon_distribution";    //    新人_优惠券发放
static NSString * _Nullable const klx_btn_invite =    @"lx_btn_invite";    //    拉新_邀请按钮点击
static NSString * _Nullable const klx_share_qq =    @"lx_share_qq";    //    拉新_点击分享到QQ
static NSString * _Nullable const klx_share_wx =    @"lx_share_wx";    //    拉新_点击分享到微信
static NSString * _Nullable const klx_share_circle =    @"lx_share_circle";    //    拉新_点击分享到朋友圈
static NSString * _Nullable const klx_rule =    @"lx_rule";    //    拉新_活动规则点击
static NSString * _Nullable const klx_share_success =    @"lx_share_success";    //    拉新_分享成功
static NSString * _Nullable const klx_share_fail =    @"lx_share_fail";    //    拉新_分享失败
static NSString * _Nullable const klx_share_cancel =    @"lx_share_cancel";    //    拉新_取消分享
static NSString * _Nullable const klx_success =    @"lx_success";    //    拉新_成功
static NSString * _Nullable const klx_share_url_count =    @"lx_share_url_count";    //    拉新_分享链接打开次数
static NSString * _Nullable const kgoods_home_add =    @"goods_home_add";         //参数加商品id,type,name    //    首页_商品列表_添加购物车
static NSString * _Nullable const kgoods_home_item =    @"goods_home_item";        //参数加商品id,type,name    //    首页_商品列表_商品列表item点击
static NSString * _Nullable const kgoods_cart_item =    @"goods_cart_item";        //参数加商品id,type,name    //    购物车_商品列表item点击
static NSString * _Nullable const kgoods_add =    @"goods_add";              //参数加商品id,type,name    //    商品列表_添加购物车按钮点击
static NSString * _Nullable const kgoods_item =    @"goods_item";             //参数加商品id,type,name    //    商品列表_商品列表item点击
static NSString * _Nullable const kgoods_cart_click =    @"goods_cart_click";           //    商品列表_购物车图标点击
static NSString * _Nullable const kgoods_tab =    @"goods_tab";              //参数加id,name    //    商品列表_tab点击
static NSString * _Nullable const kdetail_share =    @"detail_share";           //参数加type,id,name    //    商品详情_分享按钮点击
static NSString * _Nullable const kdetail_share_qq =    @"detail_share_qq";        //参数加type,id,name    //    商品详情_点击分享到QQ的
static NSString * _Nullable const kdetail_share_wx =    @"detail_share_wx";        //参数加type,id,name    //    商品详情_点击分享到微信
static NSString * _Nullable const kdetail_share_circle =    @"detail_share_circle";    //参数加type,id,name    //    商品详情_点击分享到朋友圈
static NSString * _Nullable const kdetail_share_success =    @"detail_share_success";   //参数加type,id,name,platform(QQ,WEIXIN,WEIXIN_CIRCLE)    //    商品详情_分享成功
static NSString * _Nullable const kdetail_share_cancel =    @"detail_share_cancel";    //参数加type,id,name,platform(QQ,WEIXIN,WEIXIN_CIRCLE)    //    商品详情_取消分享
static NSString * _Nullable const kdetail_share_fail =    @"detail_share_fail";      //参数加type,id,name,platform(QQ,WEIXIN,WEIXIN_CIRCLE)    //    商品详情_分享失败
static NSString * _Nullable const kdetail_share_buy =    @"detail_share_buy";    //    分享出去的商品购买
static NSString * _Nullable const kdetail_coupon =    @"detail_coupon";    //    商品详情_已领券点击
static NSString * _Nullable const kdetail_cart_click =    @"detail_cart_click";    //    商品详情_购物车按钮点击
static NSString * _Nullable const kdetail_add =    @"detail_add";            //参数加商品id,type,name    //    商品详情_加入购物车按钮点击
static NSString * _Nullable const kdetail_buy =    @"detail_buy";            //参数加商品id,type,name    //    商品详情_立即购买按钮点击
static NSString * _Nullable const kdetail_tohome =    @"detail_tohome";            //    商品详情_首页点击
static NSString * _Nullable const kdetail_remind =    @"detail_remind";         //参数加商品id,type,name    //    商品详情_提醒我点击
static NSString * _Nullable const kdetail_remind_cancel =    @"detail_remind_cancel";  //参数加商品id,type,name    //    商品详情_取消提醒点击
static NSString * _Nullable const kdetail_invite =    @"detail_invite";    //    商品详情_邀请好友点击
static NSString * _Nullable const kdetail_recommend_item =    @"detail_recommend_item";  //参数加商品id,type,name    //    商品详情_点击推荐的商品
static NSString * _Nullable const kdetail_goods_num =    @"detail_goods_num";       //参数加商品id,type,name，num    //    商品详情_商品选择数量
static NSString * _Nullable const kcart_goods_num =    @"cart_goods_num";    //    购物车_商品购买数量
static NSString * _Nullable const kcart_goods_ids =    @"cart_goods_ids";    //    购物车_购买的商品-商品ID
static NSString * _Nullable const kAcart_goods_del =    @"cart_goods_del";         //参数加商品id,type,name    //    购物车_删除商品
static NSString * _Nullable const kcart_selected =    @"cart_selected";    //    购物车_全选点击
static NSString * _Nullable const kcart_order =    @"cart_order";    //    购物车_去结算点击
static NSString * _Nullable const kpurchase_todoor =    @"purchase_todoor";    //    下单页面_送货上门点击
static NSString * _Nullable const kpurchase_tostore =    @"purchase_tostore";    //    下单页面_到店自取送货上门
static NSString * _Nullable const kpurchase_todoor_address =    @"purchase_todoor_address";    //    下单页面_点击新建收货地址按钮
static NSString * _Nullable const kpurchase_tostore_addresslist =    @"purchase_tostore_addresslist";    //    下单页面_前置仓地址页面
static NSString * _Nullable const kpurchase_goods =    @"purchase_goods";    //    下单页面_点击商品清单
static NSString * _Nullable const kpurchase_coupon =    @"purchase_coupon";    //    下单页面_点击优惠券
static NSString * _Nullable const kpurchase_coupon_id =    @"purchase_coupon_id";   //参数加选中的优惠券id+运费券id    //    下单页面_选中的优惠券-优惠券ID
static NSString * _Nullable const kpurchase_coupon_tab1 =    @"purchase_coupon_tab1";       //    下单页面_可以使用的优惠券tap点击
static NSString * _Nullable const kpurchase_coupon_tab2 =    @"purchase_coupon_tab2";    //    下单页面_不可使用的优惠券tap点击
static NSString * _Nullable const kpurchase_coupon_sure =    @"purchase_coupon_sure";    //    下单页面_优惠券确定按钮点击
static NSString * _Nullable const kpurchase_order_btn =    @"purchase_order_btn";    //    下单页面_提交订单按钮
static NSString * _Nullable const kpay_wx =    @"pay_wx";    //    支付_点击微信支付
static NSString * _Nullable const kpay_zfb =    @"pay_zfb";    //    支付_点击支付宝支付
static NSString * _Nullable const kpay_wx_success =    @"pay_wx_success";    //    支付_微信支付成功
static NSString * _Nullable const kpay_zfb_success =    @"pay_zfb_success";    //    支付_支付宝支付成功
static NSString * _Nullable const kpay_wx_fail =    @"pay_wx_fail";    //    支付_微信支付失败
static NSString * _Nullable const kpay_zfb_fail =    @"pay_zfb_fail";    //    支付_支付宝支付失败
static NSString * _Nullable const kpay_wx_cancel =    @"pay_wx_cancel";    //    支付_微信支付取消
static NSString * _Nullable const kpay_zfb_cancel =    @"pay_zfb_cancel";    //    支付_支付宝支付取消
static NSString * _Nullable const kpay_result_detail =    @"pay_result_detail";    //    支付结果_查看订单点击
static NSString * _Nullable const kpay_result_tohome =    @"pay_result_tohome";    //    支付结果_回到首页点击
static NSString * _Nullable const kpay_result_reorder =    @"pay_result_reorder";    //    支付结果_重新支付点击
static NSString * _Nullable const kme_login =    @"me_login";    //    我的页面_点击登录注册按钮
static NSString * _Nullable const kuserinfo_sex_btn =    @"userinfo_sex_btn";    //    我的账户_性别点击
static NSString * _Nullable const kuserinfo_sex =    @"userinfo_sex";    //    我的账户_用户性别
static NSString * _Nullable const kuserinfo_birthday_btn =    @"userinfo_birthday_btn";    //    我的账户_出生日期点击
static NSString * _Nullable const kuserinfo_birthday =    @"userinfo_birthday";    //    我的账户_用户年龄情况
static NSString * _Nullable const kuserinfo_pwd_set =    @"userinfo_pwd_set";    //    我的账户_设置密码点击
static NSString * _Nullable const kuserinfo_pwd_change =    @"userinfo_pwd_change";    //    我的账户_修改密码点击
static NSString * _Nullable const kuserinfo_wx_bind =    @"userinfo_wx_bind";    //    我的账户_微信绑定点击
static NSString * _Nullable const kuserinfo_role_switch =    @"userinfo_role_switch";    //    我的账户_切换角色点击
static NSString * _Nullable const kuserinfo_role_pre =    @"userinfo_role_pre";    //    我的账户_切换前的角色
static NSString * _Nullable const kuserinfo_role_now =    @"userinfo_role_now";    //    我的账户_切换后的角色
static NSString * _Nullable const kuserinfo_role_cancel =    @"userinfo_role_cancel";    //    我的账户_取消切换
static NSString * _Nullable const kme_setting =    @"me_setting";    //    我的_点击设置按钮
static NSString * _Nullable const ksetting_version_check =    @"setting_version_check";    //    设置_版本更新点击
static NSString * _Nullable const ksetting_version_update =    @"setting_version_update";    //    设置_立即升级点击
static NSString * _Nullable const ksetting_version_refused =    @"setting_version_refused";    //    设置_残忍拒绝点击
static NSString * _Nullable const ksetting_logout =    @"setting_logout";    //    设置_退出当前账号点击
static NSString * _Nullable const kme_coupon =    @"me_coupon";    //    我的页面_点击优惠券入口
static NSString * _Nullable const kcoupon_item =    @"coupon_item";  //参数id type    //    我的优惠券_去使用
static NSString * _Nullable const kme_commission =    @"me_commission";    //    我的页面_点击我的佣金入口
static NSString * _Nullable const kincome_withdrawal =    @"income_withdrawal";    //    我的收入_点击提现按钮
static NSString * _Nullable const kincome_tab_today =    @"income_tab_today";    //    我的收入_点击今日收入tap
static NSString * _Nullable const kincome_tab_yesterday =    @"income_tab_yesterday";    //    我的收入_点击昨日收入tap
static NSString * _Nullable const kincome_lx =    @"income_lx";    //    我的收入_点击拉新增加收入按钮
static NSString * _Nullable const kincome_increment =    @"income_increment";    //    我的收入_点击佣金增加收入按钮
static NSString * _Nullable const kwithdrawal_code =    @"withdrawal_code";    //    我的收入_提现_获取验证码按钮点击
static NSString * _Nullable const kwithdrawal_code_check =    @"withdrawal_code_check";    //    我的收入_提现_验证按钮点击
static NSString * _Nullable const kwithdrawal_submit =    @"withdrawal_submit";    //    我的收入_提现_提交按钮点击
static NSString * _Nullable const kwithdrawal_bind_zfb =    @"withdrawal_bind_zfb";    //    我的收入_提现_绑定支付宝
static NSString * _Nullable const kordermg_tz =    @"ordermg_tz";    //    订单管理_团长订单点击
static NSString * _Nullable const kordermg_normal =    @"ordermg_normal";    //    订单管理_普通订单点击
static NSString * _Nullable const kordermg_tab_dsh =    @"ordermg_tab_dsh";        //参数:role  1团长 0普通    //    订单管理_待收货点击
static NSString * _Nullable const kordermg_tab_complete =    @"ordermg_tab_complete";   //参数:role  1团长 0普通    //    订单管理_已完成点击
static NSString * _Nullable const kordermg_tab_all =    @"ordermg_tab_all";        //参数:role  1团长 0普通    //    订单管理_全部点击
static NSString * _Nullable const kordermg_fh_dialog =    @"ordermg_fh_dialog";      //参数：订单id    //    订单管理_发货按钮点击
static NSString * _Nullable const kordermg_fh_cancel =    @"ordermg_fh_cancel";      //参数：订单id    //    订单管理_发货确认弹窗取消点击
static NSString * _Nullable const kordermg_fh_ok =    @"ordermg_fh_ok";          //参数：订单id    //    订单管理_发货确认弹窗确定点击
static NSString * _Nullable const kme_order_total =    @"me_order_total";    //    我的页面_点击全部订单
static NSString * _Nullable const kme_order_topay =    @"me_order_topay";    //    我的页面_待付款点击
static NSString * _Nullable const kme_order_dsh =    @"me_order_dsh";    //    我的页面_待收货点击
static NSString * _Nullable const kme_order_complete =    @"me_order_complete";    //    我的页面_已完成点击
static NSString * _Nullable const kme_order_all =    @"me_order_all";    //    我的页面_全部订单点击
static NSString * _Nullable const korder_list_dfk =    @"order_list_dfk";    //    订单列表_待付款点击
static NSString * _Nullable const korder_list_dsh =    @"order_list_dsh";    //    订单列表_待收货点击
static NSString * _Nullable const korder_list_complete =    @"order_list_complete";    //    订单列表_已完成点击
static NSString * _Nullable const korder_list_all =    @"order_list_all";    //    订单列表_全部点击
static NSString * _Nullable const korder_list_topay =    @"order_list_topay";    //    订单列表_去支付点击
static NSString * _Nullable const kme_role_to_tz =    @"me_role_to_tz";    //    我的页面_成为团长点击
static NSString * _Nullable const kme_role_be_tz =    @"me_role_be_tz";    //    我的页面_我是团长点击
static NSString * _Nullable const kaddress_add =    @"address_add";    //    地址_地址管理_新增地址
static NSString * _Nullable const kaddress_save =    @"address_save";    //    地址_新建地址_保存
static NSString * _Nullable const kaddress_edit =    @"address_edit";    //    地址_编辑地址_保存
static NSString * _Nullable const kaddress_poi_search =    @"address_poi_search";    //    地址_搜索POI
static NSString * _Nullable const kaddress_del =    @"address_del";    //    地址_删除
static NSString * _Nullable const kme_service =    @"me_service";    //    我的页面_客服电话点击

static NSString * _Nullable const    kSplash              =   @"Splash";    //    启动页面
static NSString * _Nullable const    kHome                =   @"Home";    //    首页
static NSString * _Nullable const    kShoppingCart        =   @"ShoppingCart";    //    购物车
static NSString * _Nullable const    kUser                =   @"User" ;   //    我的
static NSString * _Nullable const    kLogin               =   @"Login";   //    登录/注册
static NSString * _Nullable const    kLoginPwd            =   @"LoginPwd";    //    输入账号密码
static NSString * _Nullable const    kLoginCode           =   @"LoginCode";    //    输入验证码登录
static NSString * _Nullable const    kRegist              =   @"Regist";    //    注册页
static NSString * _Nullable const    kRegistComplete      =   @"RegistComplete";    //    注册页-完成
static NSString * _Nullable const    kRetrievePwd1        =   @"RetrievePwd1";    //    找回密码-步骤1
static NSString * _Nullable const    kRetrievePwd2        =   @"RetrievePwd2";    //    找回密码-步骤2
static NSString * _Nullable const    kRetrievePwd3        =   @"RetrievePwd3";    //    找回密码-步骤3
static NSString * _Nullable const    kChangePwd           =   @"ChangePwd";    //    修改密码
static NSString * _Nullable const    kBindPhone           =   @"BindPhone";    //    绑定手机
static NSString * _Nullable const    kGoodsList           =   @"GoodsList";    //    商品列表
static NSString * _Nullable const    kGoodsDetail         =   @"GoodsDetail";    //    商品详情
static NSString * _Nullable const    kOrderCreate         =   @"OrderCreate";    //    下单页面
static NSString * _Nullable const    kOrderPay            =   @"OrderPay";    //    支付页面
static NSString * _Nullable const    kOrderPaySuccess     =   @"OrderPaySuccess";    //    支付成功
static NSString * _Nullable const    kOrderPayFail        =   @"OrderPayFail";    //    支付失败
static NSString * _Nullable const    kUserInfo            =   @"UserInfo";    //    我的账户
static NSString * _Nullable const    kSetting             =   @"Setting";    //    设置
static NSString * _Nullable const    kOrderList           =   @"OrderList";    //    我的订单
static NSString * _Nullable const    kOrderDetail         =   @"OrderDetail";    //    订单详情
static NSString * _Nullable const    kUserCoupon          =   @"UserCoupon";    //    我的优惠券
static NSString * _Nullable const    kIncome              =   @"Income";    //    我的收入
static NSString * _Nullable const    kWithdrawCode        =   @"WithdrawCode";    //    提现安全验证
static NSString * _Nullable const    kWithdraw            =   @"Withdraw";    //    提现
static NSString * _Nullable const    kOrderManager_tz     =   @"OrderManager_tz";    //    订单管理-团长
static NSString * _Nullable const    kOrderManager_normal =   @"OrderManager_normal";    //    订单管理-普通
static NSString * _Nullable const    kOrderManager_detail =   @"OrderManager_detail";    //    订单管理-详情

typedef enum : NSUInteger {
    SDStaticsTypeEvent = 0, // 事件统计
    SDStaticsTypePage = 1,   //页面统计
    SDStaticsTypeLaunch = 2, // 启动
    
    
} SDStaticsType;

@interface SDStaticsManager : NSObject
+ (instancetype _Nullable )instance;
+ (void)umEvent:(NSString *_Nullable)key;
+(void)umEvent:(NSString *_Nullable)key attr:(NSDictionary *_Nullable)dic;
+ (void)umBeginPage:(NSString *_Nullable)page type:(NSString *_Nullable)type;
+ (void)umEndPage:(NSString *_Nullable)page type:(NSString *_Nullable)type;
+ (void)uploadData;
@end

