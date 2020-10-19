//
//  AppDelegate+Config.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Config)
/** 初始化 window */
- (void)initWindow;
/** 初始化地图 */
- (void)initLocationManager;
/** 初始化键盘操作 */
- (void)initKeyboard;
- (void)config;
/** 开启网络监测 */
- (void)networkMonitoring;
/** UI控件 全局通用配置 */
- (void)appearanceConfig;
/** 设置WKWebview userAgent */
- (void)setupUserAgent;

@end

NS_ASSUME_NONNULL_END
