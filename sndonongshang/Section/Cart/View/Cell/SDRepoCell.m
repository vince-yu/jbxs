//
//  SDRepoCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRepoCell.h"

@interface SDRepoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *seletedImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeft;

@end

@implementation SDRepoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setRepoModel:(SDCartRepoListModel *)repoModel{
    _repoModel = repoModel;
    if (_repoModel.selected.boolValue) {
        self.seletedImage.hidden = NO;
        self.nameLeft.constant = 52;
        self.addressLeft.constant = 52;
    }else{
        self.seletedImage.hidden = YES;
        self.nameLeft.constant = 15;
        self.addressLeft.constant = 15;
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@    %@",_repoModel.name,_repoModel.phone];
    self.addressLabel.text = _repoModel.location.address.length ? _repoModel.location.address : @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
