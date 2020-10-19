//
//  SDMyCouponsRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyCouponsRequest.h"
#import "SDCouponsModel.h"

@implementation SDMyCouponsRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/voucher/Mine.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{
             @"limit":@(self.limit),
             @"page":@(self.page)
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.couponsModel = [SDCouponsModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
