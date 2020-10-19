//
//  SDSendGoodRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/20.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSendGoodRequest.h"

@implementation SDSendGoodRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/order/sendGoods.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"order_id":self.orderId
             };
}
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
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
