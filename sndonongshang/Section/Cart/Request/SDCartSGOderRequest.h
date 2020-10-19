//
//  SDCartSGOderRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCartOderModel.h"
#import "SDCartOderRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCartSGOderRequest : SDBSRequest

@property (nonatomic ,strong) SDCartOderRequestModel *requestModel;

@property (nonatomic ,strong) SDCartOderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
