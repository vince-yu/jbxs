//
//  SDBaseGreenViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseGreenViewController.h"

@interface SDBaseGreenViewController ()

@end

@implementation SDBaseGreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static UIImage *backgroundImage;
    if (!backgroundImage) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
        NSArray *colors = @[[UIColor colorWithRGB:0x39CF11],
                            [UIColor colorWithRGB:0x16bc2e]];
        backgroundImage = [self gradientImageWithColors:colors rect:frame];
    }
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSMutableDictionary *navBarAttrs = [NSMutableDictionary dictionary];
    navBarAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:navBarAttrs];
    
}


- (UIImage *)gradientImageWithColors:(NSArray *)colors rect:(CGRect)rect
{
    if (!colors.count || CGRectEqualToRect(rect, CGRectZero)) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = rect;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    NSMutableArray *mutColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [mutColors addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = [NSArray arrayWithArray:mutColors];
    
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.opaque, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
