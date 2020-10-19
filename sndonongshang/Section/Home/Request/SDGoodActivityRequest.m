//
//  SDGoodActivityRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodActivityRequest.h"

@implementation SDGoodActivityRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/goods/remind.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.type.length) {
        [dic setObject:self.type forKey:@"type"];
    }
    if (self.goodId.length) {
        [dic setObject:self.goodId forKey:@"goods_id"];
    }
    if (self.goodsremind) {
        [dic setObject:@"goodsremind" forKey:@"scope"];
    }
    return dic;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.status =  [NSString stringWithFormat:@"%@",[self.ret objectForKey:@"status"]];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
