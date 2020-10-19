//
//  SDCartUpdateRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartUpdateRequest.h"

@implementation SDCartUpdateModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodsId":@"goods_id",
             @"targetNum":@"target_num"
             };
}

@end

@implementation SDCartUpdateRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/cart/save.json"];
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
//- (NSDictionary*)requestHeaderFieldValueDictionary {
//    return @{
//             @"Content-Type": @"application/x-www-form-urlencoded",
//             @"headMode": @"",
//             @"User-Agent": @"iOS",
//             @"Device-Type": @"5",
//             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
//             @"appVersion": [UIApplication sharedApplication].appVersion
//             };
//}
- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
