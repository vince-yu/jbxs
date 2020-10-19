//
//  SDOrderTransInfo.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDOrderTransInfo : SDBSRequest

@property (nonatomic, copy) NSString *addrId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *houseNumber;
/** 地址类型 */
@property (nonatomic, copy) NSString *type;
/** 完整地址描述 */
@property (nonatomic, copy) NSString *addrDetail;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *sketch;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *editTime;

@end

NS_ASSUME_NONNULL_END
