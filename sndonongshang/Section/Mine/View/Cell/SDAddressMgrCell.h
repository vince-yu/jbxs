//
//  SDAddressMgrCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^editAddrBlock)(void);

@interface SDAddressMgrCell : UITableViewCell

@property (nonatomic, strong) SDAddressModel *model;
@property (nonatomic, copy) editAddrBlock block;

@end

NS_ASSUME_NONNULL_END
