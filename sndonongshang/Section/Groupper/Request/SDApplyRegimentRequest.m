
//
//  SDApplyRegimentRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDApplyRegimentRequest.h"

@implementation SDApplyRegimentRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/applyRegiment.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"realname":self.realName,
             @"mobile":self.mobile,
             @"community":self.community,
             @"house_number":self.houseNumber,
             @"lat":self.lat,
             @"lng":self.lng
             };
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
