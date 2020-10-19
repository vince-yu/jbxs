//
//  SDGoodDetailRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodDetailRequest : SDBSRequest
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *groupId;
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
