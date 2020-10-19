//
//  SDGoodHeadCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodHeadCell : UITableViewCell
@property (nonatomic ,assign) SDGoodDetailType type;
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
