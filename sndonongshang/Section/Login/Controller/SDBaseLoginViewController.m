//
//  SDBaseLoginViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseLoginViewController.h"
#import "SDSendLoginSMS.h"
#import "SDSendResetPwdCodeRequest.h"
#import "SDSendBindCodeRequest.h"

#define Interval 60.0

@interface SDBaseLoginViewController () <UITextFieldDelegate>

@property (nonatomic, assign) SDSendSMSType sendSmsType;

@end

@implementation SDBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.timeInterval = Interval;
}

- (void)initSubView {
    [self.view addSubview:self.bottomView];
    CGFloat bottomH = 203;
    if (iPhone4 || iPhone5) {
        bottomH = 203 -36;
    }
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.height.mas_equalTo(bottomH);
    }];
}


#pragma mark - timer
- (void)setupTimerWithType:(SDSendSMSType)sendSmsType
{
    [self invalidateTimer];
    self.sendSmsType = sendSmsType;
    self.timeInterval = Interval;
    self.tipsLabel.text = [NSString stringWithFormat:@"%ds后重新获取验证码", (int)self.timeInterval];
    self.tipsLabel.textColor = [UIColor colorWithRGB:0xc2c3c3];
    self.tipsLabel.textTapAction = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTipsLabel) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
    self.timeInterval = 60.0;
    self.tipsLabel.text = @"收不到验证码点这里";
    self.tipsLabel.textColor =  [UIColor colorWithHexString:kSDGreenTextColor];
    SD_WeakSelf
    self.tipsLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        SD_StrongSelf
        [self sendSMSCode];
    };
}

- (void)changeTipsLabel{
    self.timeInterval = self.timeInterval - 1;
    if (self.timeInterval <= 0.0) {
        [self invalidateTimer];
    }else {
        self.tipsLabel.text = [NSString stringWithFormat:@"%ds后重新获取验证码", (int)self.timeInterval];
    }
}

- (BOOL)vaildPassword:(NSString *)password {
    NSString *passwordRegex =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,32}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    NSLog(@"passwordTest is %@",passwordTest);
    return [passwordTest evaluateWithObject:password];
}

#pragma mark - network
/** 调用发送验证码接口 */
- (void)sendSMSCode {
    if (self.sendSmsType == SDSendSMSTypeLogin) {
        SDSendLoginSMS *request = [[SDSendLoginSMS alloc] init];
        request.mobile = self.phoneNum;
        [SDToastView show];
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self setupTimerWithType:self.sendSmsType];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }else if (self.sendSmsType == SDSendSMSTypeBind) {
        SDSendBindCodeRequest *request = [[SDSendBindCodeRequest alloc] init];
        request.mobile = self.phoneNum;
        [SDToastView show];
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self setupTimerWithType:self.sendSmsType];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }else if (self.sendSmsType == SDSendSMSTypeResetPwd) {
        SDSendResetPwdCodeRequest *request = [[SDSendResetPwdCodeRequest alloc] init];
        request.mobile = self.phoneNum;
        [SDToastView show];
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self setupTimerWithType:self.sendSmsType];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        }];
    }
}

#pragma mark - getter
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [YYLabel new];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"欢迎来到汇农时代"];
        text.yy_font = [UIFont systemFontOfSize:29];
        text.yy_color = [UIColor colorWithRGB:0x282828];
        _titleLabel.attributedText = text;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 101) {
        if (textField.keyboardType == UIKeyboardTypeNumberPad) { // 验证码文本框
            if (textField.text.length == 6 && string.length > 0) {
                [self.view endEditing:YES];
                return YES;
            }
        }else { // 密码文本框
            
        }
        
        return YES;
    }
    
    return YES;
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn setTitle:@"登录" forState:UIControlStateNormal];
        _clickBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
        [_clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _clickBtn.layer.cornerRadius = 25;
        _clickBtn.layer.masksToBounds = YES;
    }
    return _clickBtn;
}

- (YYLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [YYLabel new];
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.textColor = [UIColor colorWithRGB:0xc2c3c3];
    }
    return _tipsLabel;
}

- (SDPhoneTextFieldView *)phoneTextFieldView {
    if (!_phoneTextFieldView) {
        _phoneTextFieldView = [[SDPhoneTextFieldView alloc] init];
        _phoneTextFieldView.phoneTextField.delegate = self;
    }
    return _phoneTextFieldView;
}


- (SDLoginTextField *)normalTextField {
    if (!_normalTextField) {
        _normalTextField = [[SDLoginTextField alloc] init];
        _normalTextField.placeholder = @"请输入验证码";
        _normalTextField.keyboardType = UIKeyboardTypeNumberPad;
        _normalTextField.delegate = self;
        _normalTextField.tag = 101;
    }
    return _normalTextField;
}

- (SDLoginBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[SDLoginBottomView alloc] init];
    }
    return _bottomView;
}

- (UIView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[UIView alloc] init];
        _gradientView.backgroundColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,SCREEN_WIDTH,103);
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:78/255.0 green:184/255.0 blue:8/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:139/255.0 green:216/255.0 blue:19/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0f),@(1.0f)];
        [_gradientView.layer addSublayer:gl];
        _gradientView.cornerRadius = 25;
    }
    return _gradientView;
}

@end
