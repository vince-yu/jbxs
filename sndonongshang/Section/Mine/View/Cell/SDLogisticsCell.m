//
//  SDLogisticsCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLogisticsCell.h"
#import "SDLineView.h"

@interface SDLogisticsCell ()
@property (nonatomic ,strong) UILabel *timerLabel;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UILabel *addressLabel;

@property (nonatomic ,strong) UIImageView *centerImageView;
@property (nonatomic ,strong) SDLineView *pointImageView;
@end

@implementation SDLogisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self.contentView addSubview:self.timerLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.addressLabel];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(75);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timerLabel.mas_right).offset(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(10);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(25);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-15);
    }];

    [self.lineView addSubview:self.pointImageView];
    [self.lineView addSubview:self.centerImageView];

    [self.pointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self.lineView);
        make.top.equalTo(self.centerImageView.mas_bottom);
        make.bottom.equalTo(self.lineView);
    }];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.center.equalTo(self.lineView);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark Lazy
- (UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _timerLabel.textColor = [UIColor colorWithHexString:@"0xAFAFB0"];
        _timerLabel.numberOfLines = 2;
    }
    return _timerLabel;
}
- (void)setModel:(SDLogisticsModel *)model{
    _model = model;
    NSString *timeStr = [NSString stringWithFormat:@"%@\n%@ %@",[_model.time convertDateStringWithTimeStr:@"yyyy.MM.dd"],[_model.time convertDateStringWithTimeStr:@"HH:mm"],[_model.time weekdayStringFromDate]];
    self.timerLabel.text = timeStr;
    
    self.addressLabel.text = _model.desc;
    [self.contentView layoutIfNeeded];
//    [self.timerLabel sizeToFit];
    if (_model.status == SDLogisticsStatusStart) {
        self.centerImageView.image = [UIImage imageNamed:@"order_logistics_start"];
        [self.pointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerX.equalTo(self.lineView);
            make.top.equalTo(self.lineView);
            make.bottom.equalTo(self.centerImageView.mas_top);
        }];
        self.timerLabel.textColor = [UIColor colorWithHexString:@"0xAFAFB0"];
        self.addressLabel.textColor = [UIColor colorWithHexString:@"0xAFAFB0"];
    }else if (_model.status == SDLogisticsStatusFinal){
        self.centerImageView.image = [UIImage imageNamed:@"order_logistics_final"];
        [self.pointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerX.equalTo(self.lineView);
            make.top.equalTo(self.centerImageView.mas_bottom);
            make.bottom.equalTo(self.lineView);
        }];
        self.timerLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
        self.addressLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }else {
        self.timerLabel.textColor = [UIColor colorWithHexString:@"0xAFAFB0"];
        self.addressLabel.textColor = [UIColor colorWithHexString:@"0xAFAFB0"];
        self.centerImageView.image = [UIImage imageNamed:@"order_logistics_process"];
        [self.pointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerX.equalTo(self.lineView);
            make.top.equalTo(self.lineView);
            make.bottom.equalTo(self.lineView);
        }];
    }
    [self.pointImageView setNeedsDisplay];
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _addressLabel.textColor = [UIColor colorWithHexString:@"0xAFAFB0"];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}
- (SDLineView *)pointImageView{
    if (!_pointImageView) {
        _pointImageView = [[SDLineView alloc] initWithType:SDDashLineTypeVertical];
    }
    return _pointImageView;
}
- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_logistics_process"]];
    }
    return _centerImageView;
}
@end
