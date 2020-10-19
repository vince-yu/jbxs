//
//  SDSendGoodRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/20.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSendGoodRequest : SDBSRequest
@property (nonatomic, copy) NSString *orderId;
@end

NS_ASSUME_NONNULL_END
