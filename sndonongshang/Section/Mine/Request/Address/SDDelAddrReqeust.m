//
//  SDDelAddrReqeust.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDelAddrReqeust.h"

@implementation SDDelAddrReqeust

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/useraddr/del.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"_id": self.addrId
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

@end
