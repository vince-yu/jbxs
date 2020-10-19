//
//  SDAmoyMoneyViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SDWithdrawalTypeProcessing, // 处理中
    SDWithdrawalTypeSuccess, // 提现成功
    SDWithdrawalTypeFailure // 提现失效
} SDWithdrawalType; // 提现明细

typedef enum : NSUInteger {
    SDSettlementTypeProcessing, // 处理中
    SDSettlementTypeSuccess, // 提现成功
    SDSettlementTypeFailure // 提现失效
} SDSettlementType; // 提现明细

NS_ASSUME_NONNULL_BEGIN

@interface SDAmoyMoneyViewController : UIViewController

/** 提现明细类型 */
@property (nonatomic, assign) SDSettlementType wthdrawaltype;
/** 结算记录类型 */
@property (nonatomic, assign) SDSettlementType settlementType;


@end

NS_ASSUME_NONNULL_END
