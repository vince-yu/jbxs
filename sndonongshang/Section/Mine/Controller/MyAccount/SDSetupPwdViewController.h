//
//  SDSetupPwdViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/22.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^setupPwdBlock)(void);

@interface SDSetupPwdViewController : SDBaseViewController

@property (nonatomic, copy) setupPwdBlock block;

@end

NS_ASSUME_NONNULL_END
