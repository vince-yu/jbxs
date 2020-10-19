//
//  SDOrderTransInfo.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderTransInfo.h"

@implementation SDOrderTransInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"addrId":@"_id",
             @"houseNumber":@"house_number",
             @"addTime":@"add_time",
             @"editTime":@"edit_time",
             @"addrDetail":@"addr_detail",
             @"userId":@"user_id",
             @"isDefault":@"is_default"
             };
}

@end
