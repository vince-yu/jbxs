//
//  SDHomeFloorRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeFloorRequest.h"
#import "SDHomeFloorModel.h"

@implementation SDHomeFloorRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/floor.json"];
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
    
    self.dataArray = [SDHomeFloorModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
