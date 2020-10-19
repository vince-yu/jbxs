//
//  UIViewController+UMeng.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/25.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UIViewController+UMeng.h"
#import <objc/runtime.h>
#import "SDGrouperOrderMgrViewController.h"
#import "SDPayResultViewController.h"

@implementation UIViewController (UMeng)

+ (void)load {
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method new_viewWillAppear = class_getInstanceMethod(self, @selector(new_viewWillAppear:));
    method_exchangeImplementations(viewWillAppear, new_viewWillAppear);
    
    Method viewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method new_viewWillDisappear = class_getInstanceMethod(self, @selector(new_viewWillDisappear:));
    method_exchangeImplementations(viewWillDisappear, new_viewWillDisappear);
}

- (void)new_viewWillAppear:(BOOL)animated{
    if ([self isKindOfClass:[UIViewController class]]) {
        NSString *type = @"";
        if ([self isKindOfClass:[SDGrouperOrderMgrViewController class]]) {
            SDGrouperOrderMgrViewController *omg = (SDGrouperOrderMgrViewController *)self;
            id roler = [omg valueForKey:@"_rolerType"];
            if ([roler isKindOfClass:[NSNumber class]]) {
                type = [NSString stringWithFormat:@"%d",[roler intValue]];
            }
        }else if ([self isKindOfClass:[SDPayResultViewController class]]) {
            SDPayResultViewController *omg = (SDPayResultViewController *)self;
            id roler = [omg valueForKey:@"_type"];
            if ([roler isKindOfClass:[NSNumber class]]) {
                type = [NSString stringWithFormat:@"%d",[roler intValue]];
            }
        }
        [SDStaticsManager umBeginPage:NSStringFromClass(self.class) type:type];
    }
    [self new_viewWillAppear:animated];
}

- (void)new_viewWillDisappear:(BOOL)animated{
    if ([self isKindOfClass:[UIViewController class]]) {
        NSString *type = @"";
        if ([self isKindOfClass:[SDGrouperOrderMgrViewController class]]) {
            SDGrouperOrderMgrViewController *omg = (SDGrouperOrderMgrViewController *)self;
            id roler = [omg valueForKey:@"_rolerType"];
            if ([roler isKindOfClass:[NSNumber class]]) {
                type = [NSString stringWithFormat:@"%d",[roler intValue]];
            }
        }else if ([self isKindOfClass:[SDPayResultViewController class]]) {
            SDPayResultViewController *omg = (SDPayResultViewController *)self;
            id roler = [omg valueForKey:@"_type"];
            if ([roler isKindOfClass:[NSNumber class]]) {
                type = [NSString stringWithFormat:@"%d",[roler intValue]];
            }
        }
        [SDStaticsManager umEndPage:NSStringFromClass(self.class) type:type];
    }
    [self new_viewWillDisappear:animated];
}

@end
