//
//  SDUpdateAddrRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDUpdateAddrRequest : SDBSRequest

@property (nonatomic, strong) SDAddressModel *addressModel;

@end

NS_ASSUME_NONNULL_END
