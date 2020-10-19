//
//  SDSecondKillGoodCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSecondKillGoodCell.h"
#import "SDSystemTimeView.h"
#import "SDHomeDataManager.h"
#import "SDNomalProgress.h"

@interface SDSecondKillGoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabe;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describeLeft;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagTop;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic ,strong) SDNomalProgress *progress;
@property (nonatomic ,strong) UILabel *killLabel;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageTop;
@end

@implementation SDSecondKillGoodCell
@synthesize commissionLabel = _commissionLabel;
@synthesize priceLabel = _priceLabel;
@synthesize oldPriceLabel = _oldPriceLabel;
@synthesize priceBottom = _priceBottom;
@synthesize soldOutImageView = _soldOutImageView;
@synthesize goodImageView = _goodImageView;
@synthesize goodImageTop = _goodImageTop;
@synthesize progressView = _progressView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(21);
    }];
    self.groupBuyBtn.layer.cornerRadius = 12.5;
    self.groupBuyBtn.layer.masksToBounds = YES;
    self.progressView.hidden = YES;
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(SDGoodModel *)model{
    _model = model;
    self.nameLabel.text = _model.name;
    [self handleCommissionLabel];
    [self handleSouldOutAction];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:_model.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
    
    self.describeLabe.text = [NSString stringWithFormat:@"限售%@%@",_model.totalInventory.length ? _model.totalInventory : @"0",_model.spec.length ? _model.spec : @""];
    [self handlePriceLabels];
    if (_model.sold.intValue >= _model.totalInventory.intValue) { // 商品超限
        self.priceLabel.attributedText = [NSString getPriceAttributedString:[_model.price priceStr] priceFontSize:14 unit:_model.spec unitSize:10];
        self.priceBottom.constant = 15;
        self.oldPriceLabel.hidden = YES;
    }else {
        self.oldPriceLabel.hidden = NO;
    }
    
    
    if (_model.sold.length &&  _model.totalInventory.length) {
        CGFloat soldCount = _model.sold.floatValue;
        CGFloat totalCount = _model.totalInventory.floatValue;
        if (soldCount > 0 && totalCount > 0) {
            self.progress.value = soldCount / totalCount;
        }else{
            self.progress.value = 0;
        }
        
    }else{
        self.progress.value = 0;
    }
    
    if ([_model.startTime groupTime] > 0 || _model.soldOut) {
        self.tagTop.constant = 10;
        self.describeLabe.hidden = NO;
        self.progressView.hidden = YES;
        self.tagTop.constant = 24;
    }else{
        self.describeLabe.hidden = YES;
        self.progressView.hidden = NO;
        self.killLabel.text = [NSString stringWithFormat:@"已抢%@%@",_model.sold.length ? _model.sold : @"0",_model.spec.length ? _model.spec : @""];
        self.tagTop.constant = 27;
    }
    [self reloadTagView:_model.tags];
    [self.timeView setStartTime:_model.startTime endTime:_model.endTime];
    [self.timeView fire];
}
- (void)reloadTagView:(NSArray *)tags{
    [self.tagView addTagWithArray:tags discount:self.model.discount];
    
}
- (SDSystemTimeView *)timeView{
    if (!_timeView) {
        _timeView = [[[NSBundle mainBundle] loadNibNamed:@"SDSystemTimeView" owner:nil options:nil] objectAtIndex:0];
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
- (IBAction)groupBuyAction:(id)sender {
    [[SDHomeDataManager sharedInstance].home pushToGoodDetailVC:self.model];
}

@end
