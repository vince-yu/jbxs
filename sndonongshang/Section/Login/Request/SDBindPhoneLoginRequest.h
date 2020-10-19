//
//  SDBindPhoneLoginRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBindPhoneLoginRequest : SDBSRequest

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) SDUserModel *userModel;

@end

NS_ASSUME_NONNULL_END
