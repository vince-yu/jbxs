//
//  SDGoodsListTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodsListTableView : SDBaseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style tabId:(NSString *)tabId;
@property (nonatomic ,copy) void(^goodDetailBlock)(id model);
@end

NS_ASSUME_NONNULL_END
