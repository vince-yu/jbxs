//
//  SDGoodDetailModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodDetailModel.h"

@implementation SDGoodShareInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"miniProgmPath":@"mini_progm_path",
             @"miniProgmId":@"mini_progm_id",
             @"picUrl":@"pic_url"
             };
}
@end

@implementation SDGoodDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodId":@"_id",
             @"groupId":@"group_id",
             @"priceLadder":@"price_ladder",
             @"priceActive":@"price_active",
             @"endTime":@"end_time",
             @"shareInfo":@"share_info",
             @"rule":@"group_rule",
             @"subName":@"sub_name",
             @"limitPerUser":@"limit_per_user",
             @"rebateRate":@"rebate_rate",
             @"startTime":@"start_time",
             @"totalInventory":@"total_inventory",
             @"currentTime":@"current_time",
             @"miniPic":@"mini_pic",
             @"obtainVoucherMsg":@"obtain_voucher_msg",
             @"soldOut":@"sold_out",
             
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"recommend":@"SDGoodModel"};
}
- (void)setShareInfo:(NSDictionary *)shareInfo{
    NSArray *keyArray = shareInfo.allKeys;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString *key in keyArray) {
        SDGoodShareInfo *info = [SDGoodShareInfo mj_objectWithKeyValues:shareInfo[key]];
        [dic setObject:info forKey:key];
    }
    _shareInfo = dic;
}
@end
