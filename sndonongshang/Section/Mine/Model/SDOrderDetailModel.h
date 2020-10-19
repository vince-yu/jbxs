//
//  SDOrderDetailModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDOrderTransInfo.h"
#import "SDOrderRepoInfo.h"
#import "SDLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDOrderDetailModel : SDBSRequest

/** 订单Id */
@property (nonatomic ,copy) NSString *orderId;
/** 下单时间 时间戳 */
@property (nonatomic ,copy) NSString *addTime;
/** 商户订单号 给用户展示的订单号 */
@property (nonatomic ,copy) NSString *outTradeNo;
/** 订单状态[待付款:2 待收货(出库中):3 已发货:31 已完成:4 取消:15] */
@property (nonatomic ,copy) NSString *status;
@property (nonatomic, copy) NSString *totalNum;
/** 商品总价（元) */
@property (nonatomic ,copy) NSString *totalPrice;
/** 实际支付金额 （元） */
@property (nonatomic ,copy) NSString *amount;
/** 运费（元） */
@property (nonatomic ,copy) NSString *transPrice;
/** 优惠金额 */
@property (nonatomic, copy) NSString *reducePrice;
@property (nonatomic ,strong) NSArray *goodsInfo;
/** ：订单类型 1:普通 2:团购 */
@property (nonatomic, copy) NSString *type;
/** 预计送货上门时间 */
@property (nonatomic, copy) NSString *delivery;
/** 自提时间范围 */
@property (nonatomic, copy) NSString *pickTime;
/** 自提日期范围 */
@property (nonatomic, copy) NSString *pickDate;
@property (nonatomic, copy) NSString *repoId;
/** 配送方式 [送货上门:1 到店自提:2  团长订单:3] */
@property (nonatomic, copy) NSString *distribution;
@property (nonatomic, copy) NSString *timeout;

/** 送货上门信息 */
@property (nonatomic, strong) SDOrderTransInfo *transInfo;
@property (nonatomic, strong) SDOrderRepoInfo *repoInfo;
/** 佣金比例 */
@property (nonatomic, copy) NSString *rate;
/** 佣金 */
@property (nonatomic, copy) NSString *brokerage;
/** 退款金额 元 */
@property (nonatomic, copy) NSString *refundedAmount;

#pragma mark - 额外属性
/** 下单时间 */
@property (nonatomic, copy) NSString *orderTime;
/** 送达时间 */
@property (nonatomic, copy) NSString *arriveTime;

/** 自提人 */
@property (nonatomic, copy) NSString *receiver;

/** 自提电话 */
@property (nonatomic, copy) NSString *receiverMobile;
/** 物流名称 */
@property (nonatomic ,copy) NSString *expressCom;
/** 物流单号 */
@property (nonatomic ,copy) NSString *expressNo;
/** 最近的物流信息**/
@property (nonatomic ,strong) SDLogisticsModel *expressModel;
@end

NS_ASSUME_NONNULL_END

