//
//  SDLogisticsModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLogisticsModel.h"

@implementation SDLogisticsListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"SDLogisticsModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"expressCom":@"express_com",
             @"expressNo":@"express_no"
             };
}
@end

@implementation SDLogisticsModel

@end
