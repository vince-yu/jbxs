//
//  SDRecruitViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SDApplyRoleTaoke,
    SDApplyRoleGrouper,
} SDApplyRole;

@interface SDRecruitViewController : SDBaseViewController
@property (nonatomic ,assign) SDApplyRole applyRole;
@end

NS_ASSUME_NONNULL_END
