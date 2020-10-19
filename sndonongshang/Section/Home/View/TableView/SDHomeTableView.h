//
//  SDHomeTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"
#import "SDGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectGoodBlock)(SDGoodModel *goodModel);
typedef void(^GoodsListBlock)(NSString *listId);

@interface SDHomeTableView : SDBaseTableView
@property (nonatomic ,copy) SelectGoodBlock goodDetailBlock;
@property (nonatomic ,copy) GoodsListBlock goodsListBlock;
- (void)refreshAction;
@end

NS_ASSUME_NONNULL_END
