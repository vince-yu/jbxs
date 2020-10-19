//
//  SDCartListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartListRequest.h"

@implementation SDCartListRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/cart/get.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.cartModel = [SDCartListModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
