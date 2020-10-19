//
//  SDGoodListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodListRequest.h"

@implementation SDGoodListRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/goods/list.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return @{
             @"limit":self.limit,
             @"page":self.page,
             @"tab_id":self.tabId,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.listModel = [SDGoodListModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
