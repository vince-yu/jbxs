//
//  SDMyOrderShopCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyOrderShopCell.h"

@interface SDMyOrderShopCell ()

@property (nonatomic, weak) UIImageView *shopIv;
@property (nonatomic, weak) UILabel *shopNameLabel;
@property (nonatomic, weak) YYLabel *priceLabel;
@property (nonatomic, weak) YYLabel *discountLabel;

@end

@implementation SDMyOrderShopCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return  self;
}

- (void)initSubView {
    UIImageView *shopIv = [[UIImageView alloc] init];
    shopIv.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:shopIv];
    self.shopIv = shopIv;
    
    UILabel *shopNameLabel = [[UILabel alloc] init];
    shopNameLabel.text = @"RIO鸡尾酒 275ml";
    shopNameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
    shopNameLabel.textColor = [UIColor colorWithRGB:0x333333];
    shopNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.contentView addSubview:shopNameLabel];
    self.shopNameLabel = shopNameLabel;
    
    YYLabel *priceLabel = [[YYLabel alloc] init];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    YYLabel *discountLabel = [[YYLabel alloc] init];
    self.discountLabel = discountLabel;
    [self.contentView addSubview:discountLabel];
}

- (void)setGoodModel:(SDGoodModel *)goodModel {
    _goodModel = goodModel;
    [self.shopIv sd_setImageWithURL:[NSURL URLWithString:goodModel.miniPic]];
    self.shopNameLabel.text = goodModel.name;
     self.priceLabel.attributedText = [NSString getAttributeStringPrice:@"20.88" priceFontSize:18 withOldPrice:@"30.22" oldPriceSize:11 unit:_goodModel.spec];
//    // 设置原价
//    NSString *price = [NSString stringWithFormat:@"￥%@", goodModel.price];
//    NSMutableAttributedString *priceText = [[NSMutableAttributedString alloc] initWithString:price];
//    priceText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:18];
//    priceText.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
//    [priceText yy_setFont:[UIFont fontWithName:kSDPFBoldFont size:11] range:NSMakeRange(0, 1)];
//    self.priceLabel.attributedText = priceText;
//
//    // 设置折扣价格
    NSString *priceActive = [NSString stringWithFormat:@"￥%@", goodModel.priceActive];
    NSMutableAttributedString *discountText = [[NSMutableAttributedString alloc] initWithString:@"￥2080.88"];
    discountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:11];
    discountText.yy_color = [UIColor colorWithHexString:kSDGrayTextColor];
    [discountText yy_setFont:[UIFont fontWithName:kSDPFBoldFont size:16] range:NSMakeRange(1, 7)];
    [discountText yy_setColor:[UIColor colorWithHexString:kSDGreenTextColor] range:NSMakeRange(0, 8)];
    self.priceLabel.attributedText = discountText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.shopIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentView.mas_width);
        make.left.and.top.and.right.mas_equalTo(0);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(19);
    }];
    
//    if (!self.goodModel.priceActive) {
//        self.priceLabel.textAlignment = NSTextAlignmentCenter;
//        self.discountLabel.textAlignment = NSTextAlignmentCenter;
//        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(0);
//            make.centerX.mas_equalTo(self.contentView);
//            make.height.mas_equalTo(19);
//        }];
//    }else {
//        self.priceLabel.textAlignment = NSTextAlignmentRight;
//        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
//            make.height.mas_equalTo(19);
//        }];
//
//        self.discountLabel.textAlignment = NSTextAlignmentLeft;
//        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(0);
//            make.left.mas_equalTo(self.priceLabel.mas_right);
//            make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
//            make.height.mas_equalTo(14);
//        }];
//    }

    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.priceLabel.mas_top).mas_equalTo(-2);
        make.width.mas_lessThanOrEqualTo(self.contentView);
    }];
}

@end
