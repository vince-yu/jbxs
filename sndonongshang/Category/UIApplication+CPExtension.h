//
//  UIApplication+CPExtension.h
//  video_SNQU
//
//  Created by SNQU on 2018/12/14.
//  Copyright © 2018 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (CPExtension)

@property (nonnull, nonatomic, readonly) NSString *appBundleName;

@property (nonnull, nonatomic, readonly) NSString *appBundleDisplayName;

@property (nonnull, nonatomic, readonly) NSString *appBundleID;

@property (nonnull, nonatomic, readonly) NSString *appVersion;

@property (nonnull, nonatomic, readonly) NSString *appBuildVersion;

@end

NS_ASSUME_NONNULL_END
