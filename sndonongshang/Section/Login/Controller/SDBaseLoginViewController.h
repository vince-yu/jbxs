//
//  SDBaseLoginViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"
#import "SDLoginBottomView.h"
#import "SDPhoneTextFieldView.h"
#import "SDLoginTextField.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SDSendSMSTypeLogin, // -发送登录/注册短信验证码
    SDSendSMSTypeBind, // 发送绑定手机验证码
    SDSendSMSTypeResetPwd, // 找回密码 发送手机验证码
} SDSendSMSType;

@interface SDBaseLoginViewController : SDBaseViewController

@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) YYLabel *tipsLabel;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, strong) SDPhoneTextFieldView *phoneTextFieldView;
@property (nonatomic, strong) SDLoginTextField *normalTextField;
@property (nonatomic, strong) SDLoginBottomView *bottomView;
@property (nonatomic, strong) UIView *gradientView;

@property (nonatomic, copy) NSString *phoneNum;
/** 定时器完成时间 */
@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, weak) NSTimer *timer;

- (void)initSubView;
/** 创建定时器 */
- (void)setupTimerWithType:(SDSendSMSType)sendSmsType;
/** 销毁定时器 */
- (void)invalidateTimer;
/** 验证是否是有效的密码 */
- (BOOL)vaildPassword:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
