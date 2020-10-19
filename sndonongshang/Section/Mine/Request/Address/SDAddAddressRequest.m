//
//  SDAddAddressRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddAddressRequest.h"

@implementation SDAddAddressRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/useraddr/post.json"];
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
    NSString *addrId = self.ret[@"_id"];
    if ([addrId isNotEmpty]) {
        self.addrId = addrId;
        self.fullAddress = self.ret[@"full_addr"];
    }
}
@end
