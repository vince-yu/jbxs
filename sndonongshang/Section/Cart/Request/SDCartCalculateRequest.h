//
//  SDCartCalculateRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCartCalculateModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface SDCartCalculateRequestModel : NSObject
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *targetNum;

@end

@interface SDCartCalculateRequest : SDBSRequest
@property (nonatomic ,copy) NSString *goodsInfo;
//@property (nonatomic ,copy) NSString *amount;
//@property (nonatomic ,copy) NSString *totalNum;
@property (nonatomic ,strong) SDCartCalculateModel *model;
@end

NS_ASSUME_NONNULL_END
