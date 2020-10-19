//
//  SDGoodCouponRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodCouponRequest : SDBSRequest
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,strong) NSArray *couponsArr;
@end

NS_ASSUME_NONNULL_END
