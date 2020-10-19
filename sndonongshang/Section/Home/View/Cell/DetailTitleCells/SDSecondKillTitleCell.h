//
//  SDSecondKillTitleCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDBaseTitleCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSecondKillTitleCell : SDBaseTitleCell
@property (nonatomic ,copy) void(^timerBlock)(void);
@end

NS_ASSUME_NONNULL_END
