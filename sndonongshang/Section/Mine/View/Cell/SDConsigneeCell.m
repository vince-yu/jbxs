//
//  SDConsigneeCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDConsigneeCell.h"
#import "SDSexButton.h"

@interface SDConsigneeCell () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *shortLineView;
@property (nonatomic, weak) SDSexButton *maleBtn;
@property (nonatomic, weak) SDSexButton *femaleBtn;
@property (nonatomic, weak) SDSexButton *selectedBtn;

@end

@implementation SDConsigneeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"收 货 人";
    titleLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UITextField *contentTextField = [[UITextField alloc] init];
    contentTextField.placeholder = @"请输入收货人姓名";
    contentTextField.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    contentTextField.textColor = [UIColor colorWithRGB:0x131413];
    contentTextField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    contentTextField.returnKeyType = UIReturnKeyDone;
    contentTextField.delegate = self;
    self.contentTextField = contentTextField;
    [self.contentView addSubview:contentTextField];
    
    UIView *shortLineView = [[UIView alloc] init];
    shortLineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.shortLineView = shortLineView;
    [self.contentView addSubview:shortLineView];
    
    SDSexButton *femaleBtn = [SDSexButton buttonWithType:UIButtonTypeCustom];
    [femaleBtn setTitle:@"女士" forState:UIControlStateNormal];
    [femaleBtn addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.femaleBtn = femaleBtn;
    [self.contentView addSubview:femaleBtn];
    
    SDSexButton *maleBtn = [SDSexButton buttonWithType:UIButtonTypeCustom];
    [maleBtn setTitle:@"先生" forState:UIControlStateNormal];
    [maleBtn addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.maleBtn = maleBtn;
    [self.contentView addSubview:maleBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setSex:(NSString *)sex {
    _sex = sex;
    if ([sex isEqualToString:@"女士"]) {
        [self sexButtonClick:self.femaleBtn];
    }else if ([sex isEqualToString:@"先生"]) {
        [self sexButtonClick:self.maleBtn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(54);
        make.width.mas_equalTo(70);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-15);
    }];
    
    [self.shortLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.contentTextField);
        make.top.mas_equalTo(self.contentTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shortLineView);
        make.height.mas_equalTo(54);
        make.width.mas_equalTo(75);
        make.top.mas_equalTo(self.shortLineView.mas_bottom);
    }];
    
    [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.femaleBtn);
        make.top.mas_equalTo(self.femaleBtn);
        make.left.mas_equalTo(self.femaleBtn.mas_right).mas_equalTo(32);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - action
- (void)sexButtonClick:(SDSexButton *)clickButton {
    if (clickButton == self.selectedBtn) {
        if (clickButton.selected) {
            clickButton.selected = NO;
            self.selectedBtn = nil;
            if (self.block) {
                self.block(@"");
            }
            return;
        }
    }
    self.selectedBtn.selected = NO;
    clickButton.selected = YES;
    self.selectedBtn = clickButton;
    if (self.block) {
        self.block(self.selectedBtn.titleLabel.text);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self.viewController.view endEditing:YES];
    }
    return YES;
}


@end
