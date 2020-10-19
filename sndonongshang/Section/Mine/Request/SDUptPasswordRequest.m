//
//  SDUptPasswordRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDUptPasswordRequest.h"

@implementation SDUptPasswordRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/uptPassword.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"old_password":self.oldPassword,
             @"new_password":self.password
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
