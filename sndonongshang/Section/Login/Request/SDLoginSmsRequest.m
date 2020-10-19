//
//  SDLoginSmsRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLoginSmsRequest.h"

@implementation SDLoginSmsRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/loginbycode.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"mobile":self.mobile,
             @"code":self.smsCode
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
