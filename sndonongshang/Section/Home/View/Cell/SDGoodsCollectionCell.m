//
//  SDGoodsCollectionCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodsCollectionCell.h"

@interface SDGoodsCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;

@end

#import "SDGoodsCollectionCell.h"

@implementation SDGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodImageView.layer.cornerRadius = 5;
    self.goodImageView.layer.masksToBounds = YES;
    self.goodImageView.layer.borderWidth = 1;
    self.goodImageView.layer.borderColor = [UIColor colorWithHexString:@"0xededed"].CGColor;
}
- (void)setModel:(SDGoodModel *)model{
    _model = model;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_model.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    if (_model.priceActive.length) {
        self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.priceActive priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
    }else{
        if (_model.price.length) {
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.price priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    self.nameLabel.text = _model.name.length ? _model.name : @"";
}
@end
