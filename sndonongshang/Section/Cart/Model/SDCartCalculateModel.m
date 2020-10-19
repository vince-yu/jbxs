//
//  SDCartCalculateModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartCalculateModel.h"

@implementation SDCartCalculateMoreModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"goodsId":@"goods_id",
             @"priceActive":@"price_active",
             @"userHadBuy":@"user_had_buy",
             @"ableCheap":@"able_cheap",
             @"limitPerUser":@"limit_per_user"
             };
}
- (SDCalculateType)type{
    _type = SDCalculateTypeSecondKillNomal;
    int beyond = self.beyond.intValue;
    int num = self.num.intValue;
    if (beyond == 0) { //未超限制  正常展示原价、活动价
        if (self.ableCheap.intValue > 0) {
            //提示：剩余优惠able_cheap份
            _type = SDCalculateTypeSecondKillGoodLimit;
            self.tips = [NSString stringWithFormat:@"剩余优惠%d%@", self.ableCheap.intValue, self.spec];
        }
    } else if (beyond == num) { // user 2  num 2  beyond 2
        if ([self.limiting isEqualToString:@"user"]) { //超过个人   秒杀x0 正常x2
            if (self.userHadBuy > 0) {
                _type = SDCalculateTypeSecondKillUserNone;
                  self.tips = [NSString stringWithFormat:@"每人限购%@%@，已购%@%@", self.limitPerUser, self.spec, self.userHadBuy, self.spec];
            }
        } else { //超过商品总量  展示原价
            _type = SDCalculateTypeSecondKillGoodNone;
        }
    } else if (beyond < num) { //user 3 num 3 beyong 1  buy 2
        //提示:每人限购limit_per_user份，已购user_had_buy份
        if ([self.limiting isEqualToString:@"user"]) {
            if (self.userHadBuy.intValue > 0) { // 若当前用户所剩优惠份数小于单用户限购
                _type = SDCalculateTypeSecondKillUserLimit;
                self.tips = [NSString stringWithFormat:@"每人限购%@%@，已购%@%@", self.limitPerUser, self.spec, self.userHadBuy, self.spec];
            }else {
                _type = SDCalculateTypeSecondKillUserLimitNoBuy;
                self.tips = [NSString stringWithFormat:@"每人限购%@%@", self.limitPerUser, self.spec];
            }
        }else {
            if (self.ableCheap.intValue > 0) {
                //提示：剩余优惠able_cheap份
                _type = SDCalculateTypeSecondKillGoodLimitBeyond;
                self.tips = [NSString stringWithFormat:@"剩余优惠%d%@", self.ableCheap.intValue, self.spec];
            }
        }
    }
    return _type;
}
@end

@implementation SDCartCalculateTipsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"deliveryPrice":@"delivery_price",
             @"shippingPrice":@"shipping_price",
             };
}
@end


@implementation SDCartCalculateModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"totalNum":@"total_num",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"more":@"SDCartCalculateMoreModel"};
}
@end
