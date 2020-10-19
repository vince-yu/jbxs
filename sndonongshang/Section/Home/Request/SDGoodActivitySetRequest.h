//
//  SDGoodActivitySetRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodActivitySetRequest : SDBSRequest
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,assign) BOOL goodsremind;//是否是到货提醒
@end

NS_ASSUME_NONNULL_END
