//
//  SDAddAddressViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"
#import "SDAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SDAddrStatusTypeAdd,
    SDAddrStatusTypeUpdate,
    SDAddrStatusTypeDelete,
} SDAddrStatusType;

/**
 地址状态发生变化
 @param addrModel 地址Model
 @param statusType 0 新增 1 更新 2 删除
 */
typedef void(^addrStatusChangeBlock)(SDAddressModel *addrModel, SDAddrStatusType statusType);

@interface SDAddAddressViewController : SDBaseViewController

@property (nonatomic, strong) SDAddressModel *addressModel;
@property (nonatomic, assign, getter=isUpdate) BOOL update;
@property (nonatomic, copy) addrStatusChangeBlock block;


@end

NS_ASSUME_NONNULL_END
