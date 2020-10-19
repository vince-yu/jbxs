//
//  UIImage+CPExtension.h
//  video_SNQU
//
//  Created by SNQU on 2018/12/13.
//  Copyright © 2018 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CPExtension)
    
- (UIImage *)cp_circleImage;
+ (UIImage *)cp_imageWithColor:(UIColor *)color;
+ (UIImage *)cp_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)cp_imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius size:(CGSize)size;
+ (UIImage *)cp_imageWithColor:(UIColor *)color  byRoundingCorners:(UIRectCorner)rectCorner  cornerRadius:(CGFloat)radius size:(CGSize)size;

/**
 **   生成高清二维码图片
 ** content:  二维码的内容
 ** size:    生成二维码的图片大小
 **/
+ (UIImage *)cp_createQRCodeImageWithContent:(NSString *)content size:(CGFloat)size;

/** 生成渐变色图片 */
+ (UIImage *)cp_gradientImageWithColors:(NSArray *)colors rect:(CGRect)rect;
/** 生成渐变色图片 points 位置 */
+ (UIImage *)cp_gradientImageWithColors:(NSArray *)colors points:(NSArray *)points rect:(CGRect)rect;

/** 设置图片的alpah值 */
+ (UIImage *)cp_imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

/** 生成和导航栏导航栏背景色一样的图片 */
+ (UIImage *)cp_imageByCommonGreenWithFrame:(CGRect)frame;

+ (UIImage *)cp_imageByDottedLine;

@end
NS_ASSUME_NONNULL_END
