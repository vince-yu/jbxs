//
//  SDAddressMgrCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressMgrCell.h"

@interface SDAddressMgrCell ()

@property (nonatomic, weak) UIImageView *selectedIv;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UIButton *defaultBtn;
@property (nonatomic, weak) UIButton *exidBtn;
@property (nonatomic, weak) UIButton *clickBtn;
@property (nonatomic, weak) UIView *lineView;


@end

@implementation SDAddressMgrCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UIImageView *selectedIv = [[UIImageView alloc] init];
    selectedIv.image = [UIImage imageNamed:@"cart_good_selected"];
    [self.contentView addSubview:selectedIv];
    self.selectedIv = selectedIv;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor colorWithRGB:0x131413];
    nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = [UIColor colorWithRGB:0x131413];
    phoneLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    self.phoneLabel = phoneLabel;
    [self.contentView addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    addressLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
    self.addressLabel = addressLabel;
    [self.contentView addSubview:addressLabel];
    
    UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [defaultBtn setTitle:@"默认" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    defaultBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
    defaultBtn.backgroundColor = [UIColor colorWithRGB:0xEDFDEF];
    defaultBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    defaultBtn.layer.borderWidth = 1;
    defaultBtn.layer.cornerRadius = 8;
    defaultBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:defaultBtn];
    self.defaultBtn = defaultBtn;
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn addTarget:self action:@selector(editAddressClick) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn = clickBtn;
    [self.contentView addSubview:clickBtn];
    
    UIButton *exidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exidBtn setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    [exidBtn addTarget:self action:@selector(editAddressClick) forControlEvents:UIControlEventTouchUpInside];
    self.exidBtn = exidBtn;
    [self.contentView addSubview:exidBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setModel:(SDAddressModel *)model {
    _model = model;
    self.phoneLabel.text = _model.mobile;
    self.nameLabel.text = _model.name;
//    self.addressLabel.text = _model.sketch;
//    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", _model.province, _model.city, _model.street, _model.house_number];
    self.addressLabel.text = _model.fullAddr;
    self.defaultBtn.hidden = !_model.is_default;
    self.selectedIv.hidden = !_model.isSelected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            confirmView.backgroundColor = [UIColor colorWithRGB:0xfd7573];
            for(UIView *sub in confirmView.subviews){
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                    UILabel *deleteLabel=(UILabel *)sub;
                    deleteLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
                }
            }
            break;
        }
    }
    
    [self.selectedIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
    }];
    
    if (self.model.isSelected) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(self.selectedIv.mas_right).mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(85);
            make.height.mas_equalTo(18);
        }];
    }else {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(21);
            make.left.mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(85);
            make.height.mas_equalTo(18);
        }];
    }
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_equalTo(10);
    }];
    
    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 16));
        make.centerY.mas_equalTo(self.phoneLabel);
        make.left.mas_equalTo(self.phoneLabel.mas_right).mas_equalTo(10);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_top).mas_equalTo(-20);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.exidBtn.mas_left).mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];
    
    [self.exidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(27 * 0.5, 24 * 0.5));
        make.width.mas_equalTo(27 * 0.5 + 10 + 10);
        make.height.mas_equalTo(24 * 0.5 + 10 + 10);
        make.centerY.mas_equalTo(self.addressLabel);
        make.right.mas_equalTo(-5);
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.right.and.top.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.exidBtn);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - action
- (void)editAddressClick {
    [SDStaticsManager umEvent:kaddress_edit];
    if (self.block) {
        self.block();
    }
}

@end
