//
//  SDCartOderRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCartOderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCartOderRequestGoodModel : NSObject
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *type;
@end

@interface SDCartOderRequestModel : NSObject
@property (nonatomic ,assign) SDCartOrderType type;
@property (nonatomic ,copy) NSString *isPrepay;
@property (nonatomic ,copy) NSString *userAddrId;
@property (nonatomic ,copy) NSString *repoId;
@property (nonatomic ,copy) NSString *deliveryTime;
@property (nonatomic ,copy) NSString *prepayHash;
@property (nonatomic ,strong) NSArray *goods;
/** 已经选择的优惠券id */
@property (nonatomic, copy) NSString *voucherId;
/** 已经选择运费优惠券id */
@property (nonatomic, copy) NSString *freighVoucherId;
/**到店自提必填参数**/
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *receiver;
//系统拼团参数
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *groupId;
@property (nonatomic ,copy) NSString *num;
@end


@interface SDCartOderRequest : SDBSRequest
@property (nonatomic ,strong) SDCartOderRequestModel *requestModel;

@property (nonatomic ,strong) SDCartOderModel *orderModel;

/** 订单Id */
@property(nonatomic ,copy) NSString *orderId;

@end

NS_ASSUME_NONNULL_END
