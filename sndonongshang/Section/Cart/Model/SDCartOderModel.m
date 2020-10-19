//
//  SDCartOderModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOderModel.h"

@implementation SDCartOderFailedModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"localCode":@"local_code",
             @"deliveryPrice":@"delivery_price",
             @"subCode":@"sub_code"
             };
}
@end

@implementation SDCartOderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"prepayHash":@"prepay_hash",
             @"goodsInfo":@"goods_info",
             @"totalPrice":@"total_price",
             @"deliveryTime":@"delivery",
             @"transPrice":@"trans_price",
             @"pickTime":@"pick_time",
             @"orderId":@"id",
             @"reducePrice":@"reduce_price",
             @"couponAlert":@"coupon_alert",
//             @"lastReceiver":@"last_receiver",
             @"lastReceiverMobile":@"last_receiver_mobile",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"goodsInfo":@"SDGoodModel",
             @"voucher":@"SDCouponsModel"
             };
}
@end
