//
//  SDSettingCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSettingCell.h"

@interface SDSettingCell ()

@property (nonatomic, weak) UILabel *valueLabel;
@property (nonatomic, weak) UIImageView *arrowIv;
@property (nonatomic, weak) UIImageView *avatorIv;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDSettingCell

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
    titleLabel.text = @"头像";
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    titleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"小猪佩奇";
    valueLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    valueLabel.textColor = [UIColor colorWithRGB:0x848488];
    self.valueLabel = valueLabel;
    [self.contentView addSubview:valueLabel];
    
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = [UIImage imageNamed:@"common_arrow"];
    self.arrowIv = arrowIv;
    [self.contentView addSubview:arrowIv];
    
    UIImageView *avatorIv = [[UIImageView alloc] init];
    avatorIv.image = [UIImage imageNamed:@"mine_avator"];
    avatorIv.layer.masksToBounds = YES;
    avatorIv.layer.cornerRadius = 40 * 0.5;
    self.avatorIv = avatorIv;
    [self.contentView addSubview:avatorIv];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setModel:(SDSettingModel *)model {
    _model = model;
    self.arrowIv.hidden = _model.isHiddenArrow;
    self.titleLabel.text = _model.title;
    self.valueLabel.text = _model.value;
    self.valueLabel.textColor = _model.isValueChoose ? [UIColor colorWithHexString:kSDGreenTextColor] : [UIColor colorWithRGB:0x848488];
    self.avatorIv.hidden = !_model.isShowAvator;
    [self.avatorIv sd_setImageWithURL:[NSURL URLWithString:_model.avatorUrl] placeholderImage:[UIImage imageNamed:@"mine_avator"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.valueLabel.mas_left).mas_equalTo(-10);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(6, 11));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    CGFloat valueRightM = self.arrowIv.hidden ? 15 : 10 + 15 + 6;
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-valueRightM);
    }];
    
    [self.avatorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

@end
