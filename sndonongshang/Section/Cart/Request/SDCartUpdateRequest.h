//
//  SDCartUpdateRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCartUpdateModel : NSObject
@property (nonatomic ,copy) NSString *goodsId;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *targetNum;
@property (nonatomic ,copy) NSString *type;
@end

@interface SDCartUpdateRequest : SDBSRequest
@property (nonatomic ,copy) NSString *goodsInfo;
@end

NS_ASSUME_NONNULL_END
