//
//  UIColor+CPExtension.m
//  video_SNQU
//
//  Created by SNQU on 2018/12/13.
//  Copyright © 2018 SNQU. All rights reserved.
//

#import "UIColor+CPExtension.h"

@implementation UIColor (CPExtension)
+ (UIColor *)colorWithRGB:(UInt32)rgb {
    return [UIColor colorWithRGB:rgb alpha:1.f];
}
    
+(UIColor *)colorWithRGB:(UInt32)rgb alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((rgb>>16)&0xff)/255.f green:((rgb>>8)&0xff)/255.f blue:(rgb&0xff)/255.f alpha:alpha];
}

+(UInt32)rgbWithColor:(UIColor *)color {
    CGFloat r=0.f;
    CGFloat g=0.f;
    CGFloat b=0.f;
    CGFloat a=0.f;
    [color getRed:&r green:&g blue:&b alpha:&a];
    UInt32 value = ((UInt32)(r*255)<<16) + ((UInt32)(g*255)<<8) + (UInt32)b;
    return value;
}
    
+ (UIColor *)randomColor{
    return [self randomColorWithAlpha:1.f];
}
    
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha{
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    return color;
}
    
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length{
    NSString *substring   = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex     = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
    
+ (UIColor *)colorWithHexString:(NSString *)hexString{
    if ([hexString length]<1) {
        return [UIColor randomColor];
    }
        NSString *temp = [[hexString stringByReplacingOccurrencesOfString: @"0x"withString: @"0X"] uppercaseString];
        NSString *colorString = [[temp componentsSeparatedByString:@"X"]lastObject];
        CGFloat alpha=0, red=0, blue=0, green=0;
        switch ([colorString length]) {
            case 3: // #RGB
            alpha                 = 1.0f;
            red                   = [self colorComponentFrom: colorString start: 0 length: 1];
            green                 = [self colorComponentFrom: colorString start: 1 length: 1];
            blue                  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
            case 4: // #ARGB
            alpha                 = [self colorComponentFrom: colorString start: 0 length: 1];
            red                   = [self colorComponentFrom: colorString start: 1 length: 1];
            green                 = [self colorComponentFrom: colorString start: 2 length: 1];
            blue                  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
            case 6: // #RRGGBB
            alpha                 = 1.0f;
            red                   = [self colorComponentFrom: colorString start: 0 length: 2];
            green                 = [self colorComponentFrom: colorString start: 2 length: 2];
            blue                  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
            case 8: // #AARRGGBB
            alpha                 = [self colorComponentFrom: colorString start: 0 length: 2];
            red                   = [self colorComponentFrom: colorString start: 2 length: 2];
            green                 = [self colorComponentFrom: colorString start: 4 length: 2];
            blue                  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
            default:
            NSLog(@"Invalid color value %@ Color value is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

@end
