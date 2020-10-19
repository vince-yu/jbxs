//
//  SDCartListBarView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartListBarView.h"
#import "SDCartDataManager.h"
#import "SDCartCalculateModel.h"

@interface SDCartListBarView ()
@property (weak, nonatomic) IBOutlet UIButton *allChooseBtn;

@property (weak, nonatomic) IBOutlet UIView *allChooseView;
@property (weak, nonatomic) IBOutlet UIImageView *allChooseImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *freightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnWith;

@end

@implementation SDCartListBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.clipsToBounds = NO;
    [self addSubview:self.freightLabel];
    
    [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_top);
        make.height.mas_equalTo(20);
    }];
    self.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrice:) name:KNotifiCartGoodSelected object:nil];
}
- (IBAction)payAction:(id)sender {
    [SDStaticsManager umEvent:kcart_order];
    if (self.payBlock) {
        self.payBtn.enabled = NO;
        self.payBlock();
    }
    
    //处理逻辑
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"btnClickedOperations");
        self.payBtn.enabled = YES;
    });
}
- (IBAction)allChooseAction:(id)sender {
    BOOL seleted = NO;
    [SDStaticsManager umEvent:kcart_selected];
    UIImage *selectedImage = [UIImage imageNamed:@"cart_good_selected"];
    if ([self.allChooseImageView.image isEqual:selectedImage]) {
        self.allChooseImageView.image = [UIImage imageNamed:@"cart_all_unchoose"];
    }else{
        self.allChooseImageView.image = selectedImage;
        seleted = YES;
    }
    if (self.chooseBlock) {
        self.chooseBlock(seleted);
    }
}
- (void)updatePrice:(NSNotification *)note{
    NSString *total = note.object;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[total priceStr]];
    if (total.floatValue <= 0) {
        self.allChooseImageView.image = [UIImage imageNamed:@"cart_all_unchoose"];
    }
//    NSInteger count = [SDCartDataManager getCartSelectGoodsCount];
//    if (count > 0) {
//        [self.payBtn setTitle:[NSString stringWithFormat:@"去结算(%ld)",count] forState:UIControlStateNormal];
//    }else{
//        [self.payBtn setTitle:@"去结算" forState:UIControlStateNormal];
//    }
    if ([SDCartDataManager cartListGoodsAllSelected]) {
        self.allChooseImageView.image = [UIImage imageNamed:@"cart_good_selected"];
    }else{
        self.allChooseImageView.image = [UIImage imageNamed:@"cart_all_unchoose"];
    }
    SD_WeakSelf;
    
    //算价接口用于刷新购物车UI
    [SDCartDataManager getCartAllGoodsPriceCompleteBlock:^(id  _Nonnull model) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiReloadCartListTableView object:nil];
    } failedBlock:^(id model){
        
    }];
    
    [SDCartDataManager getCartSelectGoodsPriceCompleteBlock:^(id  _Nonnull model) {
        if (![model isKindOfClass:[SDCartCalculateModel class]]) {
            return;
        }
        SDCartCalculateModel *cartModel = (SDCartCalculateModel *)model;
        SD_StrongSelf;
        [self updateViewWithModel:model];
//        [SDCartDataManager sharedInstance].cartCalculateArray = cartModel.more;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiReloadCartListTableView object:nil];
    } failedBlock:^(id model){
        
    }];
    
}
- (void)updateViewWithModel:(SDCartCalculateModel *)model{
    
    SDCartCalculateModel *calModel = (SDCartCalculateModel *)model;
    NSString *total = calModel.totalNum;
    NSString *price = calModel.amount;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[price priceStr]];
    if (![[SDCartDataManager getSelectGoodArray] count]) {
        model.type = SDValuationTypeNomal;
    }
    
    switch (model.type) {
        case SDValuationTypeNomal:
        {
            [self setSureViewWithDelivery:YES deliveryPrice:@"" total:total];
            [self setFreightViewHide:YES freightPrice:@"" differentPrice:@""];
        }
            break;
        case SDValuationTypeNoDelivery:
        {
            [self setSureViewWithDelivery:NO deliveryPrice:calModel.tips.deficiency total:@""];
            [self setFreightViewHide:YES freightPrice:@"" differentPrice:@""];
        }
            break;
        case SDValuationTypeDeliveryOnly:
        {
            [self setSureViewWithDelivery:YES deliveryPrice:@"" total:total];
            [self setFreightViewHide:NO freightPrice:@"" differentPrice:calModel.tips.postage];
        }
            break;
        case SDValuationTypeFreightFree:
        {
            [self setSureViewWithDelivery:YES deliveryPrice:@"" total:total];
            [self setFreightViewHide:NO freightPrice:calModel.tips.reach differentPrice:@""];
        }
            break;
        default:
            break;
    }
    
//    if (total >0 ) {
//        [self.payBtn setTitle:[NSString stringWithFormat:@"去结算(%ld)",total] forState:UIControlStateNormal];
//    }else{
//        [self.payBtn setTitle:@"去结算" forState:UIControlStateNormal];
//    }
}
- (void)setSureViewWithDelivery:(BOOL )delivery deliveryPrice:(NSString *)deliveryPrice total:(NSString *)total{
    if (delivery) {
        self.payBtn.backgroundColor = [UIColor colorWithHexString:@"0x16BC2E"];
        self.payBtn.enabled = YES;
        if (total.integerValue >0 ) {
            [self.payBtn setTitle:[NSString stringWithFormat:@"去结算(%@)",total] forState:UIControlStateNormal];
        }else{
            [self.payBtn setTitle:@"去结算" forState:UIControlStateNormal];
        }
        [self.payBtn.titleLabel sizeToFit];
        CGFloat payWidth = self.payBtn.titleLabel.width + 20;
        if (payWidth <= 125) {
            payWidth = 125;
        }else if (payWidth > 125 && payWidth < SCREEN_WIDTH / 2.0){
            payWidth = payWidth;
        }else if (payWidth >= SCREEN_WIDTH / 2.0){
            payWidth = SCREEN_WIDTH / 2.0;
        }
        self.payBtnWith.constant = payWidth;
//        [self.payBtn setTitle:[NSString stringWithFormat:@"去结算(%@)",total] forState:UIControlStateNormal];
    }else{
        self.payBtn.backgroundColor = [UIColor colorWithHexString:@"0xC3C4C7"];
        self.payBtn.enabled = NO;
        [self.payBtn setTitle:[NSString stringWithFormat:@"还差%@元起配",deliveryPrice] forState:UIControlStateNormal];
        [self.payBtn.titleLabel sizeToFit];
        CGFloat payWidth = self.payBtn.titleLabel.width + 20;
        if (payWidth <= 125) {
            payWidth = 125;
        }else if (payWidth > 125 && payWidth < SCREEN_WIDTH / 2.0){
            payWidth = payWidth;
        }else if (payWidth >= SCREEN_WIDTH / 2.0){
            payWidth = SCREEN_WIDTH / 2.0;
        }
        self.payBtnWith.constant = payWidth;
        
    }
}
- (void)setFreightViewHide:(BOOL )freight freightPrice:(NSString *)freightPrice differentPrice:(NSString *)differentPrice{
    BOOL beforeFreight = self.freightLabel.hidden;
    self.freightLabel.hidden = freight;
    if (freightPrice.length && !differentPrice.length) {
        self.freightLabel.attributedText = [NSString freightStr:YES price:freightPrice priceStrColor:[UIColor colorWithHexString:@"0x16BC2E"] localColor:[UIColor colorWithHexString:@"0x2E302E"]];
        if(self.showFreightBlock && beforeFreight != freight) {
            self.showFreightBlock(NO);
        }
    }else if (!freightPrice.length && differentPrice.length) {
        self.freightLabel.attributedText = [NSString freightStr:NO price:differentPrice priceStrColor:[UIColor colorWithHexString:@"0xF8665A"] localColor:[UIColor colorWithHexString:@"0x2E302E"]];
        if(self.showFreightBlock && beforeFreight != freight) {
            self.showFreightBlock(NO);
        }
    }else{
        self.freightLabel.hidden = YES;
        if(self.showFreightBlock && beforeFreight != freight) {
            self.showFreightBlock(YES);
        }
    }
}
#pragma mark init lazy
- (UILabel *)freightLabel{
    if (!_freightLabel) {
        _freightLabel = [[UILabel alloc] init];
        _freightLabel.backgroundColor = [UIColor colorWithHexString:@"0xE5F9E8"];
        _freightLabel.font = [UIFont fontWithName:kSDPFRegularFont size:10];
        _freightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _freightLabel;
}
@end
