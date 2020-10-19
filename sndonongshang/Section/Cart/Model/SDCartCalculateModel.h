//
//  SDCartCalculateModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/4/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCartCalculateMoreModel : NSObject
@property (nonatomic ,copy) NSString *goodsId;
@property (nonatomic ,copy) NSString *beyond;
@property (nonatomic ,copy) NSString *limiting;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSString *priceActive;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic, copy) NSString *limitPerUser;
/** 用户已购份数 */
@property (nonatomic ,copy) NSString *userHadBuy;
/** 剩余优惠份数 */
@property (nonatomic ,copy) NSString *ableCheap;
@property (nonatomic ,assign) SDCalculateType type;

/* 额外属性*/
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *tips;
@end

@interface SDCartCalculateTipsModel : NSObject
@property (nonatomic ,copy) NSString *deficiency;
@property (nonatomic ,copy) NSString *postage;
@property (nonatomic ,copy) NSString *reach;
@property (nonatomic ,copy) NSString *deliveryPrice;
@property (nonatomic ,copy) NSString *shippingPrice;
@end


@interface SDCartCalculateModel : NSObject
@property (nonatomic ,assign) SDValuationType type;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,copy) NSString *totalNum;
@property (nonatomic ,strong) SDCartCalculateTipsModel *tips;
@property (nonatomic ,copy) NSArray *more;
@property (nonatomic ,copy) NSString *alert;
@end

NS_ASSUME_NONNULL_END
