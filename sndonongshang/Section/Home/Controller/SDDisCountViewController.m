//
//  SDDisCountViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDisCountViewController.h"
#import "SDGoodDisCountTableView.h"
#import "SDGoodBarView.h"
#import "SDCartDataManager.h"
#import "SDCartOrderViewController.h"
#import "SDLoginViewController.h"
#import "SDShareManager.h"
#import "SDGoodDetailModel.h"
#import "SDHomeDataManager.h"
#import "SDSystemAddView.h"

@interface SDDisCountViewController ()
@end

@implementation SDDisCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
//    self.navigationItem.rightBarButtonItem = self.shareBtn;
    [self initSubViews];
    self.view.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
}
- (void)initSubViews{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.barView];
    self.barView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.barView.mas_top);
    }];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(55 + kBottomSafeHeight);
    }];
}

- (UIView *)barView{
    if (!_barView) {
        SDGoodBarStyle type = SDGoodBarStyleBuyAndCart;
        _barView = [[SDGoodBarView alloc] initWithFrame:CGRectZero type:type];
        SD_WeakSelf;
        _barView.pushToCartVC = ^{
            SD_StrongSelf;
            [SDStaticsManager umEvent:kdetail_cart_click];
            [self pushToCartVCAction];
        };
        _barView.buyNowBlock = ^{
            SD_StrongSelf;
            [SDStaticsManager umEvent:kdetail_buy attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type}];
            [self showBuyView];
        };
        _barView.addToCartBlock = ^{
            SD_StrongSelf;
            [SDStaticsManager umEvent:kdetail_add attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type}];
            [self addGoodToCart];
        };
        _barView.remindBlock = ^{
            SD_StrongSelf
            [self remindAction];
        };
    }
    return _barView;
}
- (SDDetailTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SDGoodDisCountTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain goodModel:self.goodModel];
        [_tableView addMJRefresh];
        SD_WeakSelf;
        _tableView.hiddeBarBlock = ^(BOOL hidden) {
            SD_StrongSelf;
            self.barView.hidden = hidden;
            if (hidden) {
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                if ([SDAppManager sharedInstance].status) {
                    self.navigationItem.rightBarButtonItem = self.shareBtn;
                }
            }
        };
        _tableView.updateBlock = ^(NSString * _Nonnull status,BOOL isBegin) {
            SD_StrongSelf;
//            if ([SDAppManager sharedInstance].status) {
//                self.navigationItem.rightBarButtonItem = self.shareBtn;
//            }
            [self updateBarView:status begin:isBegin];
        };
    }
    return _tableView;
}
@end
