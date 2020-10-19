//
//  SDLineView.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLineView.h"

@interface SDLineView ()
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic ,assign) SDDashLineType type;
@end

@implementation SDLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype )initWithType:(SDDashLineType)type{
    self.type = type;
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
//    [super drawRect:rect];
//    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor colorWithHexString:@"0xededed"].CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
    if (self.type == SDDashLineTypeVertical) {
        CGContextMoveToPoint(currentContext, self.width / 2.0, 0);
        CGContextAddLineToPoint(currentContext, self.width / 2.0, self.y + self.height);
    }else{
        CGContextMoveToPoint(currentContext, 0, self.height / 2.0);
        CGContextAddLineToPoint(currentContext, self.frame.origin.x + self.frame.size.width, self.height / 2.0);
    }
    
    //设置虚线绘制终点
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {1,4};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
//    CGContextStrokePath(currentContext);
//
//    CGContextClosePath(currentContext);
    
}
@end
