//
//  SDBaseViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/7.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"


@interface SDBaseViewController ()

@end

@implementation SDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static UIImage *image;
    if (!image) {
        image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, kTopHeight)];
    }
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSMutableDictionary *navBarAttrs = [NSMutableDictionary dictionary];
    navBarAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:kSDMainTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:navBarAttrs];
}
- (void)changeNavType:(SDBSVCNaveType )type{
    UIImage *leftImage = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (type == SDBSVCNaveTypeGreen) {
        static UIImage *backgroundImage;
        if (!backgroundImage) {
            CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
            NSArray *colors = @[[UIColor colorWithRGB:0x39CF11],
                                [UIColor colorWithRGB:0x16bc2e]];
            backgroundImage = [self gradientImageWithColors:colors rect:frame];
        }
        leftImage = [[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        NSMutableDictionary *navBarAttrs = [NSMutableDictionary dictionary];
        navBarAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:navBarAttrs];
    }else if (type == SDBSVCNaveTypeWhite){
        static UIImage *image;
        if (!image) {
            image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, kTopHeight)];
        }
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        NSMutableDictionary *navBarAttrs = [NSMutableDictionary dictionary];
        navBarAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:kSDMainTextColor];
        [self.navigationController.navigationBar setTitleTextAttributes:navBarAttrs];
    }
    

    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
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
- (void)back
{
    if (self.navigationController.tabBarController && self.navigationController.childViewControllers.count == 1) {
        [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
        //        [self.tabBarController.navigationController.navigationBar setHidden:NO];
        //        [self.tabBarController.tabBarController.tabBar setHidden:NO];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
@end
