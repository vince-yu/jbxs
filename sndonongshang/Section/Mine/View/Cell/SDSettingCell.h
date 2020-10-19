//
//  SDSettingCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSettingCell : UITableViewCell

@property (nonatomic, strong) SDSettingModel *model;
@property (nonatomic, weak) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
