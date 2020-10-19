//
//  SDRegisterSmsCodeViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRegisterSmsCodeViewController.h"
#import "SDRegisterPwdViewController.h"
#import "SDSendLoginSMS.h"
#import "SDLoginSmsRequest.h"

@interface SDRegisterSmsCodeViewController ()


@end

@implementation SDRegisterSmsCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self sendSmsCode];
}

- (void)initSubView {
    [super initSubView];
    
    CGFloat space = 20;
    if (iPhone5 || iPhone4) {
        space = 15;
    }
    CGFloat topMargin = kTopHeight + space;
    NSString *title = [NSString stringWithFormat:@"正在注册\n验证码已发送至+86 %@", [self.phoneNum spaceStrFromPhoneStr]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_font = [UIFont systemFontOfSize:29];
    text.yy_color = [UIColor colorWithRGB:0x282828];
    [text yy_setFont:[UIFont systemFontOfSize:14] range:NSMakeRange(4, 25)];
    text.yy_lineSpacing = 15;
    self.titleLabel.attributedText = text;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
    }];
    
    CGFloat titleSpace = 42;
    if (iPhone5 || iPhone4) {
        titleSpace = 12;
    }
    [self.view addSubview:self.normalTextField];
    [self.normalTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.normalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(titleSpace);
        make.height.mas_equalTo(54);
    }];
    
   
    self.tipsLabel.text = @"60s后重新获取验证码";
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.top.mas_equalTo(self.normalTextField.mas_bottom).mas_equalTo(12);
    }];
    
    CGFloat tipsSpace = 35;
    if (iPhone5 || iPhone4) {
        tipsSpace = 30;
    }
    [self.clickBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(nextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_equalTo(tipsSpace);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - action
- (void)nextStepBtnClick:(UIButton *)clickBtn {
    NSString *code = self.normalTextField.text;
    if ([code isEmpty]) {
        return;
    }
    if (code.length != 6 || ![code isNumText]) {
        [SDToastView HUDWithWarnString:@"请输入收到的6位验证码"];
        return;
    }
    [SDStaticsManager umEvent:klogin_next];
    SDLoginSmsRequest *request = [[SDLoginSmsRequest alloc] init];
    request.mobile = self.phoneNum;
    request.smsCode = code;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDLoginSmsRequest * _Nonnull request) {
        [SDToastView HUDWithString:@"注册成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiLoginSuccess object:[NSNumber numberWithBool:1]];
//        SDRegisterPwdViewController *vc = [[SDRegisterPwdViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
}

- (void)textLengthChange:(UITextField *)textField{
    if (!textField) return;
    NSUInteger maxLength = 6;
    NSString *contentText = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    if (markedTextLength == 0) {
        if (contentText.length > maxLength) {
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
            textField.text = [contentText substringWithRange:rangeRange];
            [self.view endEditing:YES];
            return;
        }
        if (contentText.length == maxLength && [contentText isNumText]) {
            self.clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
        }else {
            self.clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
        }
    }
}

#pragma mark - network
- (void)sendSmsCode{
    SDSendLoginSMS *request = [[SDSendLoginSMS alloc] init];
    request.mobile = self.phoneNum;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self setupTimerWithType:SDSendSMSTypeLogin];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
}


@end
