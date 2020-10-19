//
//  SDOrderDetailRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDOrderDetailRequest : SDBSRequest

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, strong) SDOrderDetailModel *orderModel;

@end

NS_ASSUME_NONNULL_END
