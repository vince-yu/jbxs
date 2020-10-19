//
//  SDGetUserRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGetUserRequest.h"
#import "SDVersionCheckRequest.h"
#import "SDHomeDataManager.h"

@implementation SDGetUserRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/getUser.json"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    SDUserModel *userModel = [SDUserModel sharedInstance];
    SDUserModel *model = [SDUserModel mj_objectWithKeyValues:self.ret];
//    model.role = SDUserRolerTypeTaoke;
    [userModel mj_setKeyValues:model];
    [SDHomeDataManager checkVerifyStatus];
}
@end
