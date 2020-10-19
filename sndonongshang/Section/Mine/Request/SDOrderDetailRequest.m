//
//  SDOrderDetailRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderDetailRequest.h"

@implementation SDOrderDetailRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{
             @"_id":self.orderId,
              @"role":self.role,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.orderModel = [SDOrderDetailModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
