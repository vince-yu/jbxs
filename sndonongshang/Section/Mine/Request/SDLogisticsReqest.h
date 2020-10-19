//
//  SDLogisticsReqest.h
//  sndonongshang
//
//  Created by SNQU on 2019/6/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLogisticsReqest : SDBSRequest
@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,strong) SDLogisticsListModel *listModel;
@end

NS_ASSUME_NONNULL_END
