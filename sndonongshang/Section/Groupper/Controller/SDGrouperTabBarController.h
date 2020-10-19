//
//  SDGrouperTabBarController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "CYLTabBarController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDGrouperTabBarController : CYLTabBarController
@property (nonatomic ,strong) CYLTabBarController *tab;
@end

NS_ASSUME_NONNULL_END
