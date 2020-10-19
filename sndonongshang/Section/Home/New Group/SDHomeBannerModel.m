//
//  SDHomeBannerModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeBannerModel.h"
#import "SDNetConfig.h"

@implementation SDHomeBannerModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"_id",
             @"picUrl":@"pic_url",
             @"clientsUrl":@"clients_url",
             @"pubStatus":@"pub_status",
             };
}
- (void)setPicUrl:(NSString *)picUrl{
    if ([picUrl hasPrefix:@"http://"] || [picUrl hasPrefix:@"https://"]) {
        _picUrl = picUrl;
    }else {
        NSString *baseUrl = [SDNetConfig sharedInstance].baseUrl;
        NSString *picStr = [NSString stringWithFormat:@"%@%@", baseUrl, picUrl];
        _picUrl = picStr;
    }
}
@end
