//
//  SDDefaultAddressCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDefaultAddressCell.h"
@interface SDDefaultAddressCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDDefaultAddressCell
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
    titleLabel.text = @"设为默认地址";
    titleLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UISwitch *defaultAddressSwitch = [[UISwitch alloc] init];
    defaultAddressSwitch.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
    defaultAddressSwitch.tintColor = [UIColor colorWithHexString:kSDGrayTextColor];
    defaultAddressSwitch.onTintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    [defaultAddressSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    self.defaultAddressSwitch = defaultAddressSwitch;
    [self.contentView addSubview:defaultAddressSwitch];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)switchChange:(UISwitch *)addrSwitch {
    if (addrSwitch.on) {
        [SDToastView HUDWithString:@"已设为默认地址"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.defaultAddressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
    self.defaultAddressSwitch.layer.cornerRadius = self.defaultAddressSwitch.cp_h/2.0;
    self.defaultAddressSwitch.layer.masksToBounds = YES;
}

@end
