//
//  SDGetAddrListReqeust.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGetAddrListReqeust : SDBSRequest

@property (nonatomic, strong) NSArray *addrList;

@end

NS_ASSUME_NONNULL_END
