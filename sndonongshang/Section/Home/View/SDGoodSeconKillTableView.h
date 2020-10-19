//
//  SDGoodSeconKillTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDDetailTableView.h"
#import "SDBaseTableView.h"
#import "SDGoodModel.h"
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodSeconKillTableView : SDDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style goodModel:(SDGoodModel *)goodModel;
@end

NS_ASSUME_NONNULL_END
