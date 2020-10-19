//
//  SDBrokerageDataManager.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBrokerageDataManager.h"

@implementation SDBrokerageDataManager

static dispatch_once_t onceToken;

+ (instancetype)sharedInstance{
    static SDBrokerageDataManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)destroyInstance {
    SNDOLOG(@"用户单例对象 销毁");
    onceToken = 0;
}

+ (void)getBrokerageInfoWithCompleteBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock {
    SDBrokerageInfoRequest *request = [[SDBrokerageInfoRequest alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDBrokerageInfoRequest * _Nonnull request) {
        [SDBrokerageDataManager sharedInstance].brokerageModel = request.model;
        if (block) {
            block();
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock();
        }
    }];
}

+ (void)sendSmsCodeWithCompleteBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock {
    SDWithdrawSendCodeRequest *request = [[SDWithdrawSendCodeRequest alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (block) {
            block();
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock();
        }
    }];
}

+ (void)checkSmsCodeWithCompleteBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock {
    if (![SDBrokerageDataManager sharedInstance].smsCode) {
        if (failedBlock) {
            failedBlock();
        }
        return;
    }
    SDWithdrawCodeCheckRequest *request = [[SDWithdrawCodeCheckRequest alloc] init];
    request.smsCode = [SDBrokerageDataManager sharedInstance].smsCode;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (block) {
            block();
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock();
        }
    }];
}

+ (void)applyWithdrawWithAmount:(NSString *)amount completeBlock:(BrokerageSuccessBlock)block failedBlock:(BrokerageFailedBlock)failedBlock {
    if (![SDBrokerageDataManager sharedInstance].smsCode || !amount) {
        if (failedBlock) {
            failedBlock();
        }
        return;
    }
    SDApplyWithdrawRequest *request = [[SDApplyWithdrawRequest alloc] init];
    request.smsCode = [SDBrokerageDataManager sharedInstance].smsCode;
    request.amount = amount;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"申请已提交，请耐心等待"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock();
        }
        [SDToastView HUDWithErrString:@"申请失败，请重新提交"];
    }];
}


@end
