//
//  SDHomeBannerRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeBannerRequest.h"
#import "SDHomeBannerModel.h"

@implementation SDHomeBannerRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/banner/list.json"];
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
    
    self.dataArray = [SDHomeBannerModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
- (BOOL)nodissMissHud{
    return YES;
}
@end
