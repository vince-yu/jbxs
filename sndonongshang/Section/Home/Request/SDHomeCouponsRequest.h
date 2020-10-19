//
//  SDHomeCouponsRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCouponsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDHomeCouponsRequest : SDBSRequest
@property (nonatomic, copy) NSString *all;
@property (nonatomic, strong) NSArray *couponsArr;
@property (nonatomic, copy) NSString *alertStr;
@end

NS_ASSUME_NONNULL_END
