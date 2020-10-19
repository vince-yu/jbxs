//
//  SDMyCouponsCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyCouponsCell.h"

@interface SDMyCouponsCell ()

@property (nonatomic, strong) UIImageView *backgroundIv;
@property (nonatomic, strong) YYLabel *amountLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *typeBgIv;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *vaildDateLabel;
@property (nonatomic, strong) UIButton *goUseBtn;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIView *bottomView;
/** 互斥提示label */
@property (nonatomic, strong) UILabel *mutexTipsLabel;

@end

@implementation SDMyCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xEFEFF4];
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
    [self.backgroundIv addSubview:self.goUseBtn];
    [self.backgroundIv addSubview:self.chooseBtn];
    [self.backgroundIv addSubview:self.bottomView];
    [self.bottomView addSubview:self.mutexTipsLabel];
}

- (void)setCouponsModel:(SDCouponsModel *)couponsModel {
    _couponsModel = couponsModel;
    /** 券类型[1:满减券 2:现金券(无门槛券) 3:折扣券 4:运费抵扣券] */
    UIImage *bgImage = nil;
    NSString *tips = @"仅与运费券共用";
    if ([_couponsModel.type isEqualToString:@"1"]) { // 1:满减券
        bgImage = [UIImage imageNamed:@"mine_coupons_red"];
        self.typeLabel.text = @"满减券";
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xF8665A] cornerRadius:7 size:CGSizeMake(43, 14)];
    }else if ([_couponsModel.type isEqualToString:@"2"]) { // 现金券(无门槛券)
        bgImage = [UIImage imageNamed:@"mine_coupons_blue"];
        self.typeLabel.text = @"现金券";
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0x4091EE] cornerRadius:7 size:CGSizeMake(43, 14)];
    }else if ([_couponsModel.type isEqualToString:@"3"]){ // 3:折扣券
        bgImage = [UIImage imageNamed:@"mine_coupons_yellow"];
        self.typeLabel.text = @"折扣券";
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xEEBC24] cornerRadius:7 size:CGSizeMake(43, 14)];
    }else if ([_couponsModel.type isEqualToString:@"4"]){ // 4:运费抵扣券
        bgImage = [UIImage imageNamed:@"mine_coupons_green"];
        self.typeLabel.text = @"运费券";
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0x2BD6A4] cornerRadius:7 size:CGSizeMake(43, 14)];
        tips = @"仅能抵扣运费";
    }
    self.chooseBtn.selected = _couponsModel.isUsed;

    // 互斥 置灰
    if (_couponsModel.isMutex) {
        bgImage = [UIImage imageNamed:@"mine_coupons_gary"];
        self.typeBgIv.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xdcdcdc] cornerRadius:7 size:CGSizeMake(43, 14)];
        self.tipsLabel.textColor = [UIColor colorWithRGB:0xdcdcdc];
        self.vaildDateLabel.textColor = [UIColor colorWithRGB:0xdcdcdc];
    }else {
        self.tipsLabel.textColor = [UIColor colorWithRGB:0x868687];
        self.vaildDateLabel.textColor = [UIColor colorWithRGB:0x868687];
    }
    self.backgroundIv.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 92, 0, 7) resizingMode:UIImageResizingModeStretch];

    
    if ([_couponsModel.type isEqualToString:@"3"]){ // 3:折扣券
        NSString *amount = [NSString stringWithFormat:@"%@折", _couponsModel.discount];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amount];
        amountText.yy_color = [UIColor whiteColor];
        amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:28];
        amountText.yy_alignment = NSTextAlignmentCenter;
        [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:16] range:NSMakeRange(_couponsModel.discount.length, 1)];
        self.amountLabel.attributedText = amountText;
    }else {
        NSString *amount = [NSString stringWithFormat:@"￥%@", _couponsModel.amount];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amount];
        amountText.yy_color = [UIColor whiteColor];
        amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:28];
        amountText.yy_alignment = NSTextAlignmentCenter;
        [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:16] range:NSMakeRange(0, 1)];
        self.amountLabel.attributedText = amountText;
    }
    
    self.descLabel.text = _couponsModel.usage;
    self.vaildDateLabel.text = _couponsModel.rangeTime;
    self.tipsLabel.text = tips;
    
    if (_couponsModel.displayType == SDCouponsDisplayTypeNone) {
        self.goUseBtn.hidden = YES;
        self.chooseBtn.hidden = YES;
        self.bottomView.hidden = YES;
    }else if (_couponsModel.displayType == SDCouponsDisplayTypeRadioBox) {
        self.goUseBtn.hidden = YES;
        self.chooseBtn.hidden = NO;
        if (_couponsModel.isMutex) {
            self.bottomView.hidden = NO;
            if ([_couponsModel.type isEqualToString:@"4"]) {
                self.mutexTipsLabel.text = @"不可与其他运费券叠加使用";
            }else {
                self.mutexTipsLabel.text = @"不可与现金券、满减券和折扣券叠加使用";
            }
        }else {
            self.bottomView.hidden = YES;
        }
    }else if (_couponsModel.displayType == SDCouponsDisplayTypeUseButton) {
        self.goUseBtn.hidden = NO;
        self.chooseBtn.hidden = YES;
        self.bottomView.hidden = YES;
    }
    //可领券逻辑
    if (self.couponsModel.notObtain) {
        [self.goUseBtn setTitle:@"去领取" forState:UIControlStateNormal];
        [self.goUseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.goUseBtn setBackgroundColor:[UIColor colorWithHexString:kSDGreenTextColor]];
        self.vaildDateLabel.hidden = YES;
        if (self.couponsModel.displayType == SDCouponsDisplayTypeNone) {
            self.goUseBtn.hidden = NO;
        }
    }else{
        [self.goUseBtn setTitle:@"去使用" forState:UIControlStateNormal];
        [self.goUseBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
        [self.goUseBtn setBackgroundColor:[UIColor whiteColor]];
        self.vaildDateLabel.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backgroundIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
  
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(21);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(28);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(43);
    }];
    
    [self.typeBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.vaildDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_equalTo(5);
    }];
    
    [self.goUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 25));
        make.centerY.mas_equalTo(self.backgroundIv);
        make.right.mas_equalTo(-10);
    }];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(self.backgroundIv);
        make.right.mas_equalTo(-15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(19);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.mutexTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.and.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
}

#pragma mark - lazy
- (UIImageView *)backgroundIv {
    if (!_backgroundIv) {
        _backgroundIv = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"mine_coupons_red"];
        _backgroundIv.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 92, 0, 7) resizingMode:UIImageResizingModeStretch];
    }
    return _backgroundIv;
}

- (YYLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[YYLabel alloc] init];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:@"￥200"];
        amountText.yy_color = [UIColor whiteColor];
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
        _descLabel.textColor = [UIColor whiteColor];
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

- (UIButton *)goUseBtn {
    if (!_goUseBtn) {
        _goUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goUseBtn setTitle:@"去使用" forState:UIControlStateNormal];
        [_goUseBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
        _goUseBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _goUseBtn.userInteractionEnabled = NO;
        _goUseBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        _goUseBtn.layer.borderWidth = 0.5;
        _goUseBtn.layer.cornerRadius = 12.5;
        _goUseBtn.layer.masksToBounds = YES;
    }
    return _goUseBtn;
}


- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setImage:[UIImage imageNamed:@"cart_good_selected"] forState:UIControlStateSelected];
        [_chooseBtn setImage:[UIImage imageNamed:@"cart_good_unselected"] forState:UIControlStateNormal];
        _chooseBtn.userInteractionEnabled = NO;
    }
    return _chooseBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UILabel *)mutexTipsLabel {
    if (!_mutexTipsLabel) {
        _mutexTipsLabel = [[UILabel alloc] init];
        _mutexTipsLabel.text = @"不可与已勾选券叠加使用";
        _mutexTipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _mutexTipsLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
    return _mutexTipsLabel;
}


@end
