//
//  SDSystemHeadCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSystemHeadCell : UITableViewCell
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;
@property (nonatomic ,copy) void(^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
