//
//  SDJumpManager.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDJumpManager.h"
#import "SDGoodDetailViewController.h"
#import "SDWebViewController.h"
#import "SDGoodsListViewController.h"
#import "SDGoodModel.h"
#import "SDHomeDataManager.h"
#import "SDOrderDetailViewController.h"
#import "SDOrderContentViewController.h"

/*
 Banner接口url跳转协议：
 一、跳转网页
 url以http://开头
 二、本地跳转
 数据格式
 jsonStr={"page":页面名称,"data":{打开页面的一些必要参数}}
 
 页面名称
 1．商品详情页面：
 jsonStr={"page":"GoodsDetailPage","data":{"goods_id":商品id,"type":商品类型,"group_id":团购活动id}}
 
 2.购物车页面：
 jsonStr={"page":"ShoppingCartPage"}
 
 3.订单列表
 jsonStr={"page":"OrderPage"}
 
 4.订单详情:
 jsonStr={"page":"OrderDetailPage","data":{"orderId":订单id}}
 
 5.WebView页面
 jsonStr={"page":"WebViewPage","data":{"url":h5链接}}
 */

static NSString *const SDJumpWebHttpHeader = @"http://";
static NSString *const SDJumpWebHttpsHeader = @"https://";
static NSString *const SDJumpGoodDetailHeader = @"sndo://good/list?type=";
static NSString *const SDJumpGoodListHeader = @"sndo://good/detail?id=";
static NSString *const SDJumpLocationHeader = @"agriculture://app/appPage?param=";

@implementation SDJumpManager
+ (instancetype)sharedInstance {
    static SDJumpManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
+ (void)jumpUrl:(NSString *)url push:(BOOL )needPush parentsController:(UIViewController *)controller animation:(BOOL )needAnimation{
    UIViewController *targetVC = nil;
    if (!url.length) {
        return;
    }
    url = [url urldecode];
    CYLTabBarController *tab = (CYLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    if ([url hasPrefix:SDJumpWebHttpHeader] || [url hasPrefix:SDJumpWebHttpsHeader]) {
        NSString *version = [UIApplication sharedApplication].appVersion;
        NSString *argumentsStr = [NSString stringWithFormat:@"?appVersion=%@&Version=1", version];
        NSString *urlStr = [url stringByAppendingString:argumentsStr];
        SDWebViewController *webVC = [[SDWebViewController alloc] init];
        [webVC ba_web_loadURL:[NSURL URLWithString:urlStr]];
        targetVC = webVC;
    }else if ([url hasPrefix:SDJumpGoodListHeader]){
        
        SDGoodDetailViewController *detailVC = [[SDGoodDetailViewController alloc] init];
        targetVC = detailVC;
    }else if ([url hasPrefix:SDJumpGoodDetailHeader]){
        SDGoodsListViewController *listVC = [[SDGoodsListViewController alloc] init];
        targetVC = listVC;
    }else if ([url hasPrefix:SDJumpLocationHeader]){
        NSString *jsonStr = [url stringByReplacingOccurrencesOfString:SDJumpLocationHeader withString:@""];
        NSDictionary *dic = [jsonStr mj_JSONObject];
        NSString *page = [dic objectForKey:@"page"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([page isEqualToString:@"GoodsDetailPage"]) {
            SDGoodModel *goodModel = [[SDGoodModel alloc] init];
            goodModel.goodId = [dataDic objectForKey:@"goods_id"];
            goodModel.type = [dataDic objectForKey:@"type"];
            goodModel.groupId = [dataDic objectForKey:@"group_id"];
            if (goodModel.goodId.length && goodModel.type.length) {
                [SDHomeDataManager recommedGoodToGoodDetail:goodModel];
            }
        }else if ([page isEqualToString:@"ShoppingCartPage"]){
            tab.selectedIndex = 1;
            [nav popToRootViewControllerAnimated:NO];
        }else if ([page isEqualToString:@"OrderPage"]){
            SDOrderContentViewController *vc = [[SDOrderContentViewController alloc] init];
            targetVC = vc;
        }else if ([page isEqualToString:@"OrderDetailPage"]){
            SDOrderDetailViewController *vc = [[SDOrderDetailViewController alloc] init];
            vc.orderId = dataDic[@"orderId"];
            targetVC = vc;
        }else if ([page isEqualToString:@"WebViewPage"]){
            NSString *urlStr = dataDic[@"url"];
            if (!urlStr || [urlStr isEmpty]) {
                return;
            }
            if ([urlStr hasPrefix:SDJumpWebHttpHeader] || [urlStr hasPrefix:SDJumpWebHttpsHeader]) {
                NSString *version = [UIApplication sharedApplication].appVersion;
                NSString *argumentsStr = [NSString stringWithFormat:@"?appVersion=%@&Version=1", version];
                urlStr = [urlStr stringByAppendingString:argumentsStr];
                SDWebViewController *webVC = [[SDWebViewController alloc] init];
                [webVC ba_web_loadURL:[NSURL URLWithString:urlStr]];
                targetVC = webVC;
            }
        }else{
            
        }
    }else {
        SNDOLOG(@"error url is .....%@",url);
    }
    if (needPush) {
        if (!controller) {
            [nav pushViewController:targetVC animated:needAnimation];
            return;
        }
        UINavigationController *nav = controller.navigationController;
        if (!nav) {
            nav = [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
        }
        [nav pushViewController:targetVC animated:needAnimation];
    }else{
        if (!controller) {
            controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        }
        [controller presentViewController:targetVC animated:needAnimation completion:nil];
    }
    
}

@end
