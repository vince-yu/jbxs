//
//  SDAddAddressCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddAddressCell.h"
#import "SDAddAddressModel.h"

@interface SDAddAddressCell () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDAddAddressCell

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
    titleLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UITextField *contentTextField = [[UITextField alloc] init];
    contentTextField.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    contentTextField.textColor = [UIColor colorWithRGB:0x131413];
    contentTextField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    contentTextField.returnKeyType = UIReturnKeyDone;
    contentTextField.delegate = self;
    self.contentTextField = contentTextField;
    [self.contentView addSubview:contentTextField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setModel:(SDAddAddressModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.contentTextField.placeholder = _model.placeholder;
    self.lineView.hidden = _model.hiddenBottomLine;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(70);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.right.mas_equalTo(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self.viewController.view endEditing:YES];
    }
    return YES;
}

@end
