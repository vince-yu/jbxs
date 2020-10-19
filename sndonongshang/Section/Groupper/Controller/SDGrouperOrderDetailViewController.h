//
//  SDGrouperOrderDetailViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseGreenViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGrouperOrderDetailViewController : SDBaseGreenViewController
@property (nonatomic ,assign) SDUserRolerType rolerType;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic ,copy) void(^sendGoodBlock)(void);
@end

NS_ASSUME_NONNULL_END
