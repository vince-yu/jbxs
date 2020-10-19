//
//  SDWeChatPayModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDWeChatPayModel.h"

@implementation SDWeChatPayModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"appId":@"appid",
             @"partnerId":@"partnerid",
             @"prepayId":@"prepayid",
             };
}

@end
