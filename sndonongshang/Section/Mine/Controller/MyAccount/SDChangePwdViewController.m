
//
//  SDChangePwdViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChangePwdViewController.h"
#import "SDLoginTextField.h"
#import "SDUptPasswordRequest.h"

@interface SDChangePwdViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *oldPwdLabel;
@property (nonatomic, strong) UILabel *newPwdLabel;
@property (nonatomic, strong) UITextField *oldPwdTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SDChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
}

- (void)initNav {
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
}

- (void)initSubView {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.oldPwdLabel];
    [self.contentView addSubview:self.oldPwdTextField];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.newPwdLabel];
    [self.contentView addSubview:self.pwdTextField];
    [self.view addSubview:self.confirmBtn];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight + 10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(110.5);
    }];
    [self.oldPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 55));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    [self.oldPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oldPwdLabel.mas_right).mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(55);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.oldPwdLabel.mas_bottom);
    }];
    
    [self.newPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.oldPwdLabel);
        make.left.mas_equalTo(self.oldPwdLabel);
        make.top.mas_equalTo(self.lineView.mas_bottom);
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oldPwdTextField);
        make.top.mas_equalTo(self.newPwdLabel);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(55);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(20);
    }];
}

- (BOOL)vaildPassword:(NSString *)password {
    NSString *passwordRegex =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,32}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    NSLog(@"passwordTest is %@",passwordTest);
    return [passwordTest evaluateWithObject:password];
}

#pragma mark - action
- (void)confirmBtnClick {
    NSString *oldPwd = self.oldPwdTextField.text;
    NSString *pwd = self.pwdTextField.text;

    if ([oldPwd isEmpty] || [pwd isEmpty]) {
        return;
    }
    if (![self vaildPassword:oldPwd] || ![self vaildPassword:pwd]) {
        [SDToastView HUDWithErrString:@"请输入8-32位的数字和字母"];
        return;
    }
    
    if ([oldPwd isEqualToString:pwd]) {
        [SDToastView HUDWithSuccessString:@"新密码和当前登录密码一样，请重新设置一个新密码"];
        return;
    }
    
    SDUptPasswordRequest *request = [[SDUptPasswordRequest alloc] init];
    request.oldPassword = oldPwd;
    request.password = pwd;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"密码修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - UITextFieldDelegate
/** 限制输入框的长度和置灰显示 */
- (void)textLengthChange:(UITextField *)textField{
    if (!textField) return;
    NSUInteger maxLength = 32;
    NSUInteger minLength = 8;
    NSString *contentText = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextField *otherTextField = textField == self.oldPwdTextField ? self.pwdTextField : self.oldPwdTextField ;
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    if (markedTextLength == 0) {
        if (contentText.length > maxLength) {
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
            textField.text = [contentText substringWithRange:rangeRange];
            [self.view endEditing:YES];
            return;
        }
        if (contentText.length <= maxLength && contentText.length >= minLength && otherTextField.text.length <= maxLength && otherTextField.text.length >= minLength) {
            self.confirmBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
            self.confirmBtn.userInteractionEnabled = YES;
        }else {
            self.confirmBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
            self.confirmBtn.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)oldPwdLabel {
    if (!_oldPwdLabel) {
        _oldPwdLabel = [[UILabel alloc] init];
        _oldPwdLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        _oldPwdLabel.textColor = [UIColor colorWithRGB:0x31302E];
        _oldPwdLabel.text = @"当前登录密码";
    }
    return _oldPwdLabel;
}

- (UILabel *)newPwdLabel {
    if (!_newPwdLabel) {
        _newPwdLabel = [[UILabel alloc] init];
        _newPwdLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        _newPwdLabel.textColor = [UIColor colorWithRGB:0x31302E];
        _newPwdLabel.text = @"新密码";
    }
    return _newPwdLabel;
}

- (UITextField *)oldPwdTextField {
    if (!_oldPwdTextField) {
        _oldPwdTextField = [[UITextField alloc] init];
        _oldPwdTextField.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _oldPwdTextField.textColor = [UIColor colorWithRGB:0x31302E];
        _oldPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPwdTextField.placeholder = @"请输入旧密码";
        _oldPwdTextField.secureTextEntry = YES;
        [_oldPwdTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldPwdTextField;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _pwdTextField.textColor = [UIColor colorWithRGB:0x31302E];
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextField.placeholder = @"8-32位(数字+英文)";
        _pwdTextField.secureTextEntry = YES;
        [_pwdTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdTextField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _lineView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 22.5;
        _confirmBtn.userInteractionEnabled = NO;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


@end
