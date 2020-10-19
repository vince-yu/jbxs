//
//  SDBrokerageDataManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBrokerageModel.h"
#import "SDApplyWithdrawRequest.h"
#import "SDWithdrawCodeCheckRequest.h"
#import "SDBrokerageInfoRequest.h"
#import "SDWithdrawSendCodeRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BrokerageSuccessBlock)(void);
typedef void(^BrokerageFailedBlock)(void);

@interface SDBrokerageDataManager : NSObject

+ (instancetype)sharedInstance;

/** 佣金模型 */
@property (nonatomic, strong) SDBrokerageModel *brokerageModel;

/** 验证码code */
@property (nonatomic, copy) NSString *smsCode;

/** 获取个人佣金信息 */
+ (void)getBrokerageInfoWithCompleteBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock;
/** 发送验证码 */
+ (void)sendSmsCodeWithCompleteBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock;;
/** 验证码校验 */
+ (void)checkSmsCodeWithCompleteBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock;
/** 申请提现 */
+ (void)applyWithdrawWithAmount:(NSString *)amount completeBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock;;
@end

NS_ASSUME_NONNULL_END
