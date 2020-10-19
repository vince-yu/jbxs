//
//  SDCheckUserRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCheckUserRequest.h"

@implementation SDCheckUserRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/checkuser.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"mobile":self.mobile,
             };
}
- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    if (self.ret) {
        self.exists = [self.ret[@"exists"] boolValue];
        self.password = [self.ret[@"password"] boolValue];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
