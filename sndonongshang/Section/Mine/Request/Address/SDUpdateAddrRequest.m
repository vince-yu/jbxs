//
//  SDUpdateAddrRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDUpdateAddrRequest.h"

@implementation SDUpdateAddrRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/useraddr/put.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return [self.addressModel mj_JSONObject];
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

@end
