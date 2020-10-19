//
//  SDSecondKillViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSecondKillViewController.h"
#import "SDSystemDetailViewController.h"
#import "SDGoodSeconKillTableView.h"
#import "SDSystemAddView.h"
#import "SDShareManager.h"
#import "SDCartDataManager.h"
#import "SDCartOrderViewController.h"
#import "SDLoginViewController.h"
#import "SDHomeDataManager.h"
#import "SDGoodDetailModel.h"
#import "SDGoodBarView.h"

@interface SDSecondKillViewController ()

@end

@implementation SDSecondKillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
//    self.navigationItem.rightBarButtonItem = self.shareBtn;
    [self initSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableWithEndTime:) name:kNotifiRefreshListViewWithEndTime object:nil];
}
- (void)reloadTableWithEndTime:(NSNotification *)note{
    NSString *endtime = [note object];
    if ([endtime isEqualToString:self.tableView.detailModel.endTime]) {
        [self.tableView reloadData];
        [self.barView setBuyStr:@"立即购买"];
    }
    
}
- (void)dealloc
{
//    [SDHomeDataManager sharedInstance].detailModel = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshListViewWithEndTime object:nil];
}
- (void)initSubView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.barView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.barView.mas_top);
    }];
    
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(55 + kBottomSafeHeight);
    }];
    
    
    
}
#pragma mark init
- (SDDetailTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SDGoodSeconKillTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain goodModel:self.goodModel];
        [_tableView addMJRefresh];
        SD_WeakSelf;
        _tableView.updateBlock = ^(NSString * _Nonnull status,BOOL isBegin) {
            SD_StrongSelf;
//            if ([SDAppManager sharedInstance].status) {
//                self.navigationItem.rightBarButtonItem = self.shareBtn;
//            }
            [self updateBarView:status begin:isBegin];
        };
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
    }
    return _tableView;
}
- (SDGoodBarView *)barView{
    if (!_barView) {
        SDGoodBarStyle type = SDGoodBarStyleRemind;
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
            SD_StrongSelf;
            if (self.isRemind.boolValue) {
                [SDStaticsManager umEvent:kdetail_remind_cancel attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type}];
            }else{
                [SDStaticsManager umEvent:kdetail_remind attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type}];
            }
            [self remindAction];
        };
    }
    return _barView;
}
@end
