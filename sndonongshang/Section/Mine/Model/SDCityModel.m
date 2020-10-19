//
//  SDCityModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCityModel.h"

@implementation SDCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"areaId":@"_id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"citys" : @"SDCityModel"};
}

@end
