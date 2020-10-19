//
//  SDCartSGOderRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartSGOderRequest.h"

@implementation SDCartSGOderRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order/group.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.requestModel.isPrepay forKey:@"is_prepay"];
    if (self.requestModel.userAddrId.length) {
        [dic setObject:self.requestModel.userAddrId forKey:@"user_addr_id"];
    }
    if (self.requestModel.isPrepay.integerValue == 0) {
        [dic setObject:self.requestModel.prepayHash forKey:@"prepay_hash"];
    }
    [dic setObject:self.requestModel.goodId forKey:@"goods_id"];
    [dic setObject:self.requestModel.groupId forKey:@"group_id"];
    [dic setObject:self.requestModel.num forKey:@"num"];
    [dic setValue:self.requestModel.voucherId forKey:@"voucher_id"];
    [dic setValue:self.requestModel.freighVoucherId forKey:@"freight_voucher_id"];
    return dic;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.orderModel = [SDCartOderModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
//- (NSDictionary*)requestHeaderFieldValueDictionary {
//    return @{
//             @"Content-Type": @"application/x-www-form-urlencoded",
//             @"headMode": @"",
//             @"User-Agent": @"iOS",
//             @"Device-Type": @"5",
//             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken]
//             };
//}
@end
