//
//  SDCartRepoListModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartRepoListModel.h"

@implementation SDCartRopoLocationModel



@end

@implementation SDCartRepoListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"repoId":@"_id",
             @"distance":@"distance_km",
             };
}
@end
