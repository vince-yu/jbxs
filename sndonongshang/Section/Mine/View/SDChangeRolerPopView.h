//
//  SDChangeRolerPopView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SDRolerPopConfirmBlock)(NSString *role);
NS_ASSUME_NONNULL_BEGIN

@interface SDChangeRolerPopView : UIView

+ (instancetype)showPopViewWithConfirmBlock:(SDRolerPopConfirmBlock)confirmBlock;

@end

NS_ASSUME_NONNULL_END




