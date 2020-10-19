//
//  Constant.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#ifndef SDMacroConstant_h
#define SDMacroConstant_h

//-------------------获取设备大小-------------------------
// NavigationBar高度
#define NAVIGATION_BAR_HEIGHT 44

// Tabbar高度
#define TAB_BAR_HEIGHT 49

// StatusBar高度
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

// NavigationBar + StatusBar 高度
#define TOP_BAR_HEIGHT (NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT)

// iPhone X底部高度
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

// 全部底部高度
#define BOTTOM_BAR_HEIGHT (TAB_BAR_HEIGHT + SafeAreaBottomHeight)

// 获取屏幕宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define Screen40 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen47 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen55 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

/** 判断是否为iPhone */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/** 判断是否是iPad */
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6/6s/7/8 分辨率375x667，像素750x1334，@2x */
#define iPhone6_6s_7_8 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6/6s/7/8 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6_6s_7_8_plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone X/XS 分辨率375x812，像素1125x2436，@3x */
#define iPhoneX_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone XR 分辨率414x896，像素828x21792，@2x */
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

/** 设备是否为iPhone XS Max 分辨率414x896，像素1242x2688，@3x */
#define iPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define kStatusBarHeight (iPhoneX_All ? 44.0 : 20)
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define kTabBarHeight (iPhoneX_All ? 83.0 : 49.0)
#define kBottomSafeHeight (iPhoneX_All? 34.0f:0.0f)

//------------------单例写法-------------------

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)    \
\
+ (__CLASSNAME__*) sharedInstance;    \


#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__)    \
\
static __CLASSNAME__ *instance = nil;   \
\
+ (__CLASSNAME__ *)sharedInstance{ \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
if (nil == instance){   \
instance = [[__CLASSNAME__ alloc] init];    \
}   \
}); \
\
return instance;   \
}   \

//----------------------系统----------------------------
// 获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]     //浮点型
#define CURRENT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]       //字符串型
#define LESS_IOS8_2                 ([[[UIDevice currentDevice] systemVersion] doubleValue] <= 8.2)
#define IOS9                        ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 10.0)
#define IOS11                       ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 12.0)
// 获取当前语言
#define CURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])


//----------------------颜色类---------------------------
// 带有RGBA的颜色设置
#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 带有RGB的颜色设置
#define RGB(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.f]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#ifndef    weakify

#define weakify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif

#ifndef    strongify

#define strongify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#endif

#define SD_WeakSelf        @weakify(self);
#define SD_StrongSelf      @strongify(self);

#endif /* Constant_h */
