//
//  SDDiscountGoodCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDiscountGoodCell.h"
#import "SDCartDataManager.h"

@interface SDDiscountGoodCell ()
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabe;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@end

@implementation SDDiscountGoodCell
@synthesize commissionLabel = _commissionLabel;
@synthesize priceLabel = _priceLabel;
@synthesize oldPriceLabel = _oldPriceLabel;
@synthesize priceBottom = _priceBottom;
@synthesize soldOutImageView = _soldOutImageView;
@synthesize goodImageView = _goodImageView;
@synthesize addCartBtn = _addCartBtn;

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
    [self handleCommissionLabel];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_model.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    
    self.describeLabe.text = [NSString stringWithFormat:@"累计销售%@%@",_model.sold.length ? _model.sold : @"0",_model.spec.length ? _model.spec : @""];
    [self handlePriceLabels];
    [self handleSouldOutAction];
    [self reloadTagView:_model.tags];
}
- (void)reloadTagView:(NSArray *)tags{
    [self.tagView addTagWithArray:tags discount:self.model.discount];
}
- (IBAction)addCartAction:(id)sender {
    [SDCartDataManager addCartGood:self.model needSelectGood:YES completeBlock:^(id  _Nonnull model) {
        [SDToastView HUDWithString:@"添加购物车成功！"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartListTableView object:nil];
    } failedBlock:^(id model){
//        [SDToastView HUDWithString:@"添加购物车失败！"];
    }];
}

@end
