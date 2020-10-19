//
//  SDChangeNicknameViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChangeNicknameViewController.h"

@interface SDChangeNicknameViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *nicknameTextField;

@end

@implementation SDChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
}

- (void)initNav {
    self.view.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
    self.navigationItem.title = @"修改昵称";
}

- (void)initSubView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.mas_equalTo(0);
    }];
    
    UITextField *nicknameTextField = [[UITextField alloc] init];
    nicknameTextField.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    nicknameTextField.textColor = [UIColor colorWithRGB:0x131413];
    nicknameTextField.text = @"asdadasdqeqwe";
    nicknameTextField.backgroundColor = [UIColor whiteColor];
    nicknameTextField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameTextField.returnKeyType = UIReturnKeyDone;
    nicknameTextField.delegate = self;
    [self.view addSubview:nicknameTextField];
    [nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(kTopHeight);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xE7E6E6];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(nicknameTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"4-20个字符，可由中英文、数字、“-”、“_”组成";
    tipsLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
    tipsLabel.textColor = [UIColor colorWithRGB:0xA0A0A2];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
@end
