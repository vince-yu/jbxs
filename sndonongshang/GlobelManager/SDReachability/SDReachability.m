//
//  SDReachability.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/22.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDReachability.h"
#import "AFNetworking.h"

@implementation SDReachability

+ (instancetype)sharedInstance{
    static SDReachability *instance = nil;
    static dispatch_once_t disonce;
    dispatch_once(&disonce, ^{
        instance = [[self alloc] init];
        instance.haveNetworking = YES;
    });
    return instance;
}

// 网络监测
- (void)networkMonitoring
{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //2.开启监听
    [manger startMonitoring];
    //3.监听网络状态的改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"此时没有网络");
                self.haveNetworking = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动网络");
                self.haveNetworking = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                self.haveNetworking = YES;
                break;
            default:
                break;
        }
    }];
}


@end
