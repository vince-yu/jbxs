//
//  SDCouponsModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCouponsModel.h"

@implementation SDCouponsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"couponsId" : @"_id",
             @"startTime" : @"start_time",
             @"expireTime" : @"expire_time",
             @"rangeTime" : @"range_time",
             @"notObtain" : @"not_obtain"
             };
}
- (NSString *)amount{
    _amount = [_amount subPriceStr:2];
    
    return _amount;
}
- (NSString *)discount{
    _discount = [_discount subPriceStr:2];
    
    return _discount;
}
@end
