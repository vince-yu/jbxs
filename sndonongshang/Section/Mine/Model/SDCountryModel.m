//
//  SDCountryModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCountryModel.h"

@implementation SDCountryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"countryId":@"_id"};
}
@end
