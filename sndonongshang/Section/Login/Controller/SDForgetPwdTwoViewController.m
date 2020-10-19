//
//  SDForgetPwdTwoViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDForgetPwdTwoViewController.h"
#import "SDForgetPwdThreeViewController.h"
#import "SDSendResetPwdCodeRequest.h"
#import "SDResetPwdRequest.h"

@interface SDForgetPwdTwoViewController ()

@property (nonatomic, strong) UILabel *areaNumLabel;
@property (nonatomic, strong) UIImageView *arrowIv;
@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation SDForgetPwdTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self sendSmsCode];
}

- (void)initSubView {
    [super initSubView];
    self.bottomView.hidden = YES;

    CGFloat space = 20;
    if (iPhone5 || iPhone4) {
        space = 20;
    }
    CGFloat topMargin = kTopHeight + space;
    self.titleLabel.text = @"验证手机";
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
    }];
    
    CGFloat phoneSpace = 58;
    if (iPhone5 || iPhone4) {
        phoneSpace = 38;
    }
    [self.view addSubview:self.areaNumLabel];
    [self.areaNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(phoneSpace);
    }];
    
    [self.view addSubview:self.arrowIv];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 10));
        make.centerY.mas_equalTo(self.areaNumLabel);
        make.left.mas_equalTo(self.areaNumLabel.mas_right).mas_equalTo(13);
    }];
    
    NSString *phoneStr = [[self.phoneNum secretStrFromPhoneStr] spaceStrFromPhoneStr];
    phoneStr = [NSString stringWithFormat:@"%@**%@", [phoneStr substringToIndex:phoneStr.length - 4],   [phoneStr substringFromIndex:phoneStr.length - 2]];
    self.phoneLabel.text = phoneStr;
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.centerY.mas_equalTo(self.areaNumLabel);
    }];
    
//    NSString *title = [NSString stringWithFormat:@"验证手机\n+86 > %@", phoneStr];
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
//    text.yy_font = [UIFont systemFontOfSize:29];
//    text.yy_color = [UIColor colorWithRGB:0x282828];
//    [text yy_setFont:[UIFont systemFontOfSize:20] range:NSMakeRange(4, 20)];
//    text.yy_lineSpacing = 58;
//    if (iPhone5 || iPhone4) {
//        text.yy_lineSpacing = 38;
//    }
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
    }];
    
    CGFloat titleSpace = 29;
    if (iPhone5 || iPhone4) {
        titleSpace = 13;
    }
    [self.view addSubview:self.normalTextField];
    [self.normalTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.normalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.areaNumLabel.mas_bottom).mas_equalTo(titleSpace);
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
    [self.clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
        [SDToastView HUDWithErrString:@"请输入收到的6位验证码"];
        return;
    }
    SDResetPwdRequest *request = [[SDResetPwdRequest alloc] init];
    request.mobile = self.phoneNum;
    request.smsCode = code;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SDForgetPwdThreeViewController *vc = [[SDForgetPwdThreeViewController alloc] init];
        vc.phoneNum = self.phoneNum;
        vc.smsCode = code;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
}

/** 限制输入框的长度和置灰显示 */
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
            self.clickBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        }else {
            self.clickBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
        }
    }
}

#pragma mark - network
- (void)sendSmsCode{
    SDSendResetPwdCodeRequest *request = [[SDSendResetPwdCodeRequest alloc] init];
    request.mobile = self.phoneNum;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self setupTimerWithType:SDSendSMSTypeResetPwd];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    
    }];
}

#pragma mark - lazy
- (UILabel *)areaNumLabel {
    if (!_areaNumLabel) {
        _areaNumLabel = [[UILabel alloc] init];
        _areaNumLabel.text = @"+86";
        _areaNumLabel.textColor = [UIColor colorWithRGB:0x282828];
        _areaNumLabel.font = [UIFont fontWithName:kSDPFRegularFont size:20];
    }
    return _areaNumLabel;
}

- (UIImageView *)arrowIv {
    if (!_arrowIv) {
        _arrowIv = [[UIImageView alloc] init];
        _arrowIv.image = [UIImage imageNamed:@"login_arrow"];
    }
    return _arrowIv;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor colorWithRGB:0x282828];
        _phoneLabel.font = [UIFont fontWithName:kSDPFRegularFont size:20];
    }
    return _phoneLabel;
}
@end
