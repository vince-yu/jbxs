//
//  LocationManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^locatingCompletionBlock)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error);

@interface LocationManager : NSObject

+ (instancetype)locationAndCompletionBlock:(locatingCompletionBlock)block;
- (instancetype)initWithLocationAndCompletionBlock:(locatingCompletionBlock)block;
- (void)locAction;

@end

NS_ASSUME_NONNULL_END
