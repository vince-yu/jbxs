//
//  SDOrderListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderListRequest.h"

@implementation SDOrderListRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order/list.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}


- (id)requestArgument {
    
    return @{
//             @"limit":self.limit,
             @"page":self.page,
             @"status":self.status,
             @"role":self.role,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.listModel = [SDOrderListModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
