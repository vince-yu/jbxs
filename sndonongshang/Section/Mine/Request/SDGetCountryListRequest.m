//
//  SDGetCountryListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGetCountryListRequest.h"


@implementation SDGetCountryListRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/useraddr/countryList.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.countryArr = [SDCountryModel mj_objectArrayWithKeyValuesArray:self.ret];
}
@end
