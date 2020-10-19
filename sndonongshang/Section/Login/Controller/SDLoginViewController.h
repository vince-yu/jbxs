//
//  SDLoginViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseLoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLoginViewController : SDBaseLoginViewController

@property (nonatomic, assign, getter=isShowCloseBtn) BOOL showCloseBtn;

/** 创建并弹出登录页面 */
+ (void)present;

@end

NS_ASSUME_NONNULL_END
