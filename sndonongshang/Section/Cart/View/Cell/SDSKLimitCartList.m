//
//  SDSKLimitCartList.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSKLimitCartList.h"
#import "SDCartDataManager.h"

@interface SDSKLimitCartList ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *saledLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invalidImageView;
@property (weak, nonatomic) IBOutlet UITextField *countText;
@property (weak, nonatomic) IBOutlet UIImageView *reduceImage;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceTag;
@property (weak, nonatomic) IBOutlet UILabel *secondPriceTag;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

@end


@implementation SDSKLimitCartList

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor  = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    //    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.mas_equalTo(5);
    //        make.right.bottom.mas_equalTo(-5);
    //    }];
    self.countText.enabled = NO;
    self.saledLabel.hidden = YES;
    [self.oldPriceTag addTagBGWithType:@"1"];
    [self.secondPriceTag addTagBGWithType:@"4"];
    [self addSubview:self.soldOutImageView];
    [self.soldOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.goodImageView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(SDGoodModel *)model{
    _model = model;
    switch (_model.status.integerValue) {
        case SDCartListCellTypeNomal:
        {
            self.invalidImageView.hidden = YES;
            
            self.addImage.image = [UIImage imageNamed:@"cart_add_nomal"];
            self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            if (_model.num.integerValue == 1) {
                self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_notedit"];
            }else{
                self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_nomal"];
            }
        }
            break;
        case SDCartListCellTypeInvalid:
        {
            self.invalidImageView.hidden = NO;
            self.invalidImageView.image = [UIImage imageNamed:@"cart_list_invalid"];
            self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_invalid"];
            self.addImage.image = [UIImage imageNamed:@"cart_add_invalid"];
            self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
        }
            break;
        case SDCartListCellTypeSupply:
        {
            self.invalidImageView.hidden = NO;
            self.invalidImageView.image = [UIImage imageNamed:@"cart_list_supply"];
            self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_invalid"];
            self.addImage.image = [UIImage imageNamed:@"cart_add_invalid"];
            self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
        }
            break;
        default:
            break;
    }
    if (self.model.moreModel.name.length) {
        self.titleLabel.text = self.model.moreModel.name;
    }else{
        self.titleLabel.text = self.model.name;
    }
    if (self.model.soldOut) {
        self.soldOutImageView.hidden = NO;
        self.contentView.alpha = 0.4;
        self.addBtn.enabled = NO;
        self.addBtn.enabled = NO;
    }else{
        self.soldOutImageView.hidden = YES;
        self.contentView.alpha = 1;
        self.addBtn.enabled = YES;
        self.addBtn.enabled = YES;
    }
//    self.model.moreModel.spec = self.model.spec;
    self.tipsLabel.text = self.model.moreModel.tips;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_model.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    
    self.saledLabel.text = [NSString stringWithFormat:@"累计销售%@%@",_model.sold.length ? _model.sold : @"",_model.spec.length ? _model.spec : @""];
    NSString *activeCount = [NSString stringWithFormat:@"%d",_model.moreModel.num.intValue - _model.moreModel.beyond.intValue];
    if (_model.moreModel.priceActive.length) {
        self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.moreModel.priceActive priceStr] priceFontSize:14 count:activeCount countSize:10];
    }else{
        if (_model.moreModel.price.length) {
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.moreModel.price priceStr] priceFontSize:14 count:activeCount countSize:10];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    
    if (_model.moreModel.price.length && ![_model.moreModel.price isEqualToString:_model.moreModel.priceActive]) {
        self.oldPriceLabel.attributedText = [NSString getOldPriceAttributedString:_model.moreModel.price priceFontSize:11 count:_model.moreModel.beyond countSize:10];
        self.priceBottom.constant = 28;
    }else{
        self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        self.priceBottom.constant = 15;
    }
    [self setCount:_model.num];
    if (_model.selected.integerValue) {
        self.chooseImageView.image = [UIImage imageNamed:@"cart_good_selected"];
    }else{
        self.chooseImageView.image = [UIImage imageNamed:@"cart_good_unselected"];
    }
}
- (NSArray *)currentTagArray{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *str in self.model.tags) {
        if (str.integerValue != 1) {
            [array addObject:str];
        }
    }
    return array;
}
- (void)setCount:(NSString *)str{
    if (self.model.status.integerValue == SDCartListCellTypeNomal) {
        if (str.integerValue == 1) {
            self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_notedit"];
        }else{
            self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_nomal"];
        }
    }
    self.countText.text = str;
}
#pragma mark action
- (IBAction)reduceAction:(id)sender {
    if (self.model.status.integerValue != SDCartListCellTypeNomal) {
        return;
    }
    if (self.countText.text.integerValue == 1) {
        [SDToastView HUDWithString:@"最小值为1！"];
        return;
    }
    SD_WeakSelf;
    [SDCartDataManager reduceCartGood:self.model completeBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
//        [SDToastView HUDWithString:@"修改成功！"];
        [self reduceImageChange];
    } failedBlock:^(id model){
        
    }];
}
- (void)reduceImageChange{
    NSInteger count = self.countText.text.integerValue;
    if (count > 2) {
        count --;
    }else{
        count = 1;
        self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_notedit"];
    }
    self.countText.text = [NSString stringWithFormat:@"%ld",count];
    self.model.num = [NSString stringWithFormat:@"%ld",count];
}
- (void)addImageChange{
    NSInteger count = self.countText.text.integerValue;
    count ++;
    if (count == 2) {
        self.reduceImage.image = [UIImage imageNamed:@"cart_reduce_nomal"];
    }
    self.countText.text = [NSString stringWithFormat:@"%ld",count];
    self.model.num = [NSString stringWithFormat:@"%ld",count];
}
- (IBAction)addAction:(id)sender {
    if (self.model.status.integerValue != SDCartListCellTypeNomal) {
        return;
    }
    if (self.countText.text.integerValue >= 99) {
        [SDToastView HUDWithString:@"超过最大购买数量，请分多次购买！"];
        return;
    }
    SD_WeakSelf;
    [SDCartDataManager addCartGood:self.model needSelectGood:NO completeBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
//        [SDToastView HUDWithString:@"修改成功！"];
        [self addImageChange];
    } failedBlock:^(id model){
        
    }];
}
- (BOOL )textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (IBAction)chooseAction:(id)sender {
    if (self.model.status.integerValue != SDCartListCellTypeNomal) {
        return;
    }
    UIImage *selectedImage = [UIImage imageNamed:@"cart_good_selected"];
    if ([self.chooseImageView.image isEqual:selectedImage]) {
        [[SDCartDataManager sharedInstance] updateCartGoodSeleted:[NSArray arrayWithObject:self.model] seleted:NO];
        self.chooseImageView.image = [UIImage imageNamed:@"cart_good_unselected"];
    }else{
        [[SDCartDataManager sharedInstance] updateCartGoodSeleted:[NSArray arrayWithObject:self.model] seleted:YES];
        self.chooseImageView.image = selectedImage;
    }
}

@end
