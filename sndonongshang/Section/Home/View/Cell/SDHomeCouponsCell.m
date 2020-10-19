//
//  SDHomeCouponsCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeCouponsCell.h"

@interface SDHomeCouponsCell ()

@property (nonatomic, strong) UIImageView *backgroundIv;
@property (nonatomic, strong) YYLabel *amountLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *typeBgIv;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *vaildDateLabel;
/** 优惠券张数 label 用于首页弹窗展示 */
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation SDHomeCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    [self.contentView addSubview:self.backgroundIv];
    [self.backgroundIv addSubview:self.amountLabel];
    [self.backgroundIv addSubview:self.descLabel];
    [self.backgroundIv addSubview:self.typeBgIv];
    [self.backgroundIv addSubview:self.typeLabel];
    [self.backgroundIv addSubview:self.tipsLabel];
    [self.backgroundIv addSubview:self.vaildDateLabel];
    [self.backgroundIv addSubview:self.numLabel];

}

- (void)setCouponsModel:(SDCouponsModel *)couponsModel {
    _couponsModel = couponsModel;
    /** 券类型[1:满减券 2:现金券(无门槛券) 3:折扣券 4:运费抵扣券] */
    NSString *tips = @"仅与运费券共用";
    if ([_couponsModel.type isEqualToString:@"1"]) { // 1:满减券
        self.typeLabel.text = @"满减券";
        //        self.typeLabel.backgroundColor = [UIColor colorWithRGB:0xF8665A];
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xF8665A] cornerRadius:7 size:CGSizeMake(43, 14)];
    }else if ([_couponsModel.type isEqualToString:@"2"]) { // 现金券(无门槛券)
        self.typeLabel.text = @"现金券";
        //        self.typeLabel.backgroundColor = [UIColor colorWithRGB:0x2BD6A4];
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0x4091EE] cornerRadius:7 size:CGSizeMake(43, 14)];
    }else if ([_couponsModel.type isEqualToString:@"3"]){ // 3:折扣券
        self.typeLabel.text = @"折扣券";
        //        self.typeLabel.backgroundColor = [UIColor colorWithRGB:0xEEBC24];
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xEEBC24] cornerRadius:7 size:CGSizeMake(43, 14)];
    }else if ([_couponsModel.type isEqualToString:@"4"]){ // 4:运费抵扣券
        self.typeLabel.text = @"运费券";
        //        self.typeLabel.backgroundColor = [UIColor colorWithRGB:0x4091EE];
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0x2BD6A4] cornerRadius:7 size:CGSizeMake(43, 14)];
        
        tips = @"仅能抵扣运费";
    }
    
    if ([_couponsModel.type isEqualToString:@"3"]){ // 3:折扣券
        NSString *amount = [NSString stringWithFormat:@"%@折", [_couponsModel.discount subPriceStr:2]];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amount];
        amountText.yy_color = [UIColor colorWithHexString:kSDRedTextColor];
        amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:28];
        amountText.yy_alignment = NSTextAlignmentCenter;
        [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:16] range:NSMakeRange(_couponsModel.discount.length, 1)];
        self.amountLabel.attributedText = amountText;
    }else {
        NSString *amount = [NSString stringWithFormat:@"￥%@", [_couponsModel.amount subPriceStr:2]];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amount];
        amountText.yy_color = [UIColor colorWithHexString:kSDRedTextColor];
        amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:28];
        amountText.yy_alignment = NSTextAlignmentCenter;
        [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:16] range:NSMakeRange(0, 1)];
        self.amountLabel.attributedText = amountText;
    }
    self.descLabel.text = _couponsModel.usage;
    self.vaildDateLabel.text = _couponsModel.rangeTime;
    self.tipsLabel.text = tips;
    self.numLabel.text = [NSString stringWithFormat:@"x%d", _couponsModel.num];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backgroundIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.and.top.mas_equalTo(0);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(21);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(23);
    }];
    
    if (iPhone5 || iPhone4) {
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(18);
        }];
        
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(43);
        }];
        
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.typeLabel);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_equalTo(10);
        }];
        
    }else {
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(28);
        }];
        
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(43);
        }];
        
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.typeLabel);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_equalTo(17);
        }];
    }
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).mas_equalTo(12);
        make.height.mas_equalTo(10);
    }];
    
    [self.typeBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.typeLabel);
    }];
    
    [self.vaildDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_equalTo(5);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.backgroundIv);
    }];
}

#pragma mark - lazy
- (UIImageView *)backgroundIv {
    if (!_backgroundIv) {
        _backgroundIv = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"home_coupons_bg"];
        _backgroundIv.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 92, 0, 5) resizingMode:UIImageResizingModeStretch];
    }
    return _backgroundIv;
}

- (YYLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[YYLabel alloc] init];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:@"￥200"];
        amountText.yy_color = [UIColor colorWithHexString:kSDRedTextColor];
        amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:28];
        amountText.yy_alignment = NSTextAlignmentCenter;
        [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:16] range:NSMakeRange(0, 1)];
        _amountLabel.attributedText = amountText;
    }
    return _amountLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"全品类通用";
        _descLabel.textColor = [UIColor colorWithRGB:0x868687];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _descLabel;
}

- (UIImageView *)typeBgIv {
    if (!_typeBgIv) {
        _typeBgIv = [[UIImageView alloc] init];
    }
    return _typeBgIv;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"满减券";
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"仅与运费券共用";
        _tipsLabel.textColor = [UIColor colorWithRGB:0x868687];
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _tipsLabel;
}

- (UILabel *)vaildDateLabel {
    if (!_vaildDateLabel) {
        _vaildDateLabel = [[UILabel alloc] init];
        _vaildDateLabel.text = @"2019.01.01 - 2019.02.02";
        _vaildDateLabel.textColor = [UIColor colorWithRGB:0x868687];
        _vaildDateLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _vaildDateLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor colorWithRGB:0x868687];
        _numLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
    }
    return _numLabel;
}

@end
