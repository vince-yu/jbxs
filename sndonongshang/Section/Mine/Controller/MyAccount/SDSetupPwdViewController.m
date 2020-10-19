//
//  SDSetupPwdViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/22.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSetupPwdViewController.h"
#import "SDLoginTextField.h"
#import "SDSetPwdRequest.h"

@interface SDSetupPwdViewController ()

@property (nonatomic, strong) SDLoginTextField *pwdTextField;
@property (nonatomic, strong) UIButton *setupPwdBtn;


@end

@implementation SDSetupPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
}

- (void)initNav {
    self.navigationItem.title = @"设置密码";
}

- (void)initSubView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
    }];
    
    [self.pwdTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.pwdTextField];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.height.mas_equalTo(39);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(70);
    }];
    
    [self.view addSubview:self.setupPwdBtn];
    [self.setupPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.pwdTextField.mas_bottom).mas_equalTo(93);
        make.height.mas_equalTo(50);
    }];
}

- (BOOL)vaildPassword:(NSString *)password {
    NSString *passwordRegex =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,32}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    NSLog(@"passwordTest is %@",passwordTest);
    return [passwordTest evaluateWithObject:password];
}

#pragma mark - action
- (void)nextStepBtnClick:(UIButton *)clickBtn {
    NSString *password = self.pwdTextField.text;
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
        [SDToastView HUDWithSuccessString:@"设置密码成功"];
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof SDSetPwdRequest * _Nonnull request) {
        [SDToastView HUDWithErrString:@"设置密码失败，请重新设置"];
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
            self.setupPwdBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
        }else {
            self.setupPwdBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
        }
    }
}


- (SDLoginTextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[SDLoginTextField alloc] init];
        _pwdTextField.placeholder = @"请设置8-32位（数字+字母）";
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _pwdTextField;
}

- (UIButton *)setupPwdBtn {
    if (!_setupPwdBtn) {
        _setupPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setupPwdBtn setTitle:@"保存新密码" forState:UIControlStateNormal];
        _setupPwdBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _setupPwdBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
        [_setupPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _setupPwdBtn.layer.cornerRadius = 25;
        _setupPwdBtn.layer.masksToBounds = YES;
        [_setupPwdBtn addTarget:self action:@selector(nextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setupPwdBtn;
}

@end
