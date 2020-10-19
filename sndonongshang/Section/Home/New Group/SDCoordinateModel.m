//
//  SDCoordinateModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCoordinateModel.h"

@implementation SDCoordinateModel

+ (instancetype)sharedInstance{
    static SDCoordinateModel *instance = nil;
    static dispatch_once_t disonce;
    dispatch_once(&disonce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
    _latitude = coordinate.latitude;
    _longitude = coordinate.longitude;
}

@end
