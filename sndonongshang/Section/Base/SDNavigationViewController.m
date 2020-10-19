//
//  SDNavigationViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDNavigationViewController.h"
#import "SDBaseGreenViewController.h"

@interface SDNavigationViewController ()

@end

@implementation SDNavigationViewController

+ (void)initialize
{
    // 全局设置UINavigationBar
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *navBarAttrs = [NSMutableDictionary dictionary];
    navBarAttrs[NSFontAttributeName] = [UIFont fontWithName:kSDPFBoldFont size:19];
    navBarAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:kSDMainTextColor];
    [navBar setTitleTextAttributes:navBarAttrs];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    navBar.translucent = YES;
    
    // 全局设置UIBarButtonItem
    UIBarButtonItem *barBtn = [UIBarButtonItem appearance];
    NSMutableDictionary *barBtnAttrs = [NSMutableDictionary dictionary];
    barBtnAttrs[NSBackgroundColorAttributeName] = [UIColor whiteColor];
    barBtnAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:kSDGreenTextColor];
    barBtnAttrs[NSFontAttributeName] = [UIFont fontWithName:kSDPFRegularFont size:13];
    [barBtn setTitleTextAttributes:barBtnAttrs forState:UIControlStateNormal];
    [barBtn setTitleTextAttributes:barBtnAttrs forState:UIControlStateHighlighted];
    //    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    UIImage *backArrowImage = [[UIImage imageNamed:@"arr_back"]imageWithAlignmentRectInsets:insets];
    //    [[UINavigationBar appearance] setBackIndicatorImage: backArrowImage];
    //    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backArrowImage];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >= 1) {
        self.navigationBarHidden = NO;
        viewController.hidesBottomBarWhenPushed = YES;
        UIImage *leftImage = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if ([viewController isKindOfClass:[SDBaseGreenViewController class]]) {
            leftImage = [[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }else {
         viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    SDBaseViewController* vc = (SDBaseViewController* )[self topViewController];
    BOOL shouldPop = YES;
    if( [vc respondsToSelector:@selector(navigationShouldPopOnBackButton)] && [vc isKindOfClass:[SDBaseViewController class]]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    if (shouldPop) {
         [self popViewControllerAnimated:YES];
    }
   
}
@end
