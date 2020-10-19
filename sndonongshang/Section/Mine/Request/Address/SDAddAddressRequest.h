//
//  SDAddAddressRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDAddAddressRequest : SDBSRequest

@property (nonatomic, strong) SDAddressModel *addressModel;
@property (nonatomic, copy) NSString *addrId;
@property (nonatomic, copy) NSString *fullAddress;
@end

NS_ASSUME_NONNULL_END
