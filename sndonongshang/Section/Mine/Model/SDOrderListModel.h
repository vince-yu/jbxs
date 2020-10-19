//
//  SDOrderListModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDOrderTransInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDOrderListModel : NSObject
@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,copy) NSString *addTime;
@property (nonatomic ,copy) NSString *outTradeNo;
//普通订单 --- 订单状态[取消:15 等待买家付款:2 买家待收货:3 交易完成:4] 团长订单 ---订单状态[取消:15 等待买家付款:2 待发货(已支付):3 团长已发货:31 交易完成:4]
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *totalPrice;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,copy) NSString *transPrice;
@property (nonatomic ,strong) NSArray *goodsInfo;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *receiverMobile;
@property (nonatomic, copy) NSString *brokerage;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *distribution;
@property (nonatomic, strong) SDOrderTransInfo *transInfo;
@property (nonatomic, copy) NSString *refundedAmount;
#pragma mark - 额外属性
/** 时间显示 */
@property (nonatomic, copy) NSString *time;
/** 商品计数富文本 */
@property (nonatomic, copy) NSAttributedString *shopCountText;

@end

NS_ASSUME_NONNULL_END
