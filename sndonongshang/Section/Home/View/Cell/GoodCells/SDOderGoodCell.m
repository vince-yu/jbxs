//
//  SDOderGoodCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOderGoodCell.h"
#import "SDCartDataManager.h"

@interface  SDOderGoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@end

@implementation SDOderGoodCell
@synthesize commissionLabel = _commissionLabel;
@synthesize priceLabel = _priceLabel;
@synthesize oldPriceLabel = _oldPriceLabel;
@synthesize priceBottom = _priceBottom;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(SDGoodModel *)model{
    _model = model;
    self.nameLabel.text = _model.name;
    self.countLabel.text = _model.num.length ? [NSString stringWithFormat:@"x%@",model.num] : @"x0";
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_model.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    if (_model.beyond.integerValue == _model.num.integerValue) {
//        if (_model.priceActive.length) {
//            self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.priceActive priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
//        }else{
            if (_model.price.length) {
                self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.price priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
            }else{
                self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
            }
//        }
        self.priceBottom.constant = 15;
        self.oldPriceLabel.text = @"";
    }else{
        [self handlePriceLabels];
    }
    
    if (_model.tags.count) {
        self.priceTop.constant = 34;
        self.tagView.hidden = NO;
    }else{
        self.priceTop.constant = 10;
        self.tagView.hidden = YES;
    }
    [self.tagView addTagWithArray:_model.tags discount:self.model.discount];
}

@end
