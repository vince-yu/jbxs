//
//  SDLoginPwdRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLoginPwdRequest.h"

@implementation SDLoginPwdRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"mobile":self.mobile,
             @"password":self.password
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
