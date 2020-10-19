//
//  SDGoodDetailTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodModel.h"
#import "SDGoodDetailModel.h"
#import "SDDetailTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodDetailTableView : SDDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style goodModel:(SDGoodModel *)goodModel;
@end

NS_ASSUME_NONNULL_END
