//
//  SDGoodListTabRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodListTabRequest.h"
#import "SDGoodListTabModel.h"

@implementation SDGoodListTabRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/tab.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.dataArray = [SDGoodListTabModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
