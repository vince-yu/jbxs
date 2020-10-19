//
//  SDSetRoleRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSetRoleRequest : SDBSRequest

@property (nonatomic, copy) NSString *role;

@end

NS_ASSUME_NONNULL_END
