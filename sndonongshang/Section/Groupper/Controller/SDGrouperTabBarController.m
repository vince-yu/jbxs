//
//  SDGrouperTabBarController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperTabBarController.h"
#import "SDGrouperOrdrController.h"
#import "SDGrouperShopController.h"
#import "SDGrouperNavViewController.h"
#import "SDMyIncomeViewController.h"
#import "SDAmoyMyEquityViewController.h"
#import "SDGrouperFriendViewController.h"

@interface SDGrouperTabBarController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

//static SDGrouperTabBarController *grouperTabBar

@implementation SDGrouperTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    self.fd_interactivePopDisabled = YES;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                               tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                         imageInsets:imageInsets
                                                                             titlePositionAdjustment:titlePositionAdjustment
                                                                                             context:nil
                                             ];
    [self customizeTabBarAppearance:tabBarController];
    self.tab = tabBarController;
//    self.tab.tabBarItem.unselectedItemTintColor = [UIColor colorWithHexString:@"0x131413"];
    self.tab.delegate = self;
    return self;
}

- (NSArray *)viewControllers {
    
    
    SDMyIncomeViewController *firstViewController = [[SDMyIncomeViewController alloc] init];
    //    firstViewController.view.backgroundColor = [UIColor randomColor];
    SDGrouperNavViewController *firstNavigationController = [[SDGrouperNavViewController alloc]
                                                             initWithRootViewController:firstViewController];
    
    SDGrouperOrdrController *secondViewController = [[SDGrouperOrdrController alloc] init];
    //    secondViewController.view.backgroundColor = [UIColor randomColor];
    SDNavigationViewController *secondNavigationController = [[SDGrouperNavViewController alloc]
                                                              initWithRootViewController:secondViewController];
    
    SDAmoyMyEquityViewController *thirdViewController = [[SDGrouperFriendViewController alloc] init];
    SDGrouperNavViewController *thirdNavigationController = [[SDGrouperNavViewController alloc]
                                                             initWithRootViewController:thirdViewController];
//
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"我的佣金",
                                                 CYLTabBarItemImage : @"grouper_income",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"grouper_income_selected",  /* NSString and UIImage are supported*/
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"好友订单",
                                                  CYLTabBarItemImage : @"grouper_order",
                                                  CYLTabBarItemSelectedImage : @"grouper_order_selected",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的好友",
                                                  CYLTabBarItemImage : @"grouper_friend",
                                                  CYLTabBarItemSelectedImage : @"grouper_friend_selected",
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    //    tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 40;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRGB:0x131413];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] =  [UIColor colorWithHexString:kSDGreenTextColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [UIColor colorWithHexString:kSDSeparateLineClolor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UITabBar appearance] setShadowImage:img];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    //    [self customizeTabBarSelectionIndicatorImage];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
//    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
//    //        [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
//
//    // set the bar background image
//    // 设置背景图片
//    UITabBar *tabBarAppearance = [UITabBar appearance];
//
//    [UITabBar appearance].translucent = NO;
//    NSString *tabBarBackgroundImageName = @"tabbarBg";
//    UIImage *tabBarBackgroundImage = [UIImage imageNamed:tabBarBackgroundImageName];
//    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage];
//    [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
//
//    // remove the bar system shadow image
//    // 去除 TabBar 自带的顶部阴影
//    // iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
//    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,
//                                   [UIColor colorWithHexString:kSDSeparateLineClolor].CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [[UITabBar appearance] setShadowImage:img];
////    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [self.tab hideTabBadgeBackgroundSeparator];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = kStatusBarHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor whiteColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)scaleImage:(UIImage *)image {
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    UIImage *secondStrechImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    return secondStrechImage;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger i = [[self viewControllers] indexOfObject:viewController];
    switch (i) {
            case 0:
            [SDStaticsManager umEvent:kcommission_me];
            break;
            case 1:
            [SDStaticsManager umEvent:kcommission_order];
            break;
        default:
            break;
    }
}
@end
