//
//  AppDelegate+PushService.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/7.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (PushService)
- (void)umPushConfig:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
