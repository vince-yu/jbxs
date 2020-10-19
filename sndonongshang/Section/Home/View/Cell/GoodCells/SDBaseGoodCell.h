//
//  SDBaseGoodCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/4/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodModel.h"
#import "SDSystemTimeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBaseGoodCell : UITableViewCell{
    SDGoodModel *_model;
    SDSystemTimeView *_timeView;
}
@property (nonatomic ,strong) SDGoodModel *model;
@property (nonatomic ,weak) UILabel *commissionLabel;
@property (nonatomic ,weak) UILabel *oldPriceLabel;
@property (nonatomic ,weak) UILabel *priceLabel;
@property (nonatomic ,weak) NSLayoutConstraint *priceBottom;
@property (weak, nonatomic) UIImageView *soldOutImageView;
@property (weak, nonatomic) UIImageView *goodImageView;

@property (weak, nonatomic) UIButton *addCartBtn;

@property (nonatomic ,strong) SDSystemTimeView *timeView;
@property (weak, nonatomic) NSLayoutConstraint *goodImageTop;
@property (weak, nonatomic) UIView *progressView;

- (void)handleCommissionLabel;
- (void)handlePriceLabels;
- (void)handleSouldOutAction;
@end

NS_ASSUME_NONNULL_END
