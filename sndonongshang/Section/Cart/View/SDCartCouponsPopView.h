//
//  SDCartCouponsPopView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDCouponsModel;
@class SDCartOderModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^SDConfirmBlock)(SDCouponsModel *couponModel, SDCouponsModel *freightModel);

@interface SDCartCouponsPopView : UIView

+ (instancetype)popViewWithOrderModel:(SDCartOderModel *)orderModel confirmBlock:(SDConfirmBlock)confirmBlock;

@end

NS_ASSUME_NONNULL_END
