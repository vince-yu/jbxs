//
//  SDGetAddrListReqeust.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGetAddrListReqeust.h"
#import "SDAddressModel.h"

@implementation SDGetAddrListReqeust
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/useraddr/list.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.addrList = [SDAddressModel mj_objectArrayWithKeyValuesArray:self.ret];
}
@end
