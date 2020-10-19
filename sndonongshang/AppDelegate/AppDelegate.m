//
//  AppDelegate.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/3.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Config.h"
#import "SDJumpManager.h"
#import "SDHomeFloorRequest.h"
#import "SDHomeDataManager.h"
#import "SDHomeFloorModel.h"
#import "SDGoodModel.h"

@interface AppDelegate () <CYLTabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //初始化window
    [self config];
    [self initWindow];
    [self initLocationManager];
    [self initKeyboard];
//    [self umPushConfig:launchOptions];
    [self networkMonitoring];
    [self appearanceConfig];
    [self setupUserAgent];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    SDHomeFloorRequest *floor = [[SDHomeFloorRequest alloc] init];
//    floor.nodissMissHud = YES;
//    [floor startWithCompletionBlockWithSuccess:^(__kindof SDHomeFloorRequest * _Nonnull request) {
//        if (floor.dataArray.count) {
//            for (SDHomeFloorModel *floorpe in request.dataArray) {
//                if (floorpe.goods) {
//                    SDGoodModel *model = floorpe.goods.firstObject;
//                    [[SDHomeDataManager sharedInstance] restartTimer:model.currentTime];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiListRefreshTime object:nil];
//                    break;
//                }
//            }
//        }
//
//    } failure:^(__kindof SDHomeFloorRequest * _Nonnull request) {
//
//    } ];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//通过DeepLink方式请求打开APP原生页面
//实例：
//<a href="agriculture://app/appPage?param=jsonStr">打开原生页面</a>
//备注：jsonStr需要进行urlencode编码
//
//数据格式
//jsonStr={"page":页面名称,"data":{打开页面的一些必要参数},"closepage":1关闭webview}
//
//页面名称
//1．商品详情页面：
//jsonStr={"page":"GoodsDetailPage","data":{"goods_id":商品id,"type":商品类型,"group_id":团购活动id},"closepage":0}
//
//2.购物车页面：
//jsonStr={"page":"ShoppingCartPage","closepage":0}
//
//3.订单列表
//jsonStr={"page":"OrderPage","closepage":0}
//
//4.订单详情:
//jsonStr={"page":"OrderDetailPage","data":{"orderId":订单id},"closepage":0}
//
//5.WebView页面
//jsonStr={"page":"WebViewPage","data":{"url":h5链接},"closepage":0}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSLog(@"userActivity : %@",userActivity.webpageURL.description);
//    static NSString *const SDJumpLocationHeader = @"agriculture://app/appPage?param=";
    NSString *path = userActivity.webpageURL.absoluteString;
    NSString *urlStr = [NSString stringWithFormat:@"agriculture://%@", [path componentsSeparatedByString:@"apple-app-site-association/"].lastObject];
    [SDJumpManager jumpUrl:urlStr push:YES parentsController:nil animation:YES];
    return YES;
}

#pragma mark - lazy
- (SDTabBarViewController *)tabVC {
    if (!_tabVC) {
        _tabVC = [[SDTabBarViewController alloc] init];
//        _tabVC.delegate = self;
    }
    return _tabVC;
}


@end
