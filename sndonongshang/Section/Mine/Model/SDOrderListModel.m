//
//  SDOrderListModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderListModel.h"

@implementation SDOrderListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"orderId":@"_id",
             @"goodsInfo":@"goods_info",
             @"addTime":@"add_time",
             @"outTradeNo":@"out_trade_no",
             @"totalPrice":@"total_price",
             @"transPrice":@"trans_price",
             @"totalNum":@"total_num",
             @"receiverMobile":@"receiver_mobile",
             @"transInfo":@"trans_info",
             @"refundedAmount":@"refunded_amount"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"goodsInfo":@"SDGoodModel"};
}

- (void)setAddTime:(NSString *)addTime {
    _addTime = addTime;
    self.time = [_addTime convertDateStringWithTimeStr:@"yyyy-MM-dd HH:mm"];
}

- (void)setTotalNum:(NSString *)totalNum {
    _totalNum = totalNum;
    NSString *countStr = [NSString stringWithFormat:@"共%@件", _totalNum];
    NSMutableAttributedString *countText = [[NSMutableAttributedString alloc] initWithString:countStr];
    countText.yy_font = [UIFont fontWithName:kSDPFRegularFont size:12];
    countText.yy_color = [UIColor colorWithHexString:kSDSecondaryTextColor];
    [countText yy_setFont:[UIFont fontWithName:kSDPFBoldFont size:12] range:NSMakeRange(1, countStr.length - 2)];
    [countText yy_setColor:[UIColor colorWithRGB:0x131413] range:NSMakeRange(1, countStr.length - 2)];
    self.shopCountText = countText;
}

@end
