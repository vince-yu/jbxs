//
//  SDHomeCouponsRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeCouponsRequest.h"

@implementation SDHomeCouponsRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/voucher/home.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{
             @"all":self.all,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.couponsArr = [SDCouponsModel mj_objectArrayWithKeyValuesArray:self.ret[@"list"]];
    self.alertStr = self.ret[@"alert"];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
