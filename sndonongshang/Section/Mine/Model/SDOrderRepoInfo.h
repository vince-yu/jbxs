//
//  SDOrderRepoInfo.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDOrderRepoInfo : SDBSRequest

/** 前置仓Id */
@property (nonatomic, copy) NSString *repoId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *realname;
/** 区县 */
@property (nonatomic, copy) NSString *county;
//类型：String  必有字段  备注：完整地址描述 如果是团长订单，则是团长地址
@property (nonatomic, copy) NSString *addrDetail;

@end

NS_ASSUME_NONNULL_END
