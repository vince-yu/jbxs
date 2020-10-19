//
//  SDSetPwdRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSetPwdRequest.h"

@implementation SDSetPwdRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/setPassword.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"password":self.password
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
