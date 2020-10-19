//
//  SDSafeVerifyViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/7.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSafeVerifyViewController.h"
#import "SDWithdrawalViewController.h"
#import "SDBrokerageDataManager.h"

@interface SDSafeVerifyViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UITextField *phoneTextField;
@property (nonatomic, weak) UITextField *smsCodeTextField;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, weak) UIButton *smsCodeBtn;
@property (nonatomic, weak) UIButton *checkSmsCodeBtn;


@property (nonatomic, weak) NSTimer *timer;
/** 定时器完成时间 */
@property (nonatomic, assign) CGFloat timeInterval;
@end

@implementation SDSafeVerifyViewController

#define Interval 60.0

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
    [self getSmsCode];
}

- (void)initNav {
    self.navigationItem.title = @"安全验证";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
}

- (void)initSubView {
    UIView *phoneView = [[UIView alloc] init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight + 10);
        make.height.mas_equalTo(55);
    }];
    
    UILabel *phoneTipsLabel = [[UILabel alloc] init];
    phoneTipsLabel.text = @"注册手机号";
    phoneTipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    phoneTipsLabel.textColor = [UIColor colorWithRGB:0x31302E];
    [phoneView addSubview:phoneTipsLabel];
    [phoneTipsLabel sizeToFit];
    [phoneTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.and.top.mas_equalTo(0);
        make.width.mas_equalTo(phoneTipsLabel.cp_w);
    }];
    
    UIButton *smsCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [smsCodeBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    smsCodeBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
    smsCodeBtn.layer.cornerRadius = 15;
    smsCodeBtn.layer.masksToBounds = YES;
    smsCodeBtn.layer.borderWidth = 1;
    smsCodeBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    [smsCodeBtn addTarget:self action:@selector(getSmsCode) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:smsCodeBtn];
    self.smsCodeBtn = smsCodeBtn;
    [smsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.centerY.mas_equalTo(phoneView);
    }];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    phoneTextField.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    phoneTextField.textColor = [UIColor colorWithRGB:0x31302E];
    phoneTextField.text = [SDUserModel sharedInstance].mobile;
    phoneTextField.userInteractionEnabled = NO;
    [phoneView addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTipsLabel.mas_right).mas_equalTo(10);
        make.top.and.bottom.mas_equalTo(0);
        make.right.mas_equalTo(smsCodeBtn.mas_left).mas_equalTo(-10);
    }];
    
    UIView *smsCodeView = [[UIView alloc] init];
    smsCodeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:smsCodeView];
    [smsCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(phoneView.mas_bottom).mas_equalTo(1);
        make.height.mas_equalTo(55);
    }];
    
    UILabel *smsCodeTipsLabel = [[UILabel alloc] init];
    smsCodeTipsLabel.text = @"验证码";
    smsCodeTipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    smsCodeTipsLabel.textColor = [UIColor colorWithRGB:0x31302E];
    [smsCodeView addSubview:smsCodeTipsLabel];
    [smsCodeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.and.top.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    
    UITextField *smsCodeTextField = [[UITextField alloc] init];
    smsCodeTextField.tintColor  =  [UIColor colorWithHexString:kSDGreenTextColor];
    smsCodeTextField.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    smsCodeTextField.textColor = [UIColor colorWithRGB:0x31302E];
    smsCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    smsCodeTextField.placeholder = @"请输入验证码";
    smsCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    smsCodeTextField.delegate = self;
    [smsCodeView addSubview:smsCodeTextField];
    self.smsCodeTextField = smsCodeTextField;
    [smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextField);
        make.right.mas_equalTo(-15);
        make.top.and.bottom.mas_equalTo(0);
    }];
    [smsCodeTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *checkSmsCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkSmsCodeBtn setTitle:@"点击验证" forState:UIControlStateNormal];
    [checkSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkSmsCodeBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
    checkSmsCodeBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    checkSmsCodeBtn.layer.masksToBounds = YES;
    checkSmsCodeBtn.layer.cornerRadius = 22.5;
    checkSmsCodeBtn.userInteractionEnabled = NO;
    [checkSmsCodeBtn addTarget:self action:@selector(checkSmsCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkSmsCodeBtn];
    self.checkSmsCodeBtn = checkSmsCodeBtn;
    [checkSmsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(smsCodeView.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
    self.timeInterval = 60.0;
}

- (void)setupTimer {
    [self invalidateTimer];
    self.timeInterval = Interval;
    NSString *timerStr = [NSString stringWithFormat:@"重新发送(%ds)", (int)self.timeInterval];
    [self.smsCodeBtn setTitle:timerStr forState:UIControlStateNormal];
    self.smsCodeBtn.layer.cornerRadius = 0;
    self.smsCodeBtn.layer.masksToBounds = NO;
    self.smsCodeBtn.layer.borderWidth = 0;
    [self.smsCodeBtn setTitle:timerStr forState:UIControlStateNormal];
    [self.smsCodeBtn setTitleColor:[UIColor colorWithHexString:kSDGrayTextColor] forState:UIControlStateNormal];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSmsCodeText) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - action
- (void)getSmsCode {
    [SDStaticsManager umEvent:kwithdrawal_code];
    [self.view endEditing:YES];
    if (self.timer) return;
    [SDBrokerageDataManager sendSmsCodeWithCompleteBlock:^{
        [self setupTimer];
        [SDToastView HUDWithErrString:@"验证码已发送"];
    } failedBlock:^{
        
    }];
}

- (void)checkSmsCode {
    [SDStaticsManager umEvent:kwithdrawal_code_check];
    NSString *code = self.smsCodeTextField.text;
    if ([code isEmpty]) {
        return;
    }
    if (code.length != 6 || ![code isNumText]) {
        [SDToastView HUDWithErrString:@"请输入收到的6位验证码"];
        return;
    }
    [SDBrokerageDataManager sharedInstance].smsCode = code;
    SD_WeakSelf
    [SDBrokerageDataManager checkSmsCodeWithCompleteBlock:^{
        SD_StrongSelf
        SDWithdrawalViewController *vc = [[SDWithdrawalViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^{
        [SDBrokerageDataManager sharedInstance].smsCode = @"";
    }];
}

- (void)updateSmsCodeText{
    self.timeInterval = self.timeInterval - 1;
    if (self.timeInterval <= 0.0) {
        [self invalidateTimer];
        [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.smsCodeBtn.layer.cornerRadius = 15;
        self.smsCodeBtn.layer.masksToBounds = YES;
        self.smsCodeBtn.layer.borderWidth = 1;
        self.smsCodeBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        [self.smsCodeBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    }else {
        NSString *timerStr = [NSString stringWithFormat:@"重新发送(%ds)", (int)self.timeInterval];
        self.smsCodeBtn.layer.cornerRadius = 0;
        self.smsCodeBtn.layer.masksToBounds = NO;
        self.smsCodeBtn.layer.borderWidth = 0;
        [self.smsCodeBtn setTitle:timerStr forState:UIControlStateNormal];
        [self.smsCodeBtn setTitleColor:[UIColor colorWithHexString:kSDGrayTextColor] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textLengthChange:(UITextField *)textField{
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
        if (contentText.length == maxLength) {
            self.checkSmsCodeBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
            self.checkSmsCodeBtn.userInteractionEnabled = YES;
        }else {
            self.checkSmsCodeBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
            self.checkSmsCodeBtn.userInteractionEnabled = NO;
        }

    }
    
}


@end
