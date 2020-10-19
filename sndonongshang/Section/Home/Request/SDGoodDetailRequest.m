//
//  SDGoodDetailRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodDetailRequest.h"
#import "SDGoodDetailModel.h"

@implementation SDGoodDetailRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/goods/info.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"_id":self.goodId,
                                                                               @"type":self.type,}];
    if (self.groupId.length) {
        [dic setObject:self.groupId forKey:@"group_id"];
    }
    return dic;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.detailModel = [SDGoodDetailModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
- (BOOL )noFaildAlterShow{
    return YES;
}
@end
