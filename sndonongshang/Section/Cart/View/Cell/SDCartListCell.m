//
//  SDCartListCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartListCell.h"
#import "SDCartDataManager.h"

@interface SDCartListCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
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
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@end

@implementation SDCartListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor  = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    self.layer.cornerRadius = 5;
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(5);
//        make.right.bottom.mas_equalTo(-5);
//    }];
    self.countText.enabled = NO;
    self.saledLabel.hidden = YES;
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
    if (self.model.soldOut) {
        self.soldOutImageView.hidden = NO;
        self.contentView.alpha = 0.5;
        self.addBtn.enabled = NO;
        self.reduceBtn.enabled = NO;
        self.chooseBtn.enabled = NO;
    }else{
        self.soldOutImageView.hidden = YES;
        self.contentView.alpha = 1;
        self.addBtn.enabled = YES;
        self.reduceBtn.enabled = YES;
        self.chooseBtn.enabled = YES;
    }
    if (self.model.moreModel.name.length) {
        self.titleLabel.text = self.model.moreModel.name;
    }else{
       self.titleLabel.text = self.model.name;
    }
    
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_model.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    self.tipsLabel.text = @"";
    self.saledLabel.text = [NSString stringWithFormat:@"累计销售%@%@",_model.sold.length ? _model.sold : @"",_model.spec.length ? _model.spec : @""];
    if (self.model.type.integerValue == SDGoodTypeSecondkill && (self.model.moreModel.beyond.integerValue == self.model.moreModel.num.integerValue)) {
        if (_model.moreModel.price.length) {
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.moreModel.price priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
        self.oldPriceLabel.text = @"";
        
        
//        if (_model.price.length && ![_model.price isEqualToString:_model.priceActive]) {
//            self.oldPriceLabel.attributedText = [NSString getLinePriceAttributedString:_model.price priceFontSize:11];
//            self.priceBottom.constant = 28;
//        }else{
//            self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
//            self.priceBottom.constant = 15;
//        }
    }else{
        if (self.model.moreModel.priceActive.length && self.model.moreModel.price.length) {
            if (self.model.moreModel.priceActive.length) {
                self.priceLabel.attributedText = [NSString getPriceAttributedString:[self.model.moreModel.priceActive priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
            }else{
                if (self.model.moreModel.price.length) {
                    self.priceLabel.attributedText = [NSString getPriceAttributedString:[self.model.moreModel.price priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
                }else{
                    self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
                }
            }
            if (self.model.moreModel.price.length && ![self.model.moreModel.price isEqualToString:self.model.moreModel.priceActive]) {
                self.oldPriceLabel.attributedText = [NSString getLinePriceAttributedString:self.model.moreModel.price priceFontSize:11];
                self.priceBottom.constant = 28;
            }else{
                self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
                self.priceBottom.constant = 15;
            }
        }else{
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
                self.oldPriceLabel.attributedText = [NSString getLinePriceAttributedString:_model.price priceFontSize:11];
                self.priceBottom.constant = 28;
            }else{
                self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
                self.priceBottom.constant = 15;
            }
        }
        
        if (self.model.moreModel.type == SDCalculateTypeSecondKillGoodLimit) {
            self.tipsLabel.text = self.model.moreModel.tips;
            self.priceBottom.constant = self.priceBottom.constant + 30;
        }
    }
    
    if ([[self currentTagArray] count]) {
        self.priceTop.constant = 33;
        self.tagView.hidden = NO;
    }else{
        self.priceTop.constant = 10;
        self.tagView.hidden = YES;
    }
    [self setCount:_model.num];
    if (_model.selected.integerValue) {
        self.chooseImageView.image = [UIImage imageNamed:@"cart_good_selected"];
    }else{
        self.chooseImageView.image = [UIImage imageNamed:@"cart_good_unselected"];
    }
    
    [self reloadTagView:_model.tags];
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
- (void)reloadTagView:(NSArray *)tags{
    [self.tagView addTagWithArray:tags discount:self.model.discount];
    
    
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
