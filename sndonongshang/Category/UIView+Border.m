//
//  UIView+Border.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/23.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UIView+Border.h"
#import "SDCouponsModel.h"

@implementation UIView (Border)

-(void)addTopBorderWithColor:(UIColor*)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

-(void)addBottomBorderWithColor:(UIColor*)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

-(void)addLeftBorderWithColor:(UIColor*)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

-(void)addRightBorderWithColor:(UIColor*)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}
#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}
- (void)addTagWithArray:(NSArray *)array discount:(NSString *)discount{
    discount = [discount subPriceStr:2];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (!array.count) {
        return;
    }
    CGFloat offset = 0;
    CGFloat space = 5;
    NSString *tagStr = nil;
    CGFloat itemHeight = 14;
    
    for (id tag in array) {
        NSInteger tagInt = [tag integerValue];
        if (tagInt != 1) {
            UIView *view = [[UIView alloc] init];
            NSArray *locations = @[@0, @1];
            NSArray *points = @[@(CGPointMake(0, 0)), @(CGPointMake(1, 0))];
            NSArray *colors = nil;
            switch (tagInt) {
                case SDGoodTypeGroup:
                {
                    tagStr = @"拼团";
                    colors = @[[UIColor colorWithRGB:0x53A6F3 alpha:1],
                               [UIColor colorWithRGB:0x3191EB alpha:1]];
                }
                    break;
                case SDGoodTypeSecondkill:
                {
                    tagStr = @"秒杀";
                    colors = @[[UIColor colorWithRGB:0xFD7675 alpha:1],
                               [UIColor colorWithRGB:0xFB5A44 alpha:1]];
                }
                    break;
                case SDGoodTypeDiscount:
                {
                    tagStr = [NSString stringWithFormat:@"%@折",discount.length ? discount:@"打"];
                    colors = @[[UIColor colorWithRGB:0xFBCD40 alpha:1],
                               [UIColor colorWithRGB:0xEEBC24 alpha:1]];
                }
                    break;
                default:
                    break;
            }
            CGSize size = [tagStr sizeWithFont:[UIFont fontWithName:kSDPFMediumFont size:10] maxSize:CGSizeMake(1000, itemHeight)];
            CGFloat itemWith = size.width + 10;
            CAGradientLayer *layer = [CAGradientLayer gradientLayerWithColors:colors locations:locations points:points frame:CGRectMake(0, 0, itemWith, itemHeight)];
            [view.layer addSublayer:layer];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.mas_equalTo(offset);
                make.width.mas_equalTo(itemWith);
            }];
            [view addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight withRadii:CGSizeMake(4, 4) viewRect:CGRectMake(0, 0, itemWith, itemHeight)];
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:kSDPFMediumFont size:10];
            label.textColor = [UIColor whiteColor];
            label.text = tagStr;
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
                make.width.mas_equalTo(itemWith);
                make.height.mas_equalTo(itemHeight);
            }];
            offset = itemWith + space + offset;
        }
    }
}
- (void)addTagBGWithType:(NSString *)type{
    NSInteger tagInt = [type integerValue];
    NSArray *colors = @[[UIColor colorWithRGB:0xc3c4c7 alpha:1],
                        [UIColor colorWithRGB:0xc3c4c7 alpha:1]];
    NSArray *locations = @[@0, @1];
    NSArray *points = @[@(CGPointMake(0, 0)), @(CGPointMake(1, 0))];
    NSString *contentText = nil;
    switch (tagInt) {
        case SDGoodTypeGroup:
        {
            colors = @[[UIColor colorWithRGB:0x53A6F3 alpha:1],
                       [UIColor colorWithRGB:0x3191EB alpha:1]];
            contentText = @"拼团";
        }
            break;
        case SDGoodTypeSecondkill:
        {
            colors = @[[UIColor colorWithRGB:0xFD7675 alpha:1],
                       [UIColor colorWithRGB:0xFB5A44 alpha:1]];
            contentText = @"秒杀";
        }
            break;
        case SDGoodTypeDiscount:
        {
            colors = @[[UIColor colorWithRGB:0xFBCD40 alpha:1],
                       [UIColor colorWithRGB:0xEEBC24 alpha:1]];
            contentText = @"";
        }
            break;
        default:
            break;
    }
    
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        if (contentText.length) {
            label.text = contentText;
        }
    }
    
    CAGradientLayer *layer = [CAGradientLayer gradientLayerWithColors:colors locations:locations points:points frame:CGRectMake(0, 0, self.width, self.height)];
    [self.layer insertSublayer:layer atIndex:0];
    [self addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight withRadii:CGSizeMake(4, 4) viewRect:CGRectMake(0, 0, self.width, self.height)];
}
- (void)addCouponWithArray:(NSArray *)array{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (!array.count) {
        return;
    }
    CGFloat itemHeight = 14;
    CGFloat offset = 0;
    CGFloat space = 10;
    
    CGFloat viewMaxWidth = SCREEN_WIDTH - 78;
    
    for (SDCouponsModel * coupon in array) {
        UIImage *image = nil;
        UIColor *textColor = nil;
        UIImage *couponImage = nil;
            switch (coupon.type.integerValue) {
                case 1:
                {
                    couponImage = [UIImage imageNamed:@"good_detail_coupon1"];
                    textColor = [UIColor colorWithHexString:@"0xE76F61"];
                    
                }
                    break;
                case 2:
                {
                    couponImage = [UIImage imageNamed:@"good_detail_coupon2"];
                    textColor = [UIColor colorWithHexString:@"0x4091EE"];
                    
                }
                    break;
                case 3:
                {
                    couponImage = [UIImage imageNamed:@"good_detail_coupon3"];
                    textColor = [UIColor colorWithHexString:@"0xE6BD49"];
                }
                    break;
                case 5:
                {
                    couponImage = [UIImage imageNamed:@"good_detail_coupon4"];
                    textColor = [UIColor colorWithHexString:@"0x16BC2E"];
                }
                    break;
                default:
                    break;
        }
        
        
        image = [couponImage resizableImageWithCapInsets:UIEdgeInsetsMake(couponImage.size.height / 2.0, 5, couponImage.size.height / 2.0, 5)];
        CGSize size = [coupon.title sizeWithFont:[UIFont fontWithName:kSDPFMediumFont size:10] maxSize:CGSizeMake(1000, itemHeight)];
        CGFloat with = size.width + 10;
        
        if (offset + with > viewMaxWidth) {
            break;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        label.textColor = textColor;
        label.text = coupon.title;
        label.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:label];
        
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.mas_equalTo(offset);
            make.width.mas_equalTo(with);
            make.height.mas_equalTo(itemHeight);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(imageView);
            make.width.mas_equalTo(with);
            make.height.mas_equalTo(itemHeight);
        }];
        offset = offset + space + with;
    }
}
@end
