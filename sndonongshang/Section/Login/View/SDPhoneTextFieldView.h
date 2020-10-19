//
//  SDPhoneTextFieldView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDPhoneTextFieldView : UIView

@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UITextField *phoneTextField;
@property (nonatomic, weak) UIView *lineView;


@end

NS_ASSUME_NONNULL_END
