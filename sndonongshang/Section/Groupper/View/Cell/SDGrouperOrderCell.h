//
//  SDGrouperOrderCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGrouperOrderCell : UITableViewCell
@property (nonatomic ,assign) SDUserRolerType rolerType;
@property (nonatomic, strong) SDOrderListModel *model;
@property (nonatomic ,copy) void(^sendGoodBlock)(SDOrderListModel *model);
@end

NS_ASSUME_NONNULL_END
