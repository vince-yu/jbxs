//
//  CAGradientLayer+CPExtension.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "CAGradientLayer+CPExtension.h"

@implementation CAGradientLayer (CPExtension)

+ (CAGradientLayer *)gradientLayerWithColors:(NSArray *)colors locations:(NSArray *)locations points:(NSArray *)points frame:(CGRect)frame {
    if (!colors.count || !locations.count || CGRectEqualToRect(frame, CGRectZero) || points.count != 2) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    NSMutableArray *CGColorsArr = [NSMutableArray array];
    for (UIColor *color in colors) {
        [CGColorsArr addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = [CGColorsArr copy];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = [points[0] CGPointValue];
    gradientLayer.endPoint =  [points[1] CGPointValue];
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = locations;
    return gradientLayer;
}

+ (CAGradientLayer *)gradientGreenLayerWithFrame:(CGRect)frame {
//    NSArray *colors =  @[[UIColor colorWithRGB:0x39CF11],
//                        [UIColor colorWithHexString:kSDGreenTextColor]];
    NSArray *colors = @[[UIColor colorWithRGB:0x39CF11 alpha:0.5],
                        [UIColor colorWithRGB:0x16bc2e alpha:0.5]];
    NSArray *locations = @[@0, @1];
    NSArray *points = @[@(CGPointMake(0, 0)), @(CGPointMake(1, 0))];
    return [CAGradientLayer gradientLayerWithColors:colors locations:locations points:points frame:frame];
}

@end
