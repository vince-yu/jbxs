//
//  SDPasswordLoginViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPasswordLoginViewController.h"
#import "SDLoginTextField.h"
#import "SDForgetPwdTwoViewController.h"
#import "SDLoginPopView.h"
#import "SDSmsCodeViewController.h"
#import "SDLoginPwdRequest.h"

@interface SDPasswordLoginViewController ()

@property (nonatomic, strong) UIButton *smsCodeLoginBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, weak) SDLoginPopView *popView;

@end

@implementation SDPasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView {
    [super initSubView];
    
    CGFloat space = 20;
    if (iPhone5 || iPhone4) {
        space = 20;
    }
    CGFloat topMargin = kTopHeight + space;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"输入账户密码"];
    text.yy_font = [UIFont systemFontOfSize:29];
    text.yy_color = [UIColor colorWithRGB:0x282828];
    text.yy_lineSpacing = 15;
    self.titleLabel.attributedText = text;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
    }];
    
    CGFloat titleSpace = 50;
    if (iPhone5 || iPhone4) {
        titleSpace = 25;
    }
    self.normalTextField.placeholder = @"请输入账户密码";
    self.normalTextField.keyboardType = UIKeyboardTypeDefault;
    self.normalTextField.secureTextEntry = YES;
    if (@available(iOS 11.0, *)) {
        self.normalTextField.textContentType = UITextContentTypePassword;
    }
    [self.normalTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.normalTextField];
    [self.normalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(titleSpace);
        make.height.mas_equalTo(54);
    }];

    CGFloat tipsSpace = 35;
    if (iPhone5 || iPhone4) {
        tipsSpace = 30;
    }
    [self.clickBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.normalTextField.mas_bottom).mas_equalTo(tipsSpace);
        make.height.mas_equalTo(50);
    }];
    
    CGFloat btnSpace = 30;
    if (iPhone5 || iPhone4) {
        btnSpace = 20;
    }
    CGFloat btnMargin = SDMargin + 10;
    [self.view addSubview:self.smsCodeLoginBtn];
    [self.smsCodeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnMargin);
        make.top.mas_equalTo(self.clickBtn.mas_bottom).mas_equalTo(btnSpace);
    }];
    
    [self.view addSubview:self.forgetPwdBtn];
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-btnMargin);
        make.centerY.mas_equalTo(self.smsCodeLoginBtn);
    }];
    
}

#pragma mark - action
- (void)forgetBtnClick:(UIButton *)clickBtn {
    SDForgetPwdTwoViewController *vc = [[SDForgetPwdTwoViewController alloc] init];
    vc.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginBtnClick:(UIButton *)clickBtn {
    NSString *password = self.normalTextField.text;
    if ([password isEmpty]) {
        return;
    }
    if (![self vaildPassword:password]) {
        [SDToastView HUDWithWarnString:@"请输入8-32位的数字和字母"];
        return;
    }
    SDLoginPwdRequest *request = [[SDLoginPwdRequest alloc] init];
    request.mobile = self.phoneNum;
    request.password = password;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDLoginPwdRequest * _Nonnull request) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiLoginSuccess object:nil];
        [self.view endEditing:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.tabVC.selectedIndex = 0;
//        [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabVC;
    } failure:^(__kindof SDLoginPwdRequest * _Nonnull request) {

    }];
   
}

- (void)smsCodeLoginBtnClick {
    SDSmsCodeViewController *vc = [[SDSmsCodeViewController alloc] init];
    vc.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:vc animated:YES];
}

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

#pragma mark - getter
- (UIButton *)smsCodeLoginBtn {
    if (!_smsCodeLoginBtn) {
        _smsCodeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _smsCodeLoginBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_smsCodeLoginBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_smsCodeLoginBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
        [_smsCodeLoginBtn addTarget:self action:@selector(smsCodeLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsCodeLoginBtn;
}

- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}
@end
