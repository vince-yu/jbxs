//
//  SDCartOderRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOderRequest.h"

@implementation SDCartOderRequestGoodModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodId":@"_id"
             };
}


@end

@implementation SDCartOderRequestModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods":@"SDCartOderRequestGoodModel"};
}
- (void)setType:(SDCartOrderType )type{
    _type = type;
}
@end

@implementation SDCartOderRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.requestModel.isPrepay forKey:@"is_prepay"];
    BOOL value = self.requestModel.userAddrId.length && self.requestModel.type == SDCartOrderTypeDelivery;
    if (self.requestModel.userAddrId.length && (self.requestModel.type == SDCartOrderTypeDelivery || self.requestModel.type ==  SDCartOrderTypeDeliveryOnly)) {
        [dic setObject:self.requestModel.userAddrId forKey:@"user_addr_id"];
//        [dic setObject:self.requestModel.deliveryTime forKey:@"delivery_time"];
    }
    if (self.requestModel.type == SDCartOrderTypeSelfTake) {
        if (self.requestModel.repoId.length) {
            [dic setObject:self.requestModel.repoId forKey:@"repo_id"];
        }else{
            [dic setObject:@"" forKey:@"repo_id"];
        }
        
    }
    if (self.requestModel.receiver.length && self.requestModel.type == SDCartOrderTypeSelfTake) {
        [dic setObject:self.requestModel.receiver forKey:@"receiver"];
    }
    if (self.requestModel.mobile.length && self.requestModel.type == SDCartOrderTypeSelfTake) {
        [dic setObject:self.requestModel.mobile forKey:@"mobile"];
    }
    if (self.requestModel.isPrepay.integerValue == 0) {
        [dic setObject:self.requestModel.prepayHash forKey:@"prepay_hash"];
    }
    //字典无序，所以上传商品无序
    for (int i = 0 ; i < self.requestModel.goods.count ; i ++) {
        SDCartOderRequestGoodModel *goodModel = [self.requestModel.goods objectAtIndex:i];
        NSString *goodStr = [NSString stringWithFormat:@"goods[%d]",i];
        if (goodModel.num.length) {
            [dic setObject:goodModel.num forKey:[NSString stringWithFormat:@"%@[num]",goodStr]];
        }
        if (goodModel.type.length) {
            [dic setObject:goodModel.type forKey:[NSString stringWithFormat:@"%@[type]",goodStr]];
        }
        if (goodModel.goodId.length) {
            [dic setObject:goodModel.goodId forKey:[NSString stringWithFormat:@"%@[_id]",goodStr]];
        }
    }
    [dic setValue:self.requestModel.voucherId forKey:@"voucher_id"];
    [dic setValue:self.requestModel.freighVoucherId forKey:@"freight_voucher_id"];


//    [dic setObject:self.requestModel.goods forKey:@"goods"];
    return dic;
}
//@"Content-Type": @"application/x-www-form-urlencoded",
- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{
             @"Content-Type": @"application/x-www-form-urlencoded",
             @"headMode": @"",
             @"User-Agent": @"iOS",
             @"Device-Type": @"5",
             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
             @"appVersion": [UIApplication sharedApplication].appVersion
             };
}
- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.orderModel = [SDCartOderModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}
- (BOOL )noFaildAlterShow{
    return YES;
}
@end
