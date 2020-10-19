//
//  SDAddAddressCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SDAddAddressModel;

@interface SDAddAddressCell : UITableViewCell

@property (nonatomic, weak) UITextField *contentTextField;
@property (nonatomic, strong) SDAddAddressModel *model;

@end

NS_ASSUME_NONNULL_END
