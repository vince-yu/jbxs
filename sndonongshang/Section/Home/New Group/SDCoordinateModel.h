//
//  SDCoordinateModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCoordinateModel : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/** 纬度 */
@property (nonatomic, assign, readonly) CLLocationDegrees latitude;
/** 经度 */
@property (nonatomic, assign, readonly) CLLocationDegrees longitude;

@end

NS_ASSUME_NONNULL_END
