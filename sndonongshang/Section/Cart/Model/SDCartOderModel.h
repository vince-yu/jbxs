//
//  SDCartOderModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCartOderFailedModel : NSObject
@property (nonatomic ,copy) NSString *localCode;
@property (nonatomic ,copy) NSString *subCode;
@property (nonatomic ,copy) NSString *deliveryPrice;
@property (nonatomic ,copy) NSArray *remove;
@end

@interface SDCartOderModel : NSObject
@property (nonatomic ,copy) NSArray *alert;
@property (nonatomic ,copy) NSString *couponAlert;
@property (nonatomic ,copy) NSString *prepayHash;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,copy) NSString *totalPrice;
@property (nonatomic ,copy) NSString *transPrice;
@property (nonatomic ,copy) NSString *pickTime;
@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,strong) NSArray *goodsInfo;
@property (nonatomic ,strong) NSArray *deliveryTime;
@property (nonatomic ,copy) NSString *reducePrice;
@property (nonatomic, strong) NSArray *voucher;
@property (nonatomic, copy) NSString *tips;
//自提信息
@property (nonatomic ,strong) NSString *receiver;
@property (nonatomic ,strong) NSString *lastReceiverMobile;
@end

NS_ASSUME_NONNULL_END
