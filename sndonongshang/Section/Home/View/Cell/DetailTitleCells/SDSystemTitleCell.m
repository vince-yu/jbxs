//
//  SDSystemTitleCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemTitleCell.h"
#import "SDHomeDataManager.h"

@interface SDSystemTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UILabel *subName;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *couponTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLabelBottom;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

@end

@implementation SDSystemTitleCell
@synthesize couponView = _couponView;
@synthesize commissionLabel = _commissionLabel;
@synthesize saleLabelBottom = _saleLabelBottom;
@synthesize couponTagView = _couponTagView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCouponView)];
    [self.couponView addGestureRecognizer:tap];
    self.couponView.userInteractionEnabled = YES;
}
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    self.nameLabel.text = _detailModel.name;
    [self.tagLabel addTagBGWithType:self.detailModel.type];
    [self handleCommissionLabel];
    
    if (_detailModel.priceActive.length) {
        self.priceLabel.attributedText = [NSString getAttributeStringGroupPrice:[_detailModel.priceActive priceStr] priceFontSize:18 withOldPrice:[_detailModel.price priceStr] oldPriceSize:12 unit:_detailModel.spec];
    }else{
        if (_detailModel.price.length) {
            self.priceLabel.attributedText = [NSString getAttributeStringGroupPrice:[_detailModel.price priceStr] priceFontSize:18 withOldPrice:@"" oldPriceSize:12 unit:_detailModel.spec];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    if ([_detailModel.startTime groupTime] > 0) {
        self.soldLabel.hidden = YES;
    }else{
        self.soldLabel.hidden = NO;
    }
    [self handleCouponsView];
    if (self.detailModel.type.integerValue == SDGoodTypeSecondkill) {
        self.soldLabel.text = [NSString stringWithFormat:@"已抢%@%@",_detailModel.sold ? _detailModel.sold : @"" ,_detailModel.spec ? _detailModel.spec : @""];
    }else{
        self.soldLabel.text = [NSString stringWithFormat:@"已拼%@%@",_detailModel.sold ? _detailModel.sold : @"" ,_detailModel.spec ? _detailModel.spec : @""];
    }
    
    self.subName.text = _detailModel.subName.length ? _detailModel.subName : @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
