//
//  SDLoginTextField.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLoginTextField.h"

@implementation SDLoginTextField

 - (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tintColor =  [UIColor colorWithHexString:kSDGreenTextColor];
        self.font = [UIFont systemFontOfSize:18];
        self.textColor = [UIColor colorWithRGB:0x3c3e40];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return  self;
}

- (void)addLine {
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.cp_w, self.cp_h);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.cp_h - 1)];
    [path addLineToPoint:CGPointMake(self.cp_w, self.cp_h - 1)];
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.path = path.CGPath;
    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithRGB:0xe6e6e6].CGColor;
    [self.layer addSublayer:borderLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addLine];
}

@end
