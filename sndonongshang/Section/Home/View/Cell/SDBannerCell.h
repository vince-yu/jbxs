//
//  SDBannerCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBannerCell : UITableViewCell
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
