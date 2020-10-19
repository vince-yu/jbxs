//
//  SDGrouperFriendListRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperFriendListRequest.h"
#import "SDGrouperFriendModel.h"

@implementation SDGrouperFriendListRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/brokerage/friendrank.json"];
}
- (id)requestArgument {
    return @{@"page":self.page,
             @"limit":self.limit,
             };
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.listModel = [SDGrouperFriendListModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
