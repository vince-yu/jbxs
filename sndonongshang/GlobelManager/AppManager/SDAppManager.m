//
//  BSAppManager.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SDAppManager.h"


@implementation SDAppManager

+ (instancetype)sharedInstance {
    static SDAppManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self initDataDic];
    }
    return self;
}
- (CGFloat )liuHaiTopHeight{
    return self.isLiuHai ? 44 : 0;
}
- (CGFloat )liuHaiBottomHeight{
    return self.isLiuHai ? 34 : 0;
}
- (BOOL )isLiuHai{
    
    return [SDAppManager isLiuHaiScreen];
}
+ (BOOL)isLiuHaiScreen
{
    if (@available(iOS 11.0, *)) {
        
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        CGFloat liuHaiHeight = 44.0;
        return safeAreaInsets.top == liuHaiHeight || safeAreaInsets.bottom == liuHaiHeight || safeAreaInsets.left == liuHaiHeight || safeAreaInsets.right == liuHaiHeight;
    }else {
        return NO;
    }
}
- (BOOL)status{
    BOOL status = NO;
    status = [[[NSUserDefaults standardUserDefaults] objectForKey:KAppVerify] boolValue];
    if ([SDNetConfig sharedInstance].type != SeverType_Release) {
        status = YES;
    }
    return status;
}
@end
