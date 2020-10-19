//
//  SDDiscountTitleCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDiscountTitleCell.h"
#import "SDHomeDataManager.h"

@interface SDDiscountTitleCell ()

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

@implementation SDDiscountTitleCell

@synthesize couponView = _couponView;
@synthesize commissionLabel = _commissionLabel;
@synthesize saleLabelBottom = _saleLabelBottom;
@synthesize couponTagView = _couponTagView;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.tagLabel addTagBGWithType:@"3"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCouponView)];
    [self.couponView addGestureRecognizer:tap];
    self.couponView.userInteractionEnabled = YES;
    
    
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    self.tagLabel.text = [NSString stringWithFormat:@"%@折",_detailModel.discount.length ? [_detailModel.discount subPriceStr:2] : @"打"];
    [self.tagLabel sizeToFit];
    [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.tagLabel.width + 10);
    }];
    self.tagLabel.width = self.tagLabel.width + 10;
    [self.tagLabel addTagBGWithType:@"3"];
//    self.tagLabel.text = [NSString stringWithFormat:@"%@折",_detailModel.discount.length ? _detailModel.discount : @"打"];
    
    self.nameLabel.text = _detailModel.name;
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
    [self handleCouponsView];
    self.soldLabel.text = [NSString stringWithFormat:@"累计销售%@%@",_detailModel.sold ? _detailModel.sold : @"" ,_detailModel.spec ? _detailModel.spec : @"0"];
    self.subName.text = _detailModel.subName.length ? _detailModel.subName : @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
