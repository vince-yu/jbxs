//
//  SDToastView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/19.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDToastView : NSObject

+ (void)showHUDWithView;
+ (void)hideHUDWithView;
+ (void)showHUDWithView:(UIView *)curView;
+ (void)showHUDWithView:(UIView *)curView withTitle:(NSString*)title;
+ (void)hideHUDWithView:(UIView *)curView;
+ (void)HUDWithString:(NSString *)strText;
+ (void)HUDWithErrString:(NSString *)strText;
+ (void)HUDWithSuccessString:(NSString *)strText;
+ (void)HUDWithWarnString:(NSString*)strText;
+ (void)show;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
