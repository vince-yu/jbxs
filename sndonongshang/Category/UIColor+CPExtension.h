//
//  UIColor+CPExtension.h
//  video_SNQU
//
//  Created by SNQU on 2018/12/13.
//  Copyright © 2018 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CPExtension)
    
+(UIColor*)colorWithRGB:(UInt32)rgb;
+(UIColor*)colorWithRGB:(UInt32)rgb alpha:(CGFloat)alpha;
+(UInt32)rgbWithColor:(UIColor *)color;
    
+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
    
@end

NS_ASSUME_NONNULL_END
