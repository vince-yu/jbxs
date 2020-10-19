//
//  SDGrouperNavViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperNavViewController.h"
#import "SDBaseGreenViewController.h"
@interface SDGrouperNavViewController ()

@end

@implementation SDGrouperNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([viewController isKindOfClass:[SDBaseGreenViewController class]]) {
        [leftBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    }else {
        [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    }
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    leftBtn.cp_size = CGSizeMake(60, 30);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationBarHidden = NO;
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
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
        if (self.tabBarController && self.childViewControllers.count == 1) {
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
            //        [self.tabBarController.navigationController.navigationBar setHidden:NO];
            //        [self.tabBarController.tabBarController.tabBar setHidden:NO];
        }else {
            [self popViewControllerAnimated:YES];
            
        }
    }
    
}
@end
