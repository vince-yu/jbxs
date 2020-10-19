//
//  SDLoginViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLoginViewController.h"
#import "SDPasswordLoginViewController.h"
#import "SDRegisterSmsCodeViewController.h"
#import "SDSmsCodeViewController.h"
#import "SDRegisterSmsCodeViewController.h"
#import "SDCheckUserRequest.h"

@interface SDLoginViewController ()

@end

@implementation SDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
}

+ (void)present {
    SDLoginViewController *loginVC = [[SDLoginViewController alloc] init];
    SDNavigationViewController *navVc = [[SDNavigationViewController alloc] initWithRootViewController:loginVC];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:navVc animated:YES completion:nil];
}

- (void)initNav {
    UIImage *leftImage = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)initSubView {
    [super initSubView];
    
    CGFloat space = 20;
    if (iPhone5 || iPhone4) {
        space = 15;
    }
    CGFloat topMargin = kTopHeight + space;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Hello，\n欢迎来到九本鲜生"];
    text.yy_font = [UIFont systemFontOfSize:29];
    text.yy_color = [UIColor colorWithRGB:0x282828];
    text.yy_lineSpacing = 15;
    self.titleLabel.attributedText = text;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topMargin);
        make.left.mas_equalTo(SDMargin);
    }];
    
    CGFloat titleSpace = 65;
    if (iPhone5 || iPhone4) {
        titleSpace = 30;
    }
    self.phoneTextFieldView.phoneTextField.placeholder = @"请输入手机号";
    [self.phoneTextFieldView.phoneTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.phoneTextFieldView];
    [self.phoneTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(titleSpace);
        make.height.mas_equalTo(39);
    }];
    
//    self.tipsLabel.text = @"未注册过的手机将自动保存为九本鲜生账户";
//    [self.view addSubview:self.tipsLabel];
//    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SDMargin);
//        make.top.mas_equalTo(self.phoneTextFieldView.mas_bottom).mas_equalTo(12);
//    }];
    
    CGFloat tipsSpace = 59;
    if (iPhone5 || iPhone4) {
        tipsSpace = 45;
    }
    [self.clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(loginOrRegisterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.phoneTextFieldView.mas_bottom).mas_equalTo(tipsSpace);
        make.height.mas_equalTo(50);
    }];

}

#pragma mark - action
- (void)loginOrRegisterBtnClick {
    NSString *phoneNum = self.phoneTextFieldView.phoneTextField.text;
    if ([phoneNum isEmpty]) {
        return;
    }
    if (![phoneNum isPhoneNumber]) {
        [SDToastView HUDWithErrString:@"请输入11位手机号"];
        return;
    }
    SDCheckUserRequest *request = [[SDCheckUserRequest alloc] init];
    request.mobile = phoneNum;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCheckUserRequest * _Nonnull request) {
        SDBaseLoginViewController *vc = nil;
        if (request.exists) { // 已注册
            //暂时删除密码相关
//            if (request.password) {
//                vc = [[SDPasswordLoginViewController alloc] init];
//            }else {
                vc = [[SDSmsCodeViewController alloc] init];
//            }
        }else { // 未注册
           vc = [[SDRegisterSmsCodeViewController alloc] init];
        }
        vc.phoneNum = phoneNum;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

- (void)closeBtnClick {
    SNDOLOG(@"关闭 登录页面");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)textLengthChange:(UITextField *)textField{
    if (!textField) return;

    NSUInteger maxLength = 11;
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
        if (contentText.length == maxLength && [contentText isPhoneNumber]) {
            self.clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
        }else {
            self.clickBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
        }
    }
    
}



@end
