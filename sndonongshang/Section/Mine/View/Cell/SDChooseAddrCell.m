//
//  SDChooseAddrCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChooseAddrCell.h"

@interface SDChooseAddrCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIImageView *arrowIv;


@end

@implementation SDChooseAddrCell

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
    titleLabel.text = @"收货地址";
    titleLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UITextField *contentTextField = [[UITextField alloc] init];
    contentTextField.placeholder = @"请输入您的收货地址";
    contentTextField.font = [UIFont fontWithName:kSDPFBoldFont size:12];
    contentTextField.textColor = [UIColor colorWithRGB:0x131413];
    contentTextField.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
    self.contentTextField = contentTextField;
    [self.contentView addSubview:contentTextField];
    
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = [UIImage imageNamed:@"common_arrow"];
    self.arrowIv = arrowIv;
    [self.contentView addSubview:arrowIv];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
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
        make.right.mas_equalTo(self.arrowIv.mas_left).mas_equalTo(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(6, 11));
        make.centerY.mas_equalTo(self.contentView);
    }];
}

@end

