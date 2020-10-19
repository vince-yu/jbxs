//
//  SDToastView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/19.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDToastView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVProgressHUD.h>

@interface SDHUD : MBProgressHUD

@end

@implementation SDHUD



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

@end

@implementation SDToastView

+ (void)initialize {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}
+ (void)showHUDWithView{
    [self showHUDWithView:[UIApplication sharedApplication].keyWindow withTitle:@""];
}
+ (void)hideHUDWithView{
    [self hideHUDWithView:[UIApplication sharedApplication].keyWindow];
}
+ (void)showHUDWithView:(UIView *)curView {
    [self showHUDWithView:curView withTitle:@""];
}
+ (void)showHUDWithView:(UIView *)curView withTitle:(NSString*)title{
    MBProgressHUD *HUD = [SDHUD showHUDAddedTo:curView animated:YES];
    HUD.bezelView.layer.cornerRadius = 17.5;
    //    HUD.userInteractionEnabled = NO;
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = title;
    HUD.detailsLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
    HUD.detailsLabel.textColor = [UIColor whiteColor];
    HUD.removeFromSuperViewOnHide = YES;
    CGFloat strTextW = [title sizeWithFont:[UIFont fontWithName:kSDPFRegularFont size:15] maxSize:CGSizeMake(SCREEN_WIDTH - 30 * 2 - 17 * 2, 20)].width;
    HUD.minSize = CGSizeMake(strTextW + 17 * 2, 35);
    HUD.margin = 7.f;
    //    HUD.yOffset = 80;
    HUD.bezelView.color = [UIColor colorWithRGB:0x434343];
    [HUD hideAnimated:YES afterDelay:2.0f];
}

+ (void)hideHUDWithView:(UIView *)curView {
    [SDHUD hideHUDForView:curView animated:YES];
}

+ (void)HUDWithString:(NSString *)strText {
    [SDHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
    MBProgressHUD *HUD = [SDHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    HUD.bezelView.layer.cornerRadius = 17.5;
//    HUD.userInteractionEnabled = NO;
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = strText;
    HUD.detailsLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
    HUD.detailsLabel.textColor = [UIColor whiteColor];
    HUD.removeFromSuperViewOnHide = YES;
    CGFloat strTextW = [strText sizeWithFont:[UIFont fontWithName:kSDPFRegularFont size:15] maxSize:CGSizeMake(SCREEN_WIDTH - 30 * 2 - 17 * 2, 20)].width;
    HUD.minSize = CGSizeMake(strTextW + 17 * 2, 35);
    HUD.margin = 7.f;
//    HUD.yOffset = 80;
    HUD.bezelView.color = [UIColor colorWithRGB:0x434343];
    [HUD hideAnimated:YES afterDelay:1.5f];
}

+ (void)HUDWithErrString:(NSString *)strText {
    [SDToastView HUDWithString:strText];
}

+ (void)HUDWithSuccessString:(NSString *)strText {
   [SDToastView HUDWithString:strText];
}

+ (void)HUDWithWarnString:(NSString*)strText {
    [SDToastView HUDWithString:strText];
}

+ (void)show {
//    [SDToastView dismiss];
    if ([SDToastView isExistHUD]) {
        return;
    }
    MBProgressHUD *HUD = [SDHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
}
+ (BOOL )isExistHUD{
    UIView *widow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in widow.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            if (hud.mode == MBProgressHUDModeIndeterminate) {
                return YES;
            }
        }
    }
    return NO;
}
+ (void)dismiss {
    UIView *widow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in widow.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            if (hud.mode == MBProgressHUDModeIndeterminate) {
                [hud hideAnimated:NO];
            }
        }
    }
//    [SDHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

@end
