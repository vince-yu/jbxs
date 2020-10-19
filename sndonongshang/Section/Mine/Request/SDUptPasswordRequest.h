//
//  SDUptPasswordRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDUptPasswordRequest : SDBSRequest

@property (nonatomic, copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
