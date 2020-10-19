//
//  SDLogoutRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLogoutRequest.h"

@implementation SDLogoutRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/login/loginout.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


@end
