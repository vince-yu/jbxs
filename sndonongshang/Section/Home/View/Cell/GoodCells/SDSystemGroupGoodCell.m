//
//  SDSystemGroupGoodCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemGroupGoodCell.h"
#import "SDSystemTimeView.h"
#import "SDHomeDataManager.h"

@interface SDSystemGroupGoodCell ()
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
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageTop;
@end

@implementation SDSystemGroupGoodCell
@synthesize commissionLabel = _commissionLabel;
@synthesize priceLabel = _priceLabel;
@synthesize oldPriceLabel = _oldPriceLabel;
@synthesize priceBottom = _priceBottom;
@synthesize soldOutImageView = _soldOutImageView;
@synthesize goodImageView = _goodImageView;
@synthesize goodImageTop = _goodImageTop;

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
    self.describeLabe.text = [NSString stringWithFormat:@"已拼%@%@",_model.sold,_model.spec];
    [self handlePriceLabels];
    [self handleSouldOutAction];
    if ([_model.startTime groupTime] > 0) {
        self.tagTop.constant = 6;
        self.describeLabe.hidden = YES;
    }else{
        self.describeLabe.hidden = NO;
        self.tagTop.constant = 30;
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
- (IBAction)groupBuyAction:(id)sender {
    
    [[SDHomeDataManager sharedInstance].home pushToGoodDetailVC:self.model];
}
@end
