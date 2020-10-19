//
//  SDMyCouponsRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

@class SDCouponsModel;
NS_ASSUME_NONNULL_BEGIN

@interface SDMyCouponsRequest : SDBSRequest

@property (nonatomic, strong) NSArray *couponsModel;
@property (nonatomic, assign) int limit;
@property (nonatomic, assign) int page;

@end

NS_ASSUME_NONNULL_END
