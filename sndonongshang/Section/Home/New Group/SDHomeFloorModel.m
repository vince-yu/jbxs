//
//  SDHomeFloorModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeFloorModel.h"

@implementation SDHomeFloorModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tabId":@"tab_id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"goods":@"SDGoodModel"};
}
@end
