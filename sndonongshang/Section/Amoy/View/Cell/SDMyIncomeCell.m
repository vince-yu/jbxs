//
//  SDMyIncomeCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyIncomeCell.h"

@interface SDMyIncomeCell ()

@property (nonatomic, weak) UILabel *valueLabel;
@property (nonatomic, weak) UIImageView *arrowIv;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDMyIncomeCell

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
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    titleLabel.textColor = [UIColor colorWithRGB:0x131413];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    valueLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    self.valueLabel = valueLabel;
    [self.contentView addSubview:valueLabel];
    
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = [UIImage imageNamed:@"common_arrow"];
    self.arrowIv = arrowIv;
    [self.contentView addSubview:arrowIv];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xEBEBED];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setModel:(SDSettingModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.valueLabel.text = _model.value;
    self.lineView.hidden = _model.isHiddenLine;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView).mas_offset(-1);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(6, 11));
        make.centerY.mas_equalTo(self.contentView);
    }];

    CGFloat valueRightM = self.arrowIv.hidden ? 15 : 12 + 15 + 6;
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-valueRightM);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.titleLabel);
        make.width.mas_lessThanOrEqualTo(@(SCREEN_WIDTH * 0.5));
    }];
}

@end
