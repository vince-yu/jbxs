//
//  SDOrderRepoInfo.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderRepoInfo.h"

@implementation SDOrderRepoInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"repoId" : @"_id", 
             @"addrDetail" : @"addr_detail"
             };
}

@end
