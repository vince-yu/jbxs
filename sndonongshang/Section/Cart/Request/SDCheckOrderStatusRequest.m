//
//  SDCheckOrderStatusRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCheckOrderStatusRequest.h"

@implementation SDCheckOrderStatusRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order/paycheck.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return @{@"_id":self.orderId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.orderId = [self.ret objectForKey:@"is_payed"];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
