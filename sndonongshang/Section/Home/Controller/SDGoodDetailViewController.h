//
//  SDGoodDetailViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDetailViewController.h"
#import "SDGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodDetailViewController : SDDetailViewController
@property (nonatomic ,strong) SDGoodModel *goodModel;
@end

NS_ASSUME_NONNULL_END
