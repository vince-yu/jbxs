//
//  SDHomeViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"
#import "SDGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDHomeViewController : SDBaseViewController
- (void)pushToGoodDetailVC:(SDGoodModel *)goodModel;
@end

NS_ASSUME_NONNULL_END
