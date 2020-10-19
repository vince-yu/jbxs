//
//  SDVersionCheckRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDVersionCheckRequest.h"

@implementation SDVersionCheckRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/set/ios.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    NSString *str = [UIApplication sharedApplication].appVersion;
    NSString *versionStr = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length == 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    NSNumber *num = [NSNumber numberWithInteger:versionStr.integerValue];
    return @{@"appVersion":num};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if ([self.ret isKindOfClass:[NSDictionary class]]) {
        BOOL status = [[self.ret objectForKey:@"audit"] boolValue];
        if (status) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KAppVerify];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiAPPVerifySuccess object:nil];
        }
    }
}
- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{
             @"Content-Type": @"application/json",
             @"headMode": @"",
             @"User-Agent": @"iOS",
             @"Device-Type": @"5",
//             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
             @"appVersion": [UIApplication sharedApplication].appVersion
             };
}
- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
