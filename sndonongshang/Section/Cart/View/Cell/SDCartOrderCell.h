//
//  SDCartOrderCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCartOderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowOrderListBlock)(void);

@interface SDCartOrderCell : UITableViewCell
@property (nonatomic ,copy) ShowOrderListBlock showBlock;
@property (nonatomic ,strong) SDCartOderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
