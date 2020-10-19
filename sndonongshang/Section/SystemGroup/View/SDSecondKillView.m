//
//  SDSecondKillView.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSecondKillView.h"

@interface SDSecondKillView ()

@property (nonatomic, strong) UILabel *secondKillTagLabel;
@property (nonatomic, strong) UILabel *priceTagLabel;
@property (nonatomic, strong) YYLabel *priceActiveLabel;
@property (nonatomic, strong) YYLabel *priceLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation SDSecondKillView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return  self;
}

- (void)initSubView {
    [self addSubview:self.secondKillTagLabel];
    [self addSubview:self.priceActiveLabel];
    [self addSubview:self.priceTagLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.tipsLabel];
}

- (void)setModel:(SDCartCalculateModel *)model {
    _model = model;
    if (model.more.count == 0) {
        return;
    }
    SDCartCalculateMoreModel *moreModel = _model.more.firstObject;
    int saleNum = moreModel.num.intValue - moreModel.beyond.intValue;
    NSString *saleNumStr = [NSString stringWithFormat:@"%d", saleNum];
    self.priceActiveLabel.attributedText = [NSString getPriceAttributedString:[moreModel.priceActive priceStr] priceFontSize:14 count:saleNumStr countSize:10];
    self.priceLabel.attributedText = [NSString getOldPriceAttributedString:[moreModel.price priceStr] priceFontSize:11 count:moreModel.beyond countSize:10];
    if (moreModel.type != SDCalculateTypeSecondKillNomal || moreModel.type != SDCalculateTypeSecondKillGoodNone) {
        self.tipsLabel.text = moreModel.tips;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.secondKillTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 14));
        make.top.and.left.mas_equalTo(0);
    }];
    [self.priceActiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.secondKillTagLabel);
        make.left.mas_equalTo(self.secondKillTagLabel.mas_right).mas_equalTo(5);
        make.right.mas_equalTo(0);
    }];
    [self.priceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 14));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.secondKillTagLabel.mas_bottom).mas_equalTo(6);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceTagLabel);
        make.left.mas_equalTo(self.priceTagLabel.mas_right).mas_equalTo(5);
        make.right.mas_equalTo(0);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.priceTagLabel.mas_bottom).mas_equalTo(6);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - lazy
- (UILabel *)secondKillTagLabel {
    if (!_secondKillTagLabel) {
        _secondKillTagLabel = [[UILabel alloc] init];
        _secondKillTagLabel.cp_w = 30;
        _secondKillTagLabel.cp_h = 14;
        _secondKillTagLabel.text = @"秒杀";
        _secondKillTagLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _secondKillTagLabel.textColor = [UIColor whiteColor];
        _secondKillTagLabel.textAlignment = NSTextAlignmentCenter;
        [_secondKillTagLabel addTagBGWithType:@"4"];
    }
    return _secondKillTagLabel;
}

- (UILabel *)priceTagLabel {
    if (!_priceTagLabel) {
        _priceTagLabel = [[UILabel alloc] init];
        _priceTagLabel.cp_w = 30;
        _priceTagLabel.cp_h = 14;
        _priceTagLabel.text = @"原价";
        _priceTagLabel.textColor = [UIColor whiteColor];
        _priceTagLabel.font = [UIFont fontWithName:kSDPFLightFont size:10];
        _priceTagLabel.textAlignment = NSTextAlignmentCenter;
        [_priceTagLabel addTagBGWithType:@"1"];
    }
    return _priceTagLabel;
}

- (YYLabel *)priceActiveLabel {
    if (!_priceActiveLabel) {
        _priceActiveLabel = [[YYLabel alloc] init];
    }
    return _priceActiveLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
    }
    return _priceLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:kSDPFLightFont size:10];
        _tipsLabel.textColor = [UIColor colorWithHexString:kSDRedTextColor];
    }
    return _tipsLabel;
}


@end
