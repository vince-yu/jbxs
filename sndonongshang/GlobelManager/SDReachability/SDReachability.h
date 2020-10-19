//
//  SDReachability.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/22.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDReachability : NSObject

+ (instancetype)sharedInstance;

/** 网络监测 */
- (void)networkMonitoring;

@property (nonatomic, assign, getter=isHaveNetworking) BOOL haveNetworking;


@end

NS_ASSUME_NONNULL_END
