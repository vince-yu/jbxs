//
//  SDHomeCategroyRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeCategroyRequest.h"
#import "SDHomeCategroyModel.h"

@implementation SDHomeCategroyRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/channel.json"];
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
    
    
    self.dataArray = [SDHomeCategroyModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
- (BOOL)nodissMissHud{
    return YES;
}
@end
