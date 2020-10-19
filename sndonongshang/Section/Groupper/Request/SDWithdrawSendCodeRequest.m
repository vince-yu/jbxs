//
//  SDWithdrawSendCodeRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDWithdrawSendCodeRequest.h"

@implementation SDWithdrawSendCodeRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/brokerage/sendWithdrawSMS.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"code":self.smsCode
             };
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
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
