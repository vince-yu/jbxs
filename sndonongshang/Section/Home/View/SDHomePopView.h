//
//  SDHomePopView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCouponsModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 点击去使用时调用的Block */
typedef void(^goReceiveBlock)(void);

@interface SDHomePopView : UIView

+ (instancetype)popViewWithCoupons:(NSArray *)coupons block:(goReceiveBlock)block ;

@end

NS_ASSUME_NONNULL_END
