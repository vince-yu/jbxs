//
//  SDAddressModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressModel.h"

@implementation SDAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"addrId":@"_id",
             @"mobileHide": @"mobile_hide",
             @"fullAddr": @"full_addr"
             };
}


@end
