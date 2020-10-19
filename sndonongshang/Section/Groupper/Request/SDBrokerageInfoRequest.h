//
//  SDBrokerageInfoRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDBrokerageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBrokerageInfoRequest : SDBSRequest

@property (nonatomic, strong) SDBrokerageModel *model;

@end

NS_ASSUME_NONNULL_END
