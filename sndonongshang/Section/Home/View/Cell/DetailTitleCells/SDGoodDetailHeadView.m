//
//  SDGoodDetailHeadView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodDetailHeadView.h"
#import "SDHomeDataManager.h"
#import "SDCouponsModel.h"

@interface SDGoodDetailHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commssionLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *saledLabel;
@property (weak, nonatomic) IBOutlet UILabel *subName;
@property (weak, nonatomic) IBOutlet UILabel *couponTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLabelBottom;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation SDGoodDetailHeadView
- (void)awakeFromNib{
    if ([SDUserModel sharedInstance].isLogin) {
        self.commssionLabel.hidden = NO;
    }else{
        self.commssionLabel.hidden = YES;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCouponView)];
    [self.couponView addGestureRecognizer:tap];
    self.couponView.userInteractionEnabled = YES;
}
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    
    self.titleLabel.text = _detailModel.name;
    self.subName.text = _detailModel.subName.length ? _detailModel.subName : @"";
    if (detailModel.priceActive.length) {
        self.priceLabel.attributedText = [NSString getAttributeStringPrice:[detailModel.priceActive priceStr] priceFontSize:18 withOldPrice:[detailModel.price priceStr]  oldPriceSize:12 unit:_detailModel.spec];
    }else{
        if (detailModel.price.length) {
            self.priceLabel.attributedText = [NSString getAttributeStringPrice:[detailModel.price priceStr] priceFontSize:18 withOldPrice:@"" oldPriceSize:12 unit:_detailModel.spec];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    self.saledLabel.text = [NSString stringWithFormat:@"累计销售%@%@",detailModel.sold.length ? detailModel.sold : @"0",_detailModel.spec.length ? _detailModel.spec : @""];
    [self.subName sizeToFit];
    [self.titleLabel sizeToFit];
    if ([SDUserModel sharedInstance].isLogin) {
        if (_detailModel.couponArray.count) {
            self.couponView.hidden = NO;
            self.saleLabelBottom.constant = 50.0;
            self.height = self.subName.height + self.titleLabel.height + 115;
            [self.tagView addCouponWithArray:_detailModel.couponArray];
        }else{
            self.couponView.hidden = YES;
            self.saleLabelBottom.constant = 20.0;
            self.height = self.subName.height + self.titleLabel.height + 85;
        }
    }else{
        if (![SDUserModel sharedInstance].isLogin && ![[[NSUserDefaults standardUserDefaults] objectForKey:kAppLogined] boolValue]) {
            self.couponView.hidden = NO;
            self.saleLabelBottom.constant = 50.0;
            self.height = self.subName.height + self.titleLabel.height + 115;
            [self.tagView addCouponWithArray:_detailModel.couponArray];
            SDCouponsModel *model = [[SDCouponsModel alloc] init];
            model.title = _detailModel.obtainVoucherMsg;
            model.type = @"5";
            [self.tagView addCouponWithArray:[NSArray arrayWithObject:model]];
        }else{
            self.couponView.hidden = YES;
            self.saleLabelBottom.constant = 20.0;
            self.height = self.subName.height + self.titleLabel.height + 85;
        }
    }
//    if (_detailModel.couponArray.count && ([SDUserModel sharedInstance].isLogin || (![SDUserModel sharedInstance].isLogin && ![[[NSUserDefaults standardUserDefaults] objectForKey:kAppLogined] boolValue]))) {
//        self.couponView.hidden = NO;
//        self.saleLabelBottom.constant = 50.0;
//        self.height = self.subName.height + self.titleLabel.height + 115;
//        [self.tagView addCouponWithArray:_detailModel.couponArray];
//    }else{
//        self.couponView.hidden = YES;
//        self.saleLabelBottom.constant = 20.0;
//        self.height = self.subName.height + self.titleLabel.height + 85;
//    }
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeGrouper || [SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        self.commssionLabel.hidden = NO;
        NSString *rate = [[NSString stringWithFormat:@"%f",_detailModel.rebateRate.doubleValue * 100] subPriceStr:2];
        self.commssionLabel.text = _detailModel.rebateRate.length ? [NSString stringWithFormat:@"佣金比例：%@%%",rate] : @"佣金比例：0%";
    }else{
        self.commssionLabel.hidden = YES;
    }
    
}
- (void)pushToCouponView{
    [SDStaticsManager umEvent:kdetail_coupon];
    [SDHomeDataManager getGoodDetailAllCouponsData];
}
@end
