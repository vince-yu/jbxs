//
//  SDCartDeleteRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartDeleteRequest.h"

@implementation SDCartDeleteRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/cart/del.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return @{@"_id":self.goodId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
