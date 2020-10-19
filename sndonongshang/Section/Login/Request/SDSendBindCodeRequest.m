//
//  SDSendBindCodeRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSendBindCodeRequest.h"

@implementation SDSendBindCodeRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/sendBindCode.json"];
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
