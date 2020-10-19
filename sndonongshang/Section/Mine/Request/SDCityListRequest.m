//
//  SDCityListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCityListRequest.h"

@implementation SDCityListRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/useraddr/provinceslist.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.cityList = [SDCityModel mj_objectArrayWithKeyValuesArray:self.ret];
}

@end
