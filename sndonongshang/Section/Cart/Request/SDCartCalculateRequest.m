//
//  SDCartCalculateRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartCalculateRequest.h"

@implementation SDCartCalculateRequestModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodId":@"goods_id",
             @"targetNum":@"target_num"
             };
}


@end

@implementation SDCartCalculateRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/goods/calculate.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"cart_info":self.goodsInfo};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.model = [SDCartCalculateModel mj_objectWithKeyValues:self.ret];
    if (self.model.tips.deficiency.length && !self.model.tips.reach.length && !self.model.tips.postage.length) {
        self.model.type = SDValuationTypeNoDelivery;
    }
    if (!self.model.tips.deficiency.length && !self.model.tips.reach.length && self.model.tips.postage.length) {
        self.model.type = SDValuationTypeDeliveryOnly;
    }
    if (!self.model.tips.deficiency.length && self.model.tips.reach.length && !self.model.tips.postage.length) {
        self.model.type = SDValuationTypeFreightFree;
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
