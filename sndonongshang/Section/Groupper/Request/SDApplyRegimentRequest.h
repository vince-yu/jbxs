//
//  SDApplyRegimentRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDApplyRegimentRequest : SDBSRequest

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *community;
@property (nonatomic, copy) NSString *houseNumber;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;

@end

NS_ASSUME_NONNULL_END
