//
//  SDCartOrderListView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"

@class SDCartOderModel;
typedef void(^UpdateOrderBarBlock)(NSString *pric,NSString *reducePric);

NS_ASSUME_NONNULL_BEGIN



@interface SDCartOrderTableView : SDBaseTableView
@property (nonatomic ,strong) NSArray *goodsArray;
@property (nonatomic ,copy) UpdateOrderBarBlock updateBlock;
@property (nonatomic ,copy) void (^failedRefreshBlock)(id model);
@property (nonatomic ,strong) SDCartOderModel *orderModel;
- (void)refreshActionWithNoFailedFreshBlock;
- (void)firtLoadAction;
@end

NS_ASSUME_NONNULL_END
