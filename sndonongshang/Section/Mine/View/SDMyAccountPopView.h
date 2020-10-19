//
//  SDMyAccountPopView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MyAccountPopViewTypeSex, // 性别
    MyAccountPopViewTypeDate, // 出生日期
} MyAccountPopViewType;

typedef void(^ConfirmBlock)(NSString *chooseValue);

NS_ASSUME_NONNULL_BEGIN

@interface SDMyAccountPopView : UIView

@property (nonatomic, assign) int selectedSex;
@property (nonatomic, strong) NSDate *selectedDate;

+ (instancetype)showPopViewWithType:(MyAccountPopViewType)type confirmBlock:(ConfirmBlock)block;

@end

NS_ASSUME_NONNULL_END
