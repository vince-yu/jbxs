//
//  SDGoodsCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodModel.h"
#import "SDBaseGoodCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDGoodsCell : SDBaseGoodCell
@property (nonatomic ,assign) SDGoodWhereType where;
@end

NS_ASSUME_NONNULL_END
