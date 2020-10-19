//
//  SDShopCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDShopCell.h"

@interface SDShopCell ()

@property (nonatomic, weak) UIButton *iconBtn;

@property (nonatomic, weak) UIImageView *iconIv;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) YYLabel *saleNumLabel;
/** 折扣价 */
@property (nonatomic, weak) YYLabel *discountLabel;
/** 原价 */
@property (nonatomic, weak) YYLabel *priceLabel;
@property (nonatomic, weak) YYLabel *buyNumLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *tagsView;
/** 秒杀 提示label */
@property (nonatomic, strong) UILabel *tipsLabel;

/** 秒杀标签 */
@property (nonatomic, strong) UILabel *secondKillTagLabel;
/** 原价标签 */
@property (nonatomic, strong) UILabel *priceTagLabel;
/** 秒杀 超出数量 label */
@property (nonatomic, strong) UILabel *beyondLabel;

@end

@implementation SDShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.backgroundColor =  [UIColor colorWithRGB:0xefeff4];
    iconIv.contentMode = UIViewContentModeScaleAspectFit;
    self.iconIv = iconIv;
    [self.contentView addSubview:iconIv];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.contentMode = UIViewContentModeScaleAspectFit;
    iconBtn.backgroundColor =  [UIColor colorWithRGB:0xefeff4];
    self.iconBtn = iconBtn;
    [self.contentView addSubview:iconBtn];

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = [UIColor colorWithRGB:0x333333];
    nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    YYLabel *saleNumLabel = [[YYLabel alloc] init];
    saleNumLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
    saleNumLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    self.saleNumLabel = saleNumLabel;
    [self.contentView addSubview:saleNumLabel];
    
    YYLabel *discountLabel= [[YYLabel alloc] init];
    self.discountLabel = discountLabel;
    [self.contentView addSubview:discountLabel];
    
    YYLabel *priceLabel= [[YYLabel alloc] init];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    YYLabel *buyNumLabel = [[YYLabel alloc] init];
    buyNumLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    buyNumLabel.textColor = [UIColor colorWithRGB:0x333333];
    self.buyNumLabel = buyNumLabel;
    [self.contentView addSubview:buyNumLabel];
    
    [self.contentView addSubview:self.tagsView];
    [self.contentView addSubview:self.lineView];
//    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.secondKillTagLabel];
    [self.contentView addSubview:self.priceTagLabel];
    [self.contentView addSubview:self.beyondLabel];
}

- (void)setGoodModel:(SDGoodModel *)goodModel {
    _goodModel = goodModel;
    self.nameLabel.text = goodModel.name;
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:goodModel.miniPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"cart_placeholder"]];
    self.buyNumLabel.text = [NSString stringWithFormat:@"x%@", goodModel.num];
//    self.saleNumLabel.text = [NSString stringWithFormat:@"累计销售 %@ %@", _goodModel.sold.length ? _goodModel.sold : @"0",_goodModel.spec.length ? _goodModel.spec : @""];
    
   if (!self.goodModel.priceActive || [_goodModel.priceActive isEmpty] || [_goodModel.priceActive isEqualToString:_goodModel.price]) {
        self.priceLabel.hidden = YES;
        NSString *price = [goodModel.price priceStr];
        self.discountLabel.attributedText = [NSString getPriceAttributedString:price priceFontSize:14 unit:goodModel.spec unitSize:10];
    }else {
        self.discountLabel.hidden = NO;
        NSString *priceActive = [goodModel.priceActive priceStr];
        self.discountLabel.attributedText = [NSString getPriceAttributedString:priceActive priceFontSize:14 unit:goodModel.spec unitSize:10];
        
        self.priceLabel.hidden = NO;
        NSString *priceStr = [NSString stringWithFormat:@"￥%@", [goodModel.price priceStr]];
        NSMutableAttributedString *priceText = [[NSMutableAttributedString alloc] initWithString:priceStr];
        priceText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:11];
        priceText.yy_color = [UIColor colorWithHexString:kSDGrayTextColor];
        YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle];
        [priceText yy_setTextStrikethrough:decoration range:NSMakeRange(0, priceText.string.length)];
        self.priceLabel.attributedText = priceText;
    }
    

    if (_goodModel.tags && _goodModel.tags.count > 0) {
        self.tagsView.hidden = NO;
        [self.tagsView addTagWithArray:_goodModel.tags discount:_goodModel.discount];
//        if ([_goodModel.tags.firstObject integerValue] == SDGoodTypeSecondkill) {
//            self.tipsLabel.hidden = NO;
//        }else {
//            self.tipsLabel.hidden = YES;
//        }
    }else {
        self.tagsView.hidden = YES;
    }
    
    [self hideTagView:YES];
    if ([goodModel.type isEqualToString:@"4"] && [goodModel.beyond intValue] > 0) { // 秒杀 并且数量超过最大购买量
        int beyond = goodModel.beyond.intValue;
        int num = goodModel.num.intValue;
        if (beyond == num && [goodModel.limiting isEqualToString:@"goods"]) {
            [self hideTagView:YES];
            self.tagsView.hidden = NO;
            self.buyNumLabel.text = [NSString stringWithFormat:@"x%@", goodModel.num];
            NSString *price = [goodModel.price priceStr];
            self.discountLabel.attributedText = [NSString getPriceAttributedString:price priceFontSize:14 unit:goodModel.spec unitSize:10];
            self.priceLabel.hidden = YES;
        }else {
            [self hideTagView:NO];
            self.tagsView.hidden = YES;
            self.priceLabel.hidden = NO;
            self.beyondLabel.text =  [NSString stringWithFormat:@"x%@", goodModel.beyond];
            int secondKillCount = [goodModel.num intValue] - [_goodModel.beyond intValue];
            self.buyNumLabel.text = [NSString stringWithFormat:@"x%d", secondKillCount];
            
            NSString *priceStr = [NSString stringWithFormat:@"￥%@/%@", [goodModel.price priceStr], goodModel.spec];
            NSMutableAttributedString *priceText = [[NSMutableAttributedString alloc] initWithString:priceStr];
            priceText.yy_font = [UIFont fontWithName:kSDPFRegularFont size:11];
            priceText.yy_color = [UIColor colorWithHexString:kSDSecondaryTextColor];
            [priceText yy_setFont:[UIFont fontWithName:kSDPFRegularFont size:9] range:NSMakeRange(0, 1)];
            NSUInteger len = goodModel.spec.length + 1;
            NSUInteger loc = priceStr.length - goodModel.spec.length - 1;
            [priceText yy_setColor:[UIColor colorWithHexString:kSDGrayTextColor] range:NSMakeRange(loc, len)];
            [priceText yy_setFont:[UIFont fontWithName:kSDPFRegularFont size:10] range:NSMakeRange(loc, len)];
            self.priceLabel.attributedText = priceText;
        }
    }
}

- (void)hideTagView:(BOOL)hidden {
    self.secondKillTagLabel.hidden = hidden;
    self.priceTagLabel.hidden = hidden;
    self.beyondLabel.hidden = hidden;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iconIv);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIv);
        make.left.mas_equalTo(self.iconIv.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(-30);
    }];
    
    if (self.tagsView.hidden == NO) {
        [self.tagsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
            make.height.mas_equalTo(14);
        }];
        if ([_goodModel.tags.firstObject integerValue] == SDGoodTypeSecondkill) {
            //            [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.left.mas_equalTo(self.tagsView).mas_equalTo(35);
            //                make.right.mas_equalTo(self.tagsView);
            //                make.centerY.mas_equalTo(self.tagsView);
            //            }];
        }
        if (!self.goodModel.priceActive || [self.goodModel.priceActive isEmpty] || [self.goodModel.priceActive isEqualToString:self.goodModel.price]) {
            [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.tagsView.mas_bottom).mas_equalTo(10);
                make.height.mas_equalTo(14);
            }];
        }else {
            [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.tagsView.mas_bottom).mas_equalTo(10);
                make.height.mas_equalTo(14);
            }];
            
            [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.discountLabel.mas_bottom).mas_equalTo(4);
                make.height.mas_equalTo(10);
            }];
        }
    }else {
        if (!self.goodModel.priceActive || [self.goodModel.priceActive isEmpty] || [self.goodModel.priceActive isEqualToString:self.goodModel.price]) {
            [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
                make.height.mas_equalTo(14);
            }];
        }else {
            [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
                make.height.mas_equalTo(14);
            }];
            
            [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.discountLabel.mas_bottom).mas_equalTo(4);
                make.height.mas_equalTo(10);
            }];
        }
    }
    
    if (self.secondKillTagLabel.hidden == NO) {
        [self.secondKillTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
        }];
        
        [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.secondKillTagLabel.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(self.secondKillTagLabel);
            make.height.mas_equalTo(14);
            make.right.mas_equalTo(self.nameLabel);
        }];
        
        [self.priceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.secondKillTagLabel.mas_bottom).mas_equalTo(8);
        }];
        
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceTagLabel.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(self.priceTagLabel);
            make.height.mas_equalTo(14);
            make.right.mas_equalTo(self.nameLabel);
        }];
        
        [self.beyondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.priceLabel);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.discountLabel);
    }];
}

#pragma mark - lazy
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _lineView;
}

- (UIView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[UIView alloc] init];
    }
    return _tagsView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"该订单限1份优惠，超过以原价计算";
        _tipsLabel.textColor = [UIColor colorWithHexString:kSDRedTextColor];
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _tipsLabel;
}

- (UILabel *)beyondLabel {
    if (!_beyondLabel) {
        _beyondLabel = [[UILabel alloc] init];
        _beyondLabel.font = [UIFont fontWithName:kSDPFBoldFont size:14];
        _beyondLabel.textColor = [UIColor colorWithRGB:0x131413];
        _beyondLabel.hidden = YES;
    }
    return _beyondLabel;
}

- (UILabel *)secondKillTagLabel {
    if (!_secondKillTagLabel) {
        _secondKillTagLabel = [[UILabel alloc] init];
        _secondKillTagLabel.cp_w = 30;
        _secondKillTagLabel.cp_h = 14;
        [_secondKillTagLabel addTagBGWithType:@"4"];
        _secondKillTagLabel.text = @"秒杀";
        _secondKillTagLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _secondKillTagLabel.textColor = [UIColor whiteColor];
        _secondKillTagLabel.textAlignment = NSTextAlignmentCenter;
        _secondKillTagLabel.hidden = YES;
    }
    return _secondKillTagLabel;
}

- (UILabel *)priceTagLabel {
    if (!_priceTagLabel) {
        _priceTagLabel = [[UILabel alloc] init];
        _priceTagLabel.cp_w = 30;
        _priceTagLabel.cp_h = 14;
        [_priceTagLabel addTagBGWithType:@"1"];
        _priceTagLabel.text = @"原价";
        _priceTagLabel.textColor = [UIColor whiteColor];
        _priceTagLabel.font = [UIFont fontWithName:kSDPFLightFont size:10];
        _priceTagLabel.textAlignment = NSTextAlignmentCenter;
        _priceTagLabel.hidden = YES;
    }
    return _priceTagLabel;
}

@end
