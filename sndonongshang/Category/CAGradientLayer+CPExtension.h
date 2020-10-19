//
//  CAGradientLayer+CPExtension.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAGradientLayer (CPExtension)


/**
 渐变颜色 layer

 @param colors 渐变颜色 数组
 @param locations 颜色变化数组 与colors对应
 @param points 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
 @param frame layer frame
 @return CAGradientLayer
 */
+ (CAGradientLayer *)gradientLayerWithColors:(NSArray *)colors locations:(NSArray *)locations points:(NSArray *)points frame:(CGRect)frame;


/**
 通用绿色渐变颜色
 colors =   @[[UIColor colorWithRGB:0x39CF11],
              [UIColor colorWithHexString:kSDGreenTextColor]
            ];
 locations = @[@0, @1];
 points = @[@(CGPointMake(0, 0)), @(CGPointMake(1, 0))];
 */
+ (CAGradientLayer *)gradientGreenLayerWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
