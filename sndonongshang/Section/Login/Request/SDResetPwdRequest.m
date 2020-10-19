//
//  SDResetPwdRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDResetPwdRequest.h"

@implementation SDResetPwdRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/resetPwd.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    if (self.password) {
        return @{@"mobile":self.mobile,
                 @"code":self.smsCode,
                 @"new_password":self.password,
                 };
    }
    return @{@"mobile":self.mobile,
             @"code":self.smsCode,
             };
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
