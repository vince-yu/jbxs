//
//  SDQRRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/5/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDQRRequest.h"

@implementation SDQRRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/brokerage/downloadQR.png"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return @{@"width": [NSNumber numberWithFloat:self.width]};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.QRImage = [UIImage imageWithData:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
//- (NSDictionary*)requestHeaderFieldValueDictionary {
//    return @{
//             @"Content-Type": @"image/png",
//             @"headMode": @"",
//             @"User-Agent": @"iOS",
//             @"Device-Type": @"5",
//             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
//             @"appVersion": [UIApplication sharedApplication].appVersion
//             };
//}
@end
