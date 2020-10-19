//
//  UIView+CPExtension.m
//  CPPlyaer
//
//  Created by SNQU on 2018/12/6.
//  Copyright © 2018 CPCoder. All rights reserved.
//

#import "UIView+CPExtension.h"

@implementation UIView (CPExtension)

- (void)setCp_x:(CGFloat)cp_x
{
    CGRect frame = self.frame;
    frame.origin.x = cp_x;
    self.frame = frame;
}

- (CGFloat)cp_x
{
    return self.frame.origin.x;
}

- (void)setCp_y:(CGFloat)cp_y
{
    CGRect frame = self.frame;
    frame.origin.y = cp_y;
    self.frame = frame;
}

- (CGFloat)cp_y
{
    return self.frame.origin.y;
}

- (void)setCp_w:(CGFloat)cp_w
{
    CGRect frame = self.frame;
    frame.size.width = cp_w;
    self.frame = frame;
}

- (CGFloat)cp_w
{
    return self.frame.size.width;
}

- (void)setCp_h:(CGFloat)cp_h
{
    CGRect frame = self.frame;
    frame.size.height = cp_h;
    self.frame = frame;
}

- (CGFloat)cp_h
{
    return self.frame.size.height;
}

- (void)setCp_size:(CGSize)cp_size
{
    CGRect frame = self.frame;
    frame.size = cp_size;
    self.frame = frame;
}

- (CGSize)cp_size
{
    return self.frame.size;
}

- (void)setCp_origin:(CGPoint)cp_origin
{
    CGRect frame = self.frame;
    frame.origin = cp_origin;
    self.frame = frame;
}

- (CGPoint)cp_origin
{
    return self.frame.origin;
}

@end
