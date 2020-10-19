//
//  SDBaseTitleCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/5/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCouponsModel.h"
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBaseTitleCell : UITableViewCell{
    SDGoodDetailModel *_detailModel;
}
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLabelBottom;
@property (weak, nonatomic) IBOutlet UIView *couponTagView;

- (void)handleCommissionLabel;
- (void)handleCouponsView;
- (void)pushToCouponView;
@end

NS_ASSUME_NONNULL_END
