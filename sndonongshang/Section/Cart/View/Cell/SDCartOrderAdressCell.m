//
//  SDCartOrderAdressCellTableViewCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOrderAdressCell.h"
#import "SDAddressModel.h"
#import "SDCartRepoListModel.h"
#import "SDCartDataManager.h"

@interface SDCartOrderAdressCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@end

@implementation SDCartOrderAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor  = [UIColor whiteColor];
    self.addBtn.layer.cornerRadius = 15;
    self.addBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    self.addBtn.layer.borderWidth = 1.0;
    self.contentView.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor cyanColor];
}
- (void)updateAddressType:(SDCartOrderType )type{
    switch (type) {
        case SDCartOrderTypeDelivery:
        {
            SDAddressModel *address = [SDCartDataManager sharedInstance].selectAddressModel;
            if (address) {
                self.addBtn.hidden = YES;
                self.nameLabel.hidden = NO;
                self.addressLabel.hidden = NO;
                self.chooseImageView.hidden = NO;
                self.nameLabel.text = [NSString stringWithFormat:@"%@ ,%@",address.name,address.mobileHide];
                self.addressLabel.text = address.street;
            }else{
                self.addBtn.hidden = NO;
                self.nameLabel.hidden = YES;
                self.addressLabel.hidden = YES;
                self.chooseImageView.hidden = YES;
            }
        }
            break;
        case SDCartOrderTypeSelfTake:
        {
            SDCartRepoListModel *repo = [SDCartDataManager sharedInstance].selectRepoModel ?  [SDCartDataManager sharedInstance].selectRepoModel :  [SDCartDataManager sharedInstance].repoListArray.firstObject;
            self.addBtn.hidden = YES;
            self.nameLabel.hidden = NO;
            self.addressLabel.hidden = NO;
            self.chooseImageView.hidden = NO;
            self.nameLabel.text = @"123";
            self.addressLabel.text = @"321";
//            self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",repo.name,[repo.phone secretStrFromPhoneStr]];
//            self.addressLabel.text = repo.address.length ? repo.address : @" ";
        }
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
