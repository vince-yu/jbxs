//
//  SDSetRoleRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSetRoleRequest.h"

@implementation SDSetRoleRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/setRole.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"role":self.role,
             };
}
- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{
             @"Content-Type": @"application/x-www-form-urlencoded",
             @"headMode": @"",
             @"User-Agent": @"iOS",
             @"Device-Type": @"5",
             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
             @"appVersion": [UIApplication sharedApplication].appVersion
             };
}
- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
