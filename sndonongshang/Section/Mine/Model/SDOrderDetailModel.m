//
//  SDOrderDetailModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderDetailModel.h"

@implementation SDOrderDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"orderId":@"_id",
             @"goodsInfo":@"goods_info",
             @"addTime":@"add_time",
             @"outTradeNo":@"out_trade_no",
             @"totalPrice":@"total_price",
             @"transPrice":@"trans_price",
             @"reducePrice":@"reduce_price",
             @"pickTime":@"pick_time",
             @"pickDate":@"pick_date",
             @"transInfo":@"trans_info",
             @"repoInfo":@"repo_info",
             @"receiverMobile":@"receiver_mobile",
             @"refundedAmount":@"refunded_amount",
             @"expressCom":@"expressCom",
             @"expressNo":@"express_no"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"goodsInfo":@"SDGoodModel"};
}

- (void)setAddTime:(NSString *)addTime {
    _addTime = addTime;
    self.orderTime = [_addTime convertDateStringWithTimeStr:@"yyyy-MM-dd HH:mm"];
}

- (void)setDelivery:(NSString *)delivery {
    _delivery = delivery;
    NSString *timeStr = [_delivery convertDateStringWithTimeStr:@"MM月dd日hh:mm"];
    self.arriveTime = [NSString stringWithFormat:@"大约%@送达", timeStr];
}

@end
