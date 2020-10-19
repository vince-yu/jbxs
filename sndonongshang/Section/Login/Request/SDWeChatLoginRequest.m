//
//  SDWeChatLoginRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDWeChatLoginRequest.h"

@implementation SDWeChatLoginRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/wxAppLogin.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"code":self.wechatCode,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret[@"setLogin"]) {
        self.userInfo = self.ret[@"setLogin"];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
