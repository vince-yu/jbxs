//
//  SDTabBarViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDTabBarViewController.h"
#import "SDNavigationViewController.h"
#import "SDHomeViewController.h"
#import "SDCartListViewController.h"
#import "SDMineViewController.h"
#import "SDCartDataManager.h"

static CGFloat const CYLTabBarControllerHeight = 40.f;


@interface SDTabBarViewController () <UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation SDTabBarViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
//    [self becomeFirstResponder];
//    
//}
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
    self.tab.delegate = self;
    return self;
}

- (NSArray *)viewControllers {
    
    
    UIViewController *firstViewController = [[SDHomeViewController alloc] init];
//    firstViewController.view.backgroundColor = [UIColor randomColor];
    SDNavigationViewController *firstNavigationController = [[SDNavigationViewController alloc]
                                                   initWithRootViewController:firstViewController];

    UIViewController *secondViewController = [[SDCartListViewController alloc] init];
//    secondViewController.view.backgroundColor = [UIColor randomColor];
    SDNavigationViewController *secondNavigationController = [[SDNavigationViewController alloc]
                                                    initWithRootViewController:secondViewController];

    SDMineViewController *thirdViewController = [[SDMineViewController alloc] init];
    SDNavigationViewController *thirdNavigationController = [[SDNavigationViewController alloc]
                                                   initWithRootViewController:thirdViewController];

    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"tabbar_home",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"tabbar_home_selected",  /* NSString and UIImage are supported*/
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"购物车",
                                                  CYLTabBarItemImage : @"tabbar_car",
                                                  CYLTabBarItemSelectedImage : @"tabbar_car_selected",
                                                  };
    
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"我的",
                                                 CYLTabBarItemImage : @"tabbar_mine",
                                                 CYLTabBarItemSelectedImage : @"tabbar_mine_selected",
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
    if (@available(iOS 10.0, *)) {
        tabBar.badgeColor = [UIColor colorWithHexString:kSDGreenTextColor];
    } else {
        UIImage *badgeImage = [UIImage cp_imageWithColor:[UIColor colorWithHexString:kSDGreenTextColor] size:CGSizeMake(18, 18)];
        [self customBadgeColorWith:badgeImage];
    }

    // TabBarItem选中后的背景颜色
//    [self customizeTabBarSelectionIndicatorImage];
    
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
}
                           
- (void)customBadgeColorWith:(UIImage *)badgeImage {
    UIView *tabBarButton = (UIView *)[self performSelector:@selector(view)];
    for(UIView *subview in tabBarButton.subviews) {
        NSString *classString = NSStringFromClass([subview class]);
        if([classString rangeOfString:@"UIBadgeView"].location != NSNotFound) {
            for(UIView *badgeSubview in subview.subviews) {
                NSString *badgeSubviewClassString = NSStringFromClass([badgeSubview class]);
                if([badgeSubviewClassString rangeOfString:@"BadgeBackground"].location != NSNotFound) {
                    [badgeSubview setValue:badgeImage forKey:@"image"];
                }
            }
        }
    }
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
    NSInteger i = [[tabBarController viewControllers] indexOfObject:viewController];
    switch (i) {
        case 0:
            [SDStaticsManager umEvent:kmain_home];
            break;
        case 1:
            [SDStaticsManager umEvent:kmain_cart];
            break;
        case 2:
            [SDStaticsManager umEvent:kmain_me];
            break;
        default:
            break;
    }
}
@end
