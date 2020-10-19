//
//  BSAppManager.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDAppManager : NSObject
@property (nonatomic ,assign) CGFloat liuHaiTopHeight;
@property (nonatomic ,assign) CGFloat liuHaiBottomHeight;
@property (nonatomic ,assign) BOOL isLiuHai;
@property (nonatomic ,assign) BOOL status;
+ (instancetype)sharedInstance;
+ (BOOL)isLiuHaiScreen;
@end
