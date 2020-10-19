//
//  SDGoodsCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodsCell.h"
#import "SDCartDataManager.h"

@interface SDGoodsCell ()
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabe;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@end

@implementation SDGoodsCell
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
    
}
- (IBAction)addCartAction:(id)sender {
    switch (self.where) {
            case SDGoodWhereTypeHome:
            [SDStaticsManager umEvent:kgoods_home_add attr:@{@"_id":self.model.goodId,@"name":self.model.name,@"type":self.model.type}];
            break;
            case SDGoodWhereTypeList:
            [SDStaticsManager umEvent:kgoods_add attr:@{@"_id":self.model.goodId,@"name":self.model.name,@"type":self.model.type}];
            break;
        default:
            break;
    }
    [SDCartDataManager addCartGood:self.model needSelectGood:YES completeBlock:^(id  _Nonnull model) {
        [SDToastView HUDWithString:@"添加购物车成功！"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartListTableView object:nil];
    } failedBlock:^(id model){
        
    }];
}
@end
