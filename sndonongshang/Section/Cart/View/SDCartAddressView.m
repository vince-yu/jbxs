//
//  SDCartAddressView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartAddressView.h"
#import "SDAddressModel.h"
#import "SDCartRepoListModel.h"
#import "SDCartDataManager.h"

@interface SDCartAddressView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelBottom;
@property (assign ,nonatomic) SDCartOrderType type;

@end

@implementation SDCartAddressView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.addBtn.layer.cornerRadius = 15;
    self.addBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    self.addBtn.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
}
- (void)updateAddressType:(SDCartOrderType )type{
    self.type = type;
    switch (type) {
        case SDCartOrderTypeDelivery:
        {
            SDAddressModel *address = [SDCartDataManager sharedInstance].selectAddressModel;
            if (address) {
                self.addBtn.hidden = YES;
                self.nameLabel.hidden = NO;
                self.addressLabel.hidden = NO;
                self.chooseImageView.hidden = NO;
                self.addressLabelBottom.constant = 30;
                self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",address.name.length ? address.name : @"" ,address.mobile.length ? address.mobile : @""];
                NSMutableString *str = [NSMutableString string];
                [str appendString:address.province.length ? address.province : @""];
                [str appendString:address.city.length ? address.city : @""];
//                [str appendString:address.street.length ? address.street : @""];
                [str appendString:address.sketch.length ? address.sketch : @""];
                [str appendString:address.house_number.length ? address.house_number : @""];
                self.addressLabel.text = str.length ? str : @"";
//                self.addressLabel.text = address.fullAddr.length ? address.fullAddr : @"";
                NSString *timeStr = [SDCartDataManager sharedInstance].preOrderModel.tips;
//                timeStr = @"123432423432";
                if (timeStr.length) {
                    self.timeLabel.text = timeStr;
                    self.timeLabel.hidden = NO;
                }else{
                    self.timeLabel.hidden = YES;
                    self.timeLabel.text = @"";
                }
            }else{
                [self.addBtn setTitle:@"+新建收货地址" forState:UIControlStateNormal];
                self.addBtn.hidden = NO;
                self.nameLabel.hidden = YES;
                self.addressLabel.hidden = YES;
                self.chooseImageView.hidden = YES;
                self.timeLabel.hidden = YES;
            }
//            self.timeLabel.hidden = YES;
        }
            break;
        case SDCartOrderTypeSelfTake:
        {
//            self.timeLabel.hidden = YES;
            NSString *timeStr = [SDCartDataManager sharedInstance].preOrderModel.tips;
            SDCartRepoListModel *repo = [SDCartDataManager sharedInstance].selectRepoModel;
            if (repo == nil && [SDCartDataManager sharedInstance].repoListArray.count) {
                self.addBtn.hidden = NO;
                [self.addBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
            }else{
                self.addBtn.hidden = YES;
            }
            self.nameLabel.hidden = NO;
            self.addressLabel.hidden = NO;
            self.chooseImageView.hidden = NO;
            self.timeLabel.hidden = NO;
            self.addressLabelBottom.constant = 62;
//            self.nameLabel.text = @"123";
//            self.addressLabel.text = @"321";
            self.timeLabel.text = timeStr.length ? timeStr : @"";
            self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",repo.name.length ? repo.name : @"",repo.phone.length ? repo.phone : @""];
            self.addressLabel.text = repo.location.address.length ? repo.location.address : @"";
        }
            break;
        case SDCartOrderTypeSelfTakeOnly:
        {
            NSString *timeStr = [SDCartDataManager sharedInstance].preOrderModel.tips;
            SDCartRepoListModel *repo = [SDCartDataManager sharedInstance].selectRepoModel;
            if (repo == nil && [SDCartDataManager sharedInstance].repoListArray.count) {
                self.addBtn.hidden = NO;
                [self.addBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
            }else{
                self.addBtn.hidden = YES;
            }
            self.nameLabel.hidden = NO;
            self.addressLabel.hidden = NO;
            self.chooseImageView.hidden = NO;
            self.timeLabel.hidden = NO;
            self.addressLabelBottom.constant = 62;
            //            self.nameLabel.text = @"123";
            //            self.addressLabel.text = @"321";
            self.timeLabel.text = timeStr.length ? timeStr : @"";
            self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",repo.name.length ? repo.name : @"",repo.phone.length ? repo.phone : @""];
            self.addressLabel.text = repo.location.address.length ? repo.location.address : @"";
        }
            break;
        default:
            break;
    }
}
- (IBAction)newAddressAction:(id)sender {
    if ([SDCartDataManager sharedInstance].prepayModel.type == SDCartOrderTypeSelfTake) {
        if (self.repolistBlock) {
            self.repolistBlock();
        }
    }else{
        [SDStaticsManager umEvent:kpurchase_todoor_address];
        if (self.newAddressBlock) {
            self.newAddressBlock();
        }
    }
    
}

@end
