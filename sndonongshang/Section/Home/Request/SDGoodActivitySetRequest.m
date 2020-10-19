//
//  SDGoodActivitySetRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodActivitySetRequest.h"

@implementation SDGoodActivitySetRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/goods/setremind.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.type.length) {
        [dic setObject:self.type forKey:@"type"];
    }
    if (self.goodId.length) {
        [dic setObject:self.goodId forKey:@"goods_id"];
    }
    if (self.status.length) {
        [dic setObject:self.status forKey:@"status"];
    }
    if (self.goodsremind) {
        [dic setObject:@"goodsremind" forKey:@"scope"];
    }
    return dic;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}
@end
