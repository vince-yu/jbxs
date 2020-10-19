//
//  SDBrokerageInfoRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBrokerageInfoRequest.h"

@implementation SDBrokerageInfoRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/brokerage/getInfo.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.model = [SDBrokerageModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
