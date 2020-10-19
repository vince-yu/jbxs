//
//  SDAddressMgrViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"
#import "SDAddressMgrCell.h"

NS_ASSUME_NONNULL_BEGIN


/**
 选中地址发生变化

 @param addrModel 选中地址模型
 @param isDel 选中地址被删除
 */
typedef void(^SDSelectedAddrUpdateBlock)(SDAddressModel *addrModel, BOOL isDel);

@interface SDAddressMgrViewController : SDBaseViewController

/** 下单 选中地址Model */
@property (nonatomic, strong) SDAddressModel *selectedAddrModel;
@property (nonatomic, copy) SDSelectedAddrUpdateBlock selectedAddrBlock;

@end

NS_ASSUME_NONNULL_END
