//
//  SDResetPwdRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDResetPwdRequest : SDBSRequest

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
