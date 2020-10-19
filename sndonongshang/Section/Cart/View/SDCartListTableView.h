//
//  SDCartListTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReloadBarViewBlock)(void);

@interface SDCartListTableView : SDBaseTableView
@property (nonatomic ,copy) void(^pushToDetailVCBlock)(id model);
@property (nonatomic ,copy) ReloadBarViewBlock block;
@end

NS_ASSUME_NONNULL_END
