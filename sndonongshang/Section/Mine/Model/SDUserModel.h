//
//  SDUserModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDUserModel : NSObject

/** 用户的平台id */
@property (nonatomic, copy) NSString *userId;
/** 昵称 从三方微信获取 */
@property (nonatomic, copy) NSString *nickname;
/** 手机号 */
@property (nonatomic, copy) NSString *mobile;
/** 0未知/保密 1男性 2女性 */
@property (nonatomic, assign) int sex;

@property (nonatomic, copy) NSString *header;
/** 默认地址信息 */
@property (nonatomic, copy) NSString *address;
/** 地址信息数组 */
@property (nonatomic, copy) NSArray *addr;
/** 出生日期 */
@property (nonatomic, copy) NSString *birthday;
/** 优惠券张数 */
@property (nonatomic, strong) NSString *voucher_num;
/** 是否设置密码 0否 1是 */
@property (nonatomic, assign) int seted_password;
/** 是否绑定微信 0否 1是 */
@property (nonatomic, assign) int binded_wechat;

@property (nonatomic, copy) NSString *token;

/** 总佣金 元 */
@property (nonatomic, copy) NSString *brokerage;
/** 拉新佣金 元 */
@property (nonatomic, copy) NSString *brokerageInvite;
/** 商品佣金 元 */
@property (nonatomic, copy) NSString *brokerageGoods;
/** 当前角色 [0:普通 2:淘客 1:团长] */
@property (nonatomic, assign) SDUserRolerType role;
/** 是否团长 [1:是 0:否] 只有当is_regiment=1时，role才有可能=1 */
@property (nonatomic, assign) BOOL isRegiment;
/**是否处于活动中**/
@property (nonatomic, assign) BOOL activiting;
//备注：团长申请情况 未申请:null 申请中:0 申请成功:1 申请 失败:2
@property (nonatomic, copy) NSString *regimentApply;

+ (instancetype)sharedInstance;
+ (void)destroyInstance;

/** 是否登录 */
- (BOOL)isLogin;
- (NSString *)getToken;
@end

NS_ASSUME_NONNULL_END
