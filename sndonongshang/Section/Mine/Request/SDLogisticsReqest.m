//
//  SDLogisticsReqest.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLogisticsReqest.h"

@implementation SDLogisticsReqest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order/express.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return @{
             @"order_id":self.orderId,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.listModel = [SDLogisticsListModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
