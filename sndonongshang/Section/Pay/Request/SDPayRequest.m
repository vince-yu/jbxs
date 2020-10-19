//
//  SDPayRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPayRequest.h"

@implementation SDPayRequest

- (NSString *)bs_requestUrl {
    return [NSString stringWithFormat:@"/order/toPay.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    NSString *payWay = self.payMethod == SDPayMethodWechat ? @"wepayAPP" : @"alipayAPP";
    return @{@"_id":self.orderId,
             @"way":payWay
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.payMethod == SDPayMethodWechat) {
        self.wechatPayModel = [SDWeChatPayModel mj_objectWithKeyValues:self.ret];
    }else if (self.payMethod == SDPayMethodAliPay) {
        self.alipayOrderInfo = self.ret[@"orderInfo"];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
