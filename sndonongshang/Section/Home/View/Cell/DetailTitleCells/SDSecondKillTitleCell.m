//
//  SDSecondKillTitleCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSecondKillTitleCell.h"
#import "SDNomalProgress.h"
#import "SDSystemTimeView.h"
#import "SDHomeDataManager.h"

@interface SDSecondKillTitleCell ()<SDSystemTimeViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UILabel *subName;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *couponTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLabelBottom;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLabelTop;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic ,strong) SDSystemTimeView *timeView;
@property (nonatomic ,strong) SDNomalProgress *progress;
@property (nonatomic ,strong) UILabel *killLabel;

@end

@implementation SDSecondKillTitleCell
@synthesize couponView = _couponView;
@synthesize commissionLabel = _commissionLabel;
@synthesize saleLabelBottom = _saleLabelBottom;
@synthesize couponTagView = _couponTagView;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagLabel.text = @"秒杀";
    [self.tagLabel addTagBGWithType:@"4"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCouponView)];
    [self.couponView addGestureRecognizer:tap];
    self.couponView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(175);
        make.left.mas_equalTo(15);
    }];
    
    [self.progressView addSubview:self.progress];
    
    [self.progressView addSubview:self.killLabel];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.progressView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(13);
    }];
    [self.killLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progress.mas_right).offset(10);
        make.top.bottom.equalTo(self.progress);
    }];
    
}
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
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
    
    if (_detailModel.sold.intValue >= _detailModel.totalInventory.intValue) { // 商品库存超限
          self.priceLabel.attributedText = [NSString getAttributeStringGroupPrice:[_detailModel.price priceStr] priceFontSize:18 withOldPrice:@"" oldPriceSize:12 unit:_detailModel.spec];
    }
    
    [self handleCouponsView];
    if ([_detailModel.startTime groupTime] > 0) {
        self.saleLabelTop.constant = 10;
        self.progressView.hidden = YES;
        self.tipsLabel.hidden = NO;
        self.soldLabel.hidden = YES;
        self.tipsLabel.text = [NSString stringWithFormat:@"限售%@%@",_detailModel.totalInventory ? _detailModel.totalInventory : @"" ,_detailModel.spec ? _detailModel.spec : @""];
        self.tipsLabel.textColor = [UIColor colorWithHexString:@"0xF8665A"];
    }else{
        self.tipsLabel.hidden = NO;
        self.progressView.hidden = NO;
        self.soldLabel.hidden = YES;
        self.killLabel.text = [NSString stringWithFormat:@"已抢%@%@",_detailModel.sold.length ? _detailModel.sold : @"0",_detailModel.spec ? _detailModel.spec : @""];
        self.saleLabelTop.constant = 33;
        self.tipsLabel.text = [NSString stringWithFormat:@"每人限购%@%@，超过以原价计算",_detailModel.limitPerUser ? _detailModel.limitPerUser : @"" ,_detailModel.spec ? _detailModel.spec : @""];
        self.tipsLabel.textColor = [UIColor colorWithHexString:@"0xF8665A"];
        
        CGFloat soldCount = _detailModel.sold.floatValue;
        CGFloat totalCount = _detailModel.totalInventory.floatValue;
        if (soldCount > 0 && totalCount > 0 && soldCount / totalCount >= 1.0) {
            self.tipsLabel.text = [NSString stringWithFormat:@"秒杀优惠已抢光，恢复原价购买"];
        }
       
    }
    if (_detailModel.sold.length &&  _detailModel.totalInventory.length) {
        CGFloat soldCount = _detailModel.sold.floatValue;
        CGFloat totalCount = _detailModel.totalInventory.floatValue;
        if (soldCount > 0 && totalCount > 0) {
            self.progress.value = soldCount / totalCount;
        }else{
            self.progress.value = 0;
        }
        
    }else{
        self.progress.value = 0;
    }

    
    self.subName.text = _detailModel.subName.length ? _detailModel.subName : @"";
    [self.timeView setStartTime:_detailModel.startTime endTime:detailModel.endTime];
    [self.timeView fire];
}
- (SDSystemTimeView *)timeView{
    if (!_timeView) {
        _timeView = [[[NSBundle mainBundle] loadNibNamed:@"SDSystemTimeView" owner:nil options:nil] objectAtIndex:0];
        _timeView.delegate =  self;
    }
    return _timeView;
}
- (SDNomalProgress *)progress{
    if (!_progress) {
        _progress = [[SDNomalProgress alloc] initWithFrame:CGRectMake(0, 0, 120, 13)];
    }
    return _progress;
}
- (UILabel *)killLabel{
    if (!_killLabel) {
        _killLabel = [[UILabel alloc] init];
        _killLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _killLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _killLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark timer delegate
- (void)startTimeToEndTime{
    if (self.timerBlock) {
        self.timerBlock();
    }
}
@end
