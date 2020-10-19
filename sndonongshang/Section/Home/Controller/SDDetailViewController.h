//
//  SDDetailViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"
#import "SDSystemAddView.h"
#import "SDGoodDetailModel.h"
#import "SDDetailTableView.h"
#import "SDGoodBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDDetailViewController : SDBaseViewController{
    SDDetailTableView *_tableView;
    SDGoodBarView *_barView;
}
@property (nonatomic ,strong) SDGoodModel *goodModel;
@property (nonatomic ,strong) UIBarButtonItem *shareBtn;
@property (nonatomic ,assign) CGFloat shareTiprightOffset;
@property (nonatomic ,strong) SDSystemAddView *buyView;
@property (nonatomic ,strong) SDDetailTableView *tableView;

@property (nonatomic ,strong) SDGoodBarView *barView;
@property (nonatomic ,copy) NSString *isBegin;
@property (nonatomic ,copy) NSString *isRemind;
- (void)addGoodToCart;
- (void)showBuyView;
- (void)pushToCartVCAction;
- (void)shareAction;
- (void)remindAction;
- (void)updateBarView:(NSString *)status begin:(BOOL )isBegin;
@end

NS_ASSUME_NONNULL_END
