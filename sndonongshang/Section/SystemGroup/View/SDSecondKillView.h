//
//  SDSecondKillView.h
//  sndonongshang
//
//  Created by SNQU on 2019/4/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCartCalculateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSecondKillView : UIView

@property (nonatomic, strong) SDCartCalculateModel *model;
/** 商品规格 */
@property (nonatomic, copy) NSString *spec;
/** 每人限购份数 */
@property (nonatomic, copy) NSString *limitPerUser;
@end

NS_ASSUME_NONNULL_END
