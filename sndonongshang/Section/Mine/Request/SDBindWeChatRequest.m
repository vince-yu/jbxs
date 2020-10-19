//
//  SDBindWeChatRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBindWeChatRequest.h"

@implementation SDBindWeChatRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/bindWechatAPP.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"code": self.wechatCode};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}


@end
