//
//  SDSystemAddView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemAddView.h"
#import "SDCartDataManager.h"
#import "SDSecondKillView.h"

@interface SDSystemAddView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (weak, nonatomic) IBOutlet UIView *feightView;
@property (weak, nonatomic) IBOutlet UILabel *feightTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *feightLabel;
@property (weak, nonatomic) IBOutlet UIView *sureView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (nonatomic ,assign) NSInteger count;
/** 秒杀view */
@property (nonatomic, strong) SDSecondKillView *secondKillView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;

@end

@implementation SDSystemAddView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.sureBtnHeight.constant = 55 + kBottomSafeHeight;
    self.contentViewHeight.constant = 290 + kBottomSafeHeight;
    self.feightTagLabel.layer.cornerRadius = 7.0;
    self.feightTagLabel.clipsToBounds = YES;
    self.feightTagLabel.hidden = YES;
    self.feightLabel.text = @"";
}

- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    self.titleView.text = _detailModel.name;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    if (_detailModel.type.integerValue == SDGoodTypeGroup) {
        self.soldLabel.text = [NSString stringWithFormat:@"已拼%@%@",_detailModel.sold,_detailModel.spec];
    }else if (_detailModel.type.integerValue == SDGoodTypeNamoal || _detailModel.type.integerValue == SDGoodTypeDiscount){
        self.soldLabel.text = [NSString stringWithFormat:@"累计销售%@%@",_detailModel.sold,_detailModel.spec];
    }else{
        self.soldLabel.text = [NSString stringWithFormat:@"已抢%@%@",_detailModel.sold,_detailModel.spec];
    }
    if (_detailModel.priceActive.length) {
        self.priceLabel.attributedText = [NSString getPriceAttributedString:[_detailModel.priceActive priceStr] priceFontSize:14 unit:_detailModel.spec unitSize:10];
    }else{
        if (_detailModel.price.length) {
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[_detailModel.price priceStr] priceFontSize:14 unit:_detailModel.spec unitSize:10];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    if (_detailModel.price.length && ![_detailModel.price isEqualToString:_detailModel.priceActive]) {
        self.oldPriceLabel.attributedText = [NSString getLinePriceAttributedString:[_detailModel.price priceStr] priceFontSize:11];
    }else{
        self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
    self.countLabel.text = @"1";
    self.count = 1;
    if (![self.detailModel.type isEqualToString:@"4"]) {
        [self updateViewLayout];
        return;
    }
    if (!self.secondKillView.superview) {
        [self.contentView addSubview:self.secondKillView];
    }
    self.secondKillView.spec = _detailModel.spec;
    self.secondKillView.limitPerUser = _detailModel.limitPerUser;
    self.secondKillView.hidden = YES;
    [self.secondKillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.soldLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(52);
    }];
    [self updateViewLayout];
}

- (void)updateViewLayout {
    if (self.moreModel) {
        [self updateViewWithModel:_moreModel];
        [self showAnimation];
        return;
    }
    [self valuationAction:@"1" completeBlock:^{
        
    } faltureBlock:^{
        
    }];
    [self showAnimation];
}

//- (void)setMoreModel:(SDCartCalculateModel *)moreModel {
//    _moreModel = moreModel;
//    [self updateViewWithModel:_moreModel];
//    [self showAnimation];
//}

- (void)showAnimation{
//    CABasicAnimation *animation =
//    [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.duration = 0.25; // 动画持续时间
//    animation.repeatCount = 1; // 不重复
//    animation.timingFunction =
//    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2.0, self.contentView.height / 2.0)]; // 起始点
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2.0,self.contentView.height / 2.0)]; // 终了点
//    [self.contentView.layer addAnimation:animation forKey:@"move-layer"];
    self.bgView.alpha = 0;
    int h = self.contentViewHeight.constant;
    self.contentViewHeight.constant = 0;
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentViewHeight.constant = h ;
        self.bgView.alpha = 0.6;
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)sureAction:(id)sender {
    if (self.pushToOderBlock) {
        self.pushToOderBlock(self.countLabel.text.integerValue);
    }
    [self removeFromSuperview];
}

- (IBAction)reduceAction:(id)sender {
    NSInteger count = self.countLabel.text.integerValue;
    if (count > 1) {
        count --;
        SD_WeakSelf;
        [self valuationAction:[NSString stringWithFormat:@"%ld",count] completeBlock:^{
            SD_StrongSelf;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
            self.count = count;
        } faltureBlock:^{
            
            
        }];
        
    }
}
- (IBAction)closeAction:(id)sender {
    SD_WeakSelf;
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        SD_StrongSelf
        self.bgView.alpha = 0;
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, self.contentView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)addAction:(id)sender {
    NSInteger count = self.countLabel.text.integerValue;
    if (count < 99 ) {
        count ++;
        SD_WeakSelf;
        [self valuationAction:[NSString stringWithFormat:@"%ld",count] completeBlock:^{
            SD_StrongSelf;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
            self.count = count;
        } faltureBlock:^{
            
        
        }];
    }else{
        [SDToastView HUDWithString:@"超过最大购买数量，请分多次购买!"];
    }
}
- (void)setSureViewWithDelivery:(BOOL )delivery deliveryPrice:(NSString *)deliveryPrice{
    if (delivery) {
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"0x16BC2E"];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"0xC3C4C7"];
        [self.sureBtn setTitle:[NSString stringWithFormat:@"还差%@元起配",deliveryPrice] forState:UIControlStateNormal];
        self.sureBtn.enabled = NO;
    }
}
- (void)setFreightViewHide:(BOOL )freight freightPrice:(NSString *)freightPrice differentPrice:(NSString *)differentPrice{
    self.feightView.hidden = freight;
    self.feightTagLabel.hidden = freight;
    if (freightPrice.length && !differentPrice.length) {
        self.feightLabel.attributedText = [NSString freightStr:YES price:freightPrice priceStrColor:[UIColor colorWithHexString:@"0xF8665A"] localColor:[UIColor colorWithHexString:@"0x848487"]];
    }else if (!freightPrice.length && differentPrice.length) {
        self.feightLabel.attributedText = [NSString freightStr:NO price:differentPrice priceStrColor:[UIColor colorWithHexString:@"0xF8665A"] localColor:[UIColor colorWithHexString:@"0x848487"]];
    }else{
        self.feightView.hidden = YES;
        self.feightTagLabel.hidden = YES;
    }
    if (!self.feightView.hidden) {
        self.imageTop.constant = 45;
        self.contentViewHeight.constant = 300 + kBottomSafeHeight;

    }else{
        self.imageTop.constant = 20;

        self.contentViewHeight.constant = 275 + kBottomSafeHeight;
    }
}
- (void)valuationAction:(NSString *)count completeBlock:(void (^)(void))completeBlock faltureBlock:(void (^)(void))faltureBlock{
    SD_WeakSelf;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    SDCartCalculateRequestModel *updateModel = [[SDCartCalculateRequestModel alloc] init];
    updateModel.goodId = self.detailModel.goodId;
    updateModel.type = self.detailModel.type;
    updateModel.targetNum = count;
    [array addObject:[updateModel mj_keyValues]];
    [SDCartDataManager getAddViewSelectGoodsPriceWith:[array mj_JSONString] completeBlock:^(id  _Nonnull model) {
        if (![model isKindOfClass:[SDCartCalculateModel class]]) {
            return;
        }
        SD_StrongSelf;
        [self updateViewWithModel:model];
        if (self.updateDetailModelBlock) {
            self.updateDetailModelBlock(model);
        }
        if (completeBlock) {
            completeBlock();
        }
        
    } failedBlock:^(id model){
        if (faltureBlock) {
            faltureBlock();
        }
    }];
}

- (void)getGoodCalculateData {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    SDCartCalculateRequestModel *updateModel = [[SDCartCalculateRequestModel alloc] init];
    updateModel.goodId = self.detailModel.goodId;
    updateModel.type = self.detailModel.type;
    updateModel.targetNum = @"1";
    [array addObject:[updateModel mj_keyValues]];
    SD_WeakSelf;
    [SDCartDataManager getAddViewSelectGoodsPriceWith:[array mj_JSONString] completeBlock:^(id  _Nonnull model) {
        if (![model isKindOfClass:[SDCartCalculateModel class]]) {
            return;
        }
        SD_StrongSelf;
        [self updateViewWithModel:model];
        if (self.updateDetailModelBlock) {
            self.updateDetailModelBlock(model);
        }
    } failedBlock:^(id model){
    
    }];
}

/** 设置商品价格 */
- (void)setupGoodPrice:(SDCartCalculateModel *)model {
    SDCartCalculateMoreModel *calculateModel = model.more.firstObject;
    if (!calculateModel) {
        return;
    }
    if (calculateModel.priceActive.length) {
        self.priceLabel.attributedText = [NSString getPriceAttributedString:[calculateModel.priceActive priceStr] priceFontSize:14 unit:calculateModel.spec unitSize:10];
    }else{
        if (calculateModel.price.length) {
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[calculateModel.price priceStr] priceFontSize:14 unit:calculateModel.spec unitSize:10];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    if (calculateModel.price.length && ![calculateModel.price isEqualToString:calculateModel.priceActive]) {
        self.oldPriceLabel.attributedText = [NSString getLinePriceAttributedString:[calculateModel.price priceStr] priceFontSize:11];
    }else{
        self.oldPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
}
- (void)updateViewWithModel:(SDCartCalculateModel *)model{
    
    SDCartCalculateModel *calModel = (SDCartCalculateModel *)model;
//    NSString *total = calModel.totalNum;
//    NSString *price = calModel.amount;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[price priceStr]];
    
    
    switch (model.type) {
        case SDValuationTypeNomal:
        {
            [self setSureViewWithDelivery:YES deliveryPrice:@""];
            [self setFreightViewHide:YES freightPrice:@"" differentPrice:@""];
        }
            break;
        case SDValuationTypeNoDelivery:
        {
            [self setSureViewWithDelivery:NO deliveryPrice:calModel.tips.deficiency];
            [self setFreightViewHide:YES freightPrice:@"" differentPrice:@""];
        }
            break;
        case SDValuationTypeDeliveryOnly:
        {
            [self setSureViewWithDelivery:YES deliveryPrice:@""];
            [self setFreightViewHide:NO freightPrice:@"" differentPrice:calModel.tips.postage];
        }
            break;
        case SDValuationTypeFreightFree:
        {
            [self setSureViewWithDelivery:YES deliveryPrice:@""];
            [self setFreightViewHide:NO freightPrice:calModel.tips.reach differentPrice:@""];
        }
            break;
        default:
            break;
    }
    SDCartCalculateMoreModel *moreModel = model.more.firstObject;
    if (moreModel && [moreModel.name isNotEmpty]) {
        self.titleView.text = moreModel.name;
    }
    if (![self.detailModel.type isEqualToString:@"4"]) {
        [self setupGoodPrice:model];
        return;
    }
    if (model.more.count == 0) {
        return;
    }
    moreModel.spec = self.detailModel.spec;
    self.residueLabel.hidden = YES;
    if (moreModel.type == SDCalculateTypeSecondKillGoodNone || moreModel.type == SDCalculateTypeSecondKillNomal || moreModel.type == SDCalculateTypeSecondKillGoodLimit) {
        self.priceLabel.hidden = NO;
        self.oldPriceLabel.hidden = NO;
        self.secondKillView.hidden = YES;
        self.countViewTopConstraint.constant = 52;
        if (moreModel.type == SDCalculateTypeSecondKillGoodNone) {
            self.oldPriceLabel.hidden = YES;
            self.priceLabel.attributedText = [NSString getPriceAttributedString:[moreModel.price priceStr] priceFontSize:14 unit:_detailModel.spec unitSize:10];
        }
        if (moreModel.type == SDCalculateTypeSecondKillNomal || moreModel.type == SDCalculateTypeSecondKillGoodLimit) {
            [self setupGoodPrice:model];
        }
        
        if (moreModel.type == SDCalculateTypeSecondKillGoodLimit) {
            [self setupGoodPrice:model];
            self.residueLabel.text = [NSString stringWithFormat:@"剩余优惠%@%@", moreModel.ableCheap, moreModel.spec];
            self.residueLabel.hidden = NO;
            self.countViewTopConstraint.constant = 75;
            self.contentViewHeight.constant += 10;
        }
        return;
    }
    self.priceLabel.hidden = YES;
    self.oldPriceLabel.hidden = YES;
    self.secondKillView.hidden = NO;
    self.secondKillView.spec = _detailModel.spec;
    self.secondKillView.limitPerUser = _detailModel.limitPerUser;
    self.secondKillView.model = model;
    self.countViewTopConstraint.constant = 75;
    self.contentViewHeight.constant += 10;
}

- (SDSecondKillView *)secondKillView {
    if (!_secondKillView) {
        _secondKillView = [[SDSecondKillView alloc] init];
    }
    return _secondKillView;
}

@end
