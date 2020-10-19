//
//  SDPayRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDWeChatPayModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SDPayMethodWechat, // 微信支付
    SDPayMethodAliPay // 支付宝支付
} SDPayMethod;

@interface SDPayRequest : SDBSRequest
/** 订单Id */
@property(nonatomic ,copy) NSString *orderId;
/** 支付方式 SDPayWayWechat 微信支付 SDPayWayAliPay 支付宝支付 */
@property (nonatomic, assign) SDPayMethod payMethod;

/** 微信支付订单信息 */
@property (nonatomic, strong) SDWeChatPayModel *wechatPayModel;
/** 支付宝支付订单信息 */
@property (nonatomic, copy) NSString *alipayOrderInfo;

@end

NS_ASSUME_NONNULL_END
