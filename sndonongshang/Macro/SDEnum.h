//
//  BSEnum.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#ifndef SDEnum_h
#define SDEnum_h

/* App环境类型 */
typedef NS_ENUM (NSInteger , AppType){
    AppType_Test = 0,          // App测试环境
    AppType_Release,          // App线上APP_Store环境
};
//服务器环境类型
typedef NS_ENUM (NSInteger , SeverType){
    SeverType_Dev = 0,          // 开发地址
    SeverType_Test,             // 测试地址
    SeverType_Release,          // 发布地址
};
//商品详情下面bar类型
typedef enum : NSUInteger {
    SDGoodBarStyleBuyAndCart = 0,//立即购买与加入购物车
    SDGoodBarStyleCart,//加入购物车
    SDGoodBarStyleSeconedKill,//秒杀
    SDGoodBarStyleDiscount,//打折
    SDGoodBarStyleRemind,//活动开始提醒
    SDGoodBarStyleGroupBuy, //团购
    SDGoodBarStyleGroupBuyRemind, //活动开始提醒(有添加好友按钮)
    SDGoodBarStyleArrivalReminder, //到货提醒
} SDGoodBarStyle;
//商品详情类型
typedef NS_ENUM(NSInteger , SDGoodDetailType){
    SDGoodDetailTypeNomal = 0,
};
//商品表单样式
typedef enum : NSUInteger {
    SDGoodsCellStyleCart = 0,//加入购物车
    SDGoodsCellStyleGroupBuy,//拼团
    SDGoodsCellStyleOrder,//订单列表中使用
    SDGoodsCellStyleGroupper,
} SDGoodsCellStyle;
//商品类型
typedef enum : NSUInteger {
    SDGoodTypeNamoal = 1,//普通商品
    SDGoodTypeGroup = 2,//团购商品
    SDGoodTypeDiscount = 3,
    SDGoodTypeSecondkill = 4,
} SDGoodType;
//订单类型
typedef enum : NSUInteger {
    SDCartOrderTypeDelivery = 0, //送货上门
    SDCartOrderTypeSelfTake = 1,   //到店自取
//    SDCartOrderTypeSelfTakeOnly
    SDCartOrderTypeSelfTakeOnly = 2,  //只有到店自取
    SDCartOrderTypeDeliveryOnly = 3, //只有送货上门
    SDCartOrderTypeHeader =4, //团长
} SDCartOrderType;
//购物车列表表单样式
typedef enum : NSUInteger {
    SDCartListCellTypeInvalid = 0, //失效
    SDCartListCellTypeNomal = 1,  //普通
    SDCartListCellTypeSupply = 2,   //下架
} SDCartListCellType;
// 用户角色类型
typedef enum : NSUInteger {
    SDUserRolerTypeNormal = 0, // 普通
    SDUserRolerTypeGrouper = 1,  // 团长
    SDUserRolerTypeTaoke = 2,  // 淘客
} SDUserRolerType;
/** 订单配送方式 */
typedef enum : NSUInteger {
    SDDistributionTypeGoShop, // 到店自提
    SDDistributionTypeGoDoor // 送货上门
} SDDistributionType;
/** 分享类型*/
typedef NS_ENUM(NSInteger , SDShareType){
    SDShareTypeGoodDetailView = 0,
    SDShareTypeLaXingView = 1,
};
/**商品cell所在位置*/
typedef NS_ENUM(NSInteger , SDGoodWhereType){
    SDGoodWhereTypeHome = 1,
    SDGoodWhereTypeList = 0,
};
//订单类型
typedef enum : NSUInteger {
    SDOrderTypeAll = 0, // 全部
    SDOrderTypeNoPay, // 待收款
    SDOrderTypeNoReceive, // 已发货
    SDOrderTypeDone, // 已完成
    SDOrderTypeNoSend, //未发货
} SDOrderType;
//估价类型
typedef enum : NSUInteger {
    SDValuationTypeNomal = 0 , //没有包邮价与起送价
    SDValuationTypeNoDelivery = 1, //不满足起送价
    SDValuationTypeDeliveryOnly = 2, //满足起送价但不满足包邮价
    SDValuationTypeFreightFree = 3, //满足起送价且满足包邮价
} SDValuationType;
//秒杀商品算价状态
typedef enum : NSUInteger {
    SDCalculateTypeSecondKillNomal = 0 ,        //秒杀商品正常显示（不超限）
    SDCalculateTypeSecondKillGoodNone = 1,      //秒杀商品已售完，按原价显示
    SDCalculateTypeSecondKillUserNone = 2,      //秒杀商品个人优惠用完，秒杀价显示 x0
    SDCalculateTypeSecondKillUserLimit = 3,      //个人优惠受限，库存不受限
    SDCalculateTypeSecondKillUserLimitNoBuy = 4, //个人优惠受限，库存不受限 用户没有买过
    SDCalculateTypeSecondKillGoodLimit = 5,     //个人优惠不受限 beyond == 0，库存受限
    SDCalculateTypeSecondKillGoodLimitBeyond = 6     //个人优惠受限 beyond < num，库存受限
} SDCalculateType;
#endif /* BSEnum_h */
