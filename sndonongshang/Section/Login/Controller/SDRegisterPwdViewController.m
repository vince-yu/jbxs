//
//  SDRegisterPwdViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRegisterPwdViewController.h"
#import "SDSetPwdRequest.h"

@interface SDRegisterPwdViewController ()


@end

@implementation SDRegisterPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView {
    [super initSubView];
    
    CGFloat space = 20;
    if (iPhone5 || iPhone4) {
        space = 15;
    }
    CGFloat topMargin = kTopHeight + space;
    NSString *phoneStr = [[[SDUserModel sharedInstance].mobile secretStrFromPhoneStr] spaceStrFromPhoneStr];  
    phoneStr = [NSString stringWithFormat:@"%@**%@", [phoneStr substringToIndex:phoneStr.length - 4],   [phoneStr substringFromIndex:phoneStr.length - 2]];
    NSString *headStr = @"正在注册";
    NSString *title = [NSString stringWithFormat:@"%@\n%@", headStr, phoneStr];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_font = [UIFont systemFontOfSize:29];
    text.yy_color = [UIColor colorWithRGB:0x282828];
    [text yy_setFont:[UIFont systemFontOfSize:20] range:NSMakeRange(4, 14)];
    text.yy_lineSpacing = 41;
    if (iPhone5 || iPhone4) {
        text.yy_lineSpacing = 30;
    }
    self.titleLabel.attributedText = text;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
    }];
    
    CGFloat titleSpace = 14;
    if (iPhone5 || iPhone4) {
        titleSpace = 12;
    }
    self.normalTextField.placeholder = @"请设置8-32位（数字+字母）";
    self.normalTextField.secureTextEntry = YES;
    self.normalTextField.keyboardType = UIKeyboardTypeDefault;
    [self.normalTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.normalTextField];
    [self.normalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(titleSpace);
        make.height.mas_equalTo(39);
    }];
    
    CGFloat tipsSpace = 60;
    if (iPhone5 || iPhone4) {
        tipsSpace = 35;
    }
    [self.clickBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(nextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.normalTextField.mas_bottom).mas_equalTo(tipsSpace);
        make.height.mas_equalTo(50);
    }];
    
    if (self.isSetupPwd) {
        self.bottomView.hidden = YES;
        return;
    }
    CGFloat btnSpace = 34;
    if (iPhone5 || iPhone4) {
        btnSpace = 24;
    }
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipBtn setTitle:@"跳过密码设置" forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(skipSetupPwd) forControlEvents:UIControlEventTouchUpInside];
    skipBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
    [self.view addSubview:skipBtn];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 15));
        make.top.mas_equalTo(self.clickBtn.mas_bottom).mas_equalTo(btnSpace);
        make.centerX.mas_equalTo(self.clickBtn);
    }];
}

#pragma mark - action
- (void)nextStepBtnClick:(UIButton *)clickBtn {
    NSString *password = self.normalTextField.text;
    if ([password isEmpty]) {
        [SDToastView HUDWithWarnString:@"请输入8-32位的数字和字母"];
        return;
    }
    if (![self vaildPassword:password]) {
        [SDToastView HUDWithWarnString:@"请输入8-32位的数字和字母"];
        return;
    }
    SDSetPwdRequest *request = [[SDSetPwdRequest alloc] init];
    request.password = password;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDSetPwdRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"密码设置成功"];
        [SDUserModel sharedInstance].seted_password = @"1";
        [self skipSetupPwd];
    } failure:^(__kindof SDSetPwdRequest * _Nonnull request) {
        [SDToastView HUDWithErrString:@"密码设置失败，请重新设置"];
    }];
}

- (void)skipSetupPwd {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.tabVC.selectedIndex = 0;
//    [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabVC;
}

/** 限制输入框的长度和置灰显示 */
- (void)textLengthChange:(UITextField *)textField{
    if (!textField) return;
    NSUInteger maxLength = 32;
    NSUInteger minLength = 8;
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
        if (contentText.length <= maxLength && contentText.length >= minLength) {
            self.clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
        }else {
            self.clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
        }
    }
}


@end
