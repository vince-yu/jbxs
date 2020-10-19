//
//  SDSendResetPwdCodeRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSendResetPwdCodeRequest.h"

@implementation SDSendResetPwdCodeRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/sendResetPwdCode.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"mobile":self.mobile,
             };
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
