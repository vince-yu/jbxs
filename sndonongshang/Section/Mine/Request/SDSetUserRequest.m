//
//  SDSetUserRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSetUserRequest.h"

@implementation SDSetUserRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/setUser.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    NSMutableDictionary *dic  =[NSMutableDictionary dictionary];
    if ([self.birthday isNotEmpty]) {
        [dic setValue:self.birthday forKey:@"birthday"];
    }
    if ([self.sex isNotEmpty]) {
        [dic setValue:@([self.sex integerValue]) forKey:@"sex"];
    }
    return [dic copy];
}

@end
