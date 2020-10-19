//
//  SDGoodListModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodListModel.h"

@implementation SDGoodListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"SDGoodModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"tabId":@"tab_id",
             };
}
@end
