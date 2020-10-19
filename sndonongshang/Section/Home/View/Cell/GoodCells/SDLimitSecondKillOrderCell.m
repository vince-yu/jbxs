//
//  SDLimitSecondKillOrderCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLimitSecondKillOrderCell.h"

@interface SDLimitSecondKillOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@property (weak, nonatomic) IBOutlet UILabel *secondkillTag;
@property (weak, nonatomic) IBOutlet UILabel *oldContLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceTag;
@end

@implementation SDLimitSecondKillOrderCell
@synthesize commissionLabel = _commissionLabel;
@synthesize priceLabel = _priceLabel;
@synthesize oldPriceLabel = _oldPriceLabel;
@synthesize priceBottom = _priceBottom;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.oldPriceTag addTagBGWithType:@"1"];
    [self.secondkillTag addTagBGWithType:@"4"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(SDGoodModel *)model{
    _model = model;
    self.nameLabel.text = _model.name;
    self.countLabel.text = _model.num.length ? [NSString stringWithFormat:@"x%d",model.num.intValue - model.beyond.intValue] : @"x0";
    self.oldContLabel.text = _model.beyond.length ? [NSString stringWithFormat:@"x%@",model.beyond] : @"x0";
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
    if (_model.price.length && ![_model.price isEqualToString:_model.priceActive]) {
        self.oldPriceLabel.attributedText = [NSString getOldPriceAttributedString:_model.price priceFontSize:11 unit:_model.spec unitSize:10];
//        self.priceBottom.constant = 30;
    }else{
        self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
//        self.priceBottom.constant = 30;
    }
}

@end
