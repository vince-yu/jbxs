//
//  SDApplyWithdrawRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDApplyWithdrawRequest.h"

@implementation SDApplyWithdrawRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/brokerage/withdraw.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"code":self.smsCode,
             @"amount":self.amount
             };
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}


@end
