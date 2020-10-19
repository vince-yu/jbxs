//
//  SDPhoneTextFieldView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPhoneTextFieldView.h"

@interface SDPhoneTextFieldView () <UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *arrowIv;


@end

@implementation SDPhoneTextFieldView

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        [self initSubView];
    }
    return self;
}


- (void)initSubView {
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"+86";
    tipsLabel.font = [UIFont systemFontOfSize:20];
    tipsLabel.textColor = [UIColor colorWithRGB:0x3c3e40];
    self.tipsLabel = tipsLabel;
    [self addSubview:tipsLabel];
    
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = [UIImage imageNamed:@"login_arrow"];
    self.arrowIv = arrowIv;
    [self addSubview:arrowIv];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.placeholder = @"请输入手机号";
    phoneTextField.tintColor =  [UIColor colorWithHexString:kSDGreenTextColor];
    phoneTextField.font = [UIFont systemFontOfSize:18];
    phoneTextField.textColor = [UIColor colorWithRGB:0x3c3e40];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
//    phoneTextField.delegate = self;
    self.phoneTextField = phoneTextField;
    [self addSubview:phoneTextField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xe6e6e6];
    self.lineView = lineView;
    [self addSubview:lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(23);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.phoneTextField);
    }];
    
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 10));
        make.centerY.mas_equalTo(self.tipsLabel);
        make.left.mas_equalTo(self.tipsLabel.mas_right).mas_equalTo(13);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).mas_equalTo(15);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField.text.length > 11) {
//        self
//        return YES;
//    }
//}

@end
