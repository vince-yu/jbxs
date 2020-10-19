//
//  SDBaseGoodCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseGoodCell.h"

@interface SDBaseGoodCell ()

@end

@implementation SDBaseGoodCell
@synthesize model = _model;
@synthesize timeView = _timeView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.soldOutImageView];
    [self.soldOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.goodImageView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)handleCommissionLabel{
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeGrouper || [SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        self.commissionLabel.hidden = NO;
        NSString *rate = [[NSString stringWithFormat:@"%f",_model.rebateRate.doubleValue * 100] subPriceStr:2];
        self.commissionLabel.text = _model.rebateRate.length ? [NSString stringWithFormat:@"佣金比例：%@%%",rate] : @"佣金比例：0%";
    }else{
        self.commissionLabel.hidden = YES;
    }
}
- (void)handlePriceLabels{
    if (self.model.priceActive.length) {
        self.priceLabel.attributedText = [NSString getPriceAttributedString:[self.model.priceActive priceStr] priceFontSize:14 unit:self.model.spec unitSize:10];
    }else{
        if (self.model.price.length) {
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[self.model.price priceStr] priceFontSize:14 unit:self.model.spec unitSize:10];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    if (self.model.price.length && ![self.model.price isEqualToString:_model.priceActive]) {
        self.oldPriceLabel.attributedText = [NSString getLinePriceAttributedString:[self.model.price priceStr] priceFontSize:11];
        self.priceBottom.constant = 30;
    }else{
        self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        self.priceBottom.constant = 15;
    }
}
- (void)handleSouldOutAction{
    if (self.model.type.integerValue == SDGoodTypeNamoal || self.model.type.integerValue == SDGoodTypeDiscount) {
        if (_model.soldOut) {
            self.soldOutImageView.hidden = NO;
            self.contentView.alpha = 0.5;
            self.addCartBtn.enabled = NO;
        }else{
            self.soldOutImageView.hidden = YES;
            self.addCartBtn.enabled = YES;
            self.contentView.alpha = 1;
        }
    }else if (self.model.type.integerValue == SDGoodTypeGroup){
        if (_model.soldOut) {
            self.soldOutImageView.hidden = NO;
            self.contentView.alpha = 0.5;
            self.goodImageTop.constant = 15;
            self.progressView.hidden = YES;
            self.timeView.hidden = YES;
        }else{
            self.soldOutImageView.hidden = YES;
            self.contentView.alpha = 1;
            self.goodImageTop.constant = 55;
            self.progressView.hidden = NO;
            self.timeView.hidden = NO;
        }
    }else if (self.model.type.integerValue == SDGoodTypeSecondkill){
        if (_model.soldOut) {
            self.soldOutImageView.hidden = NO;
            self.contentView.alpha = 0.5;
            self.goodImageTop.constant = 15;
            self.progressView.hidden = YES;
            self.timeView.hidden = YES;
            self.progressView.hidden = YES;
        }else{
            self.soldOutImageView.hidden = YES;
            self.contentView.alpha = 1;
            self.goodImageTop.constant = 55;
            self.timeView.hidden = NO;
        }
    }
    
}
@end
