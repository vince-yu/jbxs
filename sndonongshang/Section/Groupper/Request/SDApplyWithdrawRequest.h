//
//  SDApplyWithdrawRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDApplyWithdrawRequest : SDBSRequest

@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *amount;

@end

NS_ASSUME_NONNULL_END
