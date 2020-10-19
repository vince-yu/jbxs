//
//  SDBaseTitleCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/5/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTitleCell.h"
#import "SDHomeDataManager.h"
#import "SDLoginViewController.h"

@implementation SDBaseTitleCell
@synthesize detailModel = _detailModel;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)handleCouponsView{
    if ([SDUserModel sharedInstance].isLogin) {
        if (_detailModel.couponArray.count) {
            self.couponView.hidden = NO;
            if (self.detailModel.type.integerValue == SDGoodTypeGroup || (self.detailModel.type.integerValue == SDGoodTypeSecondkill && self.detailModel.soldOut)) {
                self.saleLabelBottom.constant = 60.0;
            }else{
                self.saleLabelBottom.constant = 50.0;
            }
            [self.couponTagView addCouponWithArray:_detailModel.couponArray];
        }else{
            self.couponView.hidden = YES;
            if (self.detailModel.type.integerValue == SDGoodTypeGroup) {
                self.saleLabelBottom.constant = 45.0;
            }else{
                self.saleLabelBottom.constant = 20.0;
            }
            
        }
    }else{
        
        if (![SDUserModel sharedInstance].isLogin && ![[[NSUserDefaults standardUserDefaults] objectForKey:kAppLogined] boolValue]) {
            self.couponView.hidden = NO;
            if (self.detailModel.type.integerValue == SDGoodTypeGroup) {
                self.saleLabelBottom.constant = 60.0;
            }else{
                self.saleLabelBottom.constant = 50.0;
            }
            
            //             s *model = []
            SDCouponsModel *model = [[SDCouponsModel alloc] init];
            model.title = _detailModel.obtainVoucherMsg;
            model.type = @"5";
            [self.couponTagView addCouponWithArray:[NSArray arrayWithObject:model]];
        }else{
            self.couponView.hidden = YES;
            if (self.detailModel.type.integerValue == SDGoodTypeGroup) {
                self.saleLabelBottom.constant = 45.0;
            }else{
                self.saleLabelBottom.constant = 20.0;
            }
        }
    }
}
- (void)handleCommissionLabel{
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeGrouper || [SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        self.commissionLabel.hidden = NO;
        NSString *rate = [[NSString stringWithFormat:@"%f",_detailModel.rebateRate.doubleValue * 100] subPriceStr:2];
        self.commissionLabel.text = _detailModel.rebateRate.length ? [NSString stringWithFormat:@"佣金比例：%@%%",rate] : @"佣金比例：0%";
    }else{
        self.commissionLabel.hidden = YES;
    }
}
- (void)pushToCouponView{
    if (![SDUserModel sharedInstance].isLogin) {
        [SDLoginViewController present];
        return;
    }
    [SDStaticsManager umEvent:kdetail_coupon];
    [SDHomeDataManager getGoodDetailAllCouponsData];
}
@end
