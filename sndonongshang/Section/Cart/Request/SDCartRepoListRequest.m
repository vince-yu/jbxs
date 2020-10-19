//
//  SDCartRepoListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartRepoListRequest.h"
#import "SDCartRepoListModel.h"
#import "SDCartDataManager.h"

@implementation SDCartRepoListRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/repopre/repos.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    if ([SDCartDataManager checkLocationRight]) {
        self.coordinate = [SDCartDataManager getLocationStr];
    }
    if (self.coordinate.length) {
        return @{@"coordinate":self.coordinate};
    }
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.dataArray = [SDCartRepoListModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
