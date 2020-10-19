//
//  SDGoodCouponRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodCouponRequest.h"
#import "SDCouponsModel.h"

@implementation SDGoodCouponRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/voucher/goods.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    if (self.type.length) {
        return @{
                 @"all":self.type,
                 };
    }else{
        return nil;
    }
    
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];

    self.couponsArr = [SDCouponsModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
