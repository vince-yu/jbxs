//
//  SDGrouperFriendCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperFriendCell.h"

@interface SDGrouperFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation SDGrouperFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatorImageView.layer.cornerRadius = 15.0;
    self.avatorImageView.clipsToBounds = YES;
    self.avatorImageView.layer.borderWidth = 1.5;
    self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"0xCECDCD"].CGColor;
}
- (void)setModel:(SDGrouperFriendModel *)model{
    _model = model;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:_model.header] placeholderImage:[UIImage imageNamed:@"mine_avator"]];
    
    if (_model.rank.integerValue == 1) {
        self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"0xF8D133"].CGColor;
        self.crownImageView.image = [UIImage imageNamed:@"grouper_friend_no1"];
    }else if (_model.rank.integerValue == 2) {
        self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"0xF9b625"].CGColor;
        self.crownImageView.image = [UIImage imageNamed:@"grouper_friend_no2"];
    }else if (_model.rank.integerValue == 3) {
        self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"0xF98425"].CGColor;
        self.crownImageView.image = [UIImage imageNamed:@"grouper_friend_no3"];
    }else{
        self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"0xCECDCD"].CGColor;
        self.crownImageView.hidden = YES;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"NO.%@",_model.rank];
    self.phoneLabel.text = _model.mobile;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_model.amount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
