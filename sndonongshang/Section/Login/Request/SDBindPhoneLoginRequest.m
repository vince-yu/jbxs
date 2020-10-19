//
//  SDBindPhoneLoginRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBindPhoneLoginRequest.h"

@implementation SDBindPhoneLoginRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/bindPhone.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"code":self.smsCode,
             @"mobile": self.mobile
             };
}

- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{
             @"Content-Type": @"application/json",
             @"headMode": @"",
             @"User-Agent": @"iOS",
             @"Device-Type": @"5",
             @"Authorization": self.token,
             @"appVersion": [UIApplication sharedApplication].appVersion
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    SDUserModel *userModel = [SDUserModel sharedInstance];
    SDUserModel *model = [SDUserModel mj_objectWithKeyValues:self.ret];
    if (model) {
        [userModel mj_setKeyValues:model];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
