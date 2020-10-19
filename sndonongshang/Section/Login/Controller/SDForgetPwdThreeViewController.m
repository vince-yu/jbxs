//
//  SDForgetPwdThreeViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDForgetPwdThreeViewController.h"
#import "SDResetPwdRequest.h"
#import "SDSetPwdRequest.h"

@interface SDForgetPwdThreeViewController ()

@end

@implementation SDForgetPwdThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView {
    [super initSubView];
    self.bottomView.hidden = YES;
    
    CGFloat space = 20;
    if (iPhone5 || iPhone4) {
        space = 20;
    }
    NSString *phoneNum = self.phoneNum;
    if ([[SDUserModel sharedInstance] isLogin] && self.isChangePwd) {
        phoneNum = [SDUserModel sharedInstance].mobile;
        self.bottomView.hidden = YES;
        self.navigationItem.title = @"修改密码";
    }
    CGFloat topMargin = kTopHeight + space;
    NSString *phoneStr = [phoneNum spaceStrFromPhoneStr];
    NSString *title = [NSString stringWithFormat:@"请为您的账号 %@ 设置一个新密码", phoneStr];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_font = [UIFont systemFontOfSize:20];
    text.yy_color = [UIColor colorWithRGB:0x282828];
    text.yy_lineSpacing = 5;
    self.titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - SDMargin * 2;//设置最大宽度
    self.titleLabel.attributedText = text;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
    }];
    
    CGFloat titleSpace = 82;
    if (iPhone5 || iPhone4) {
        titleSpace = 47;
    }
    self.normalTextField.placeholder = @"请设置8-32位（数字+字母）";
    self.normalTextField.keyboardType = UIKeyboardTypeDefault;
    self.normalTextField.secureTextEntry = YES;
    [self.normalTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.normalTextField];
    [self.normalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(titleSpace);
        make.height.mas_equalTo(54);
    }];
    
    CGFloat tipsSpace = 44;
    if (iPhone5 || iPhone4) {
        tipsSpace = 34;
    }
    [self.clickBtn setTitle:@"保存新密码" forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(nextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.normalTextField.mas_bottom).mas_equalTo(44);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - action
- (void)nextStepBtnClick:(UIButton *)clickBtn {
    NSString *password = self.normalTextField.text;
    if ([password isEmpty]) {
        return;
    }
    if (![self vaildPassword:password]) {
        [SDToastView HUDWithErrString:@"请输入8-32位的数字和字母"];
        return;
    }
    if (self.isChangePwd) {
        SDSetPwdRequest *request = [[SDSetPwdRequest alloc] init];
        request.password = password;
        [SDToastView show];
        [request startWithCompletionBlockWithSuccess:^(__kindof SDSetPwdRequest * _Nonnull request) {
            [SDToastView HUDWithSuccessString:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(__kindof SDSetPwdRequest * _Nonnull request) {
            [SDToastView HUDWithErrString:@"修改密码失败，请重新修改"];
        }];
        return;
    }
    
    SDResetPwdRequest *request = [[SDResetPwdRequest alloc] init];
    request.mobile = self.phoneNum;
    request.smsCode = self.smsCode;
    request.password = password;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"密码设置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.tabVC.selectedIndex = 0;
//            [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabVC;
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithErrString:@"密码设置失败，请重新设置"];
    }];
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
