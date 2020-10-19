//
//  UITextField+Extension.m
//  ACHPAY
//
//  Created by 陈鹏 on 2018/8/22.
//  Copyright © 2018年 陈鹏. All rights reserved.
//

#import "UITextField+Extension.h"

/** 占位文字颜色 */
static NSString * const PlaceholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (Extension)

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    BOOL change = NO;
    
    // 保证有占位文字
    if (self.placeholder == nil) {
        self.placeholder = @" ";
        change = YES;
    }
    
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:PlaceholderColorKey];
    
    // 恢复原状
    if (change) {
        self.placeholder = nil;
    }
}

- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:PlaceholderColorKey];
}

@end
