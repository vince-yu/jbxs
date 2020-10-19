//
//  SDCartListViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartListViewController.h"
#import "SDCartListTableView.h"
#import "SDCartListBarView.h"
#import "SDCartOrderViewController.h"
#import "SDSegmentedControl.h"
#import "SDCartDataManager.h"
#import "SDLoginViewController.h"
#import "SDGoodDetailViewController.h"
#import "SDSecondKillViewController.h"
#import "SDDisCountViewController.h"
#import "SDSystemDetailViewController.h"

@interface SDCartListViewController ()
@property (nonatomic ,strong) SDCartListTableView *listTableView;
@property (nonatomic ,strong) SDCartListBarView *barView;
@property (nonatomic ,strong) SDSegmentedControl *segmentedControl;
@property (nonatomic ,strong) NSArray *sectionArray;
@end

@implementation SDCartListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"商品列表";
    [self initSubViews];
    [self refreshCartListTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCartListTableView) name:kNotifiRefreshCartListTableView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartListTableView) name:kNotifiReloadCartListTableView object:nil];
}
- (void)updateBageCount{
    NSInteger count = [SDCartDataManager getAllCartGoodsCount];
    if (count) {
        if (count > 99) {
            self.navigationController.tabBarItem .badgeValue = [NSString stringWithFormat:@"%d+",99];
        }else{
            self.navigationController.tabBarItem .badgeValue = [NSString stringWithFormat:@"%ld",count];
        }
        self.barView.hidden = NO;
    }else{
        self.navigationController.tabBarItem.badgeValue = nil;
        self.barView.hidden = YES;
    }
}
- (void)initSubViews{
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.barView];
    self.barView.backgroundColor = [UIColor whiteColor];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self.barView.mas_top);
    }];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(50);
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.listTableView refreshAction];
    
}
- (void)updateBarView{
    NSArray *array = [SDCartDataManager sharedInstance].cartListArray;
    if ([array count]) {
        self.barView.hidden = YES;
    }else{
        self.barView.hidden = NO;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshCartListTableView object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiReloadCartListTableView object:nil];
}
#pragma mark init view
- (SDCartListBarView *)barView{
    if (!_barView) {
        _barView = [[[NSBundle mainBundle] loadNibNamed:@"SDCartListBarView" owner:nil options:nil] objectAtIndex:0];
        SD_WeakSelf;
        _barView.payBlock = ^{
            SD_StrongSelf;
            [self pushToPayDetailVC];
        };
        _barView.chooseBlock = ^(BOOL selected) {
            SD_StrongSelf;
            [[SDCartDataManager sharedInstance] updateCartGoodSeleted:[SDCartDataManager sharedInstance].cartListArray seleted:selected];
            [self.listTableView reloadData];
        };
        _barView.showFreightBlock = ^(BOOL hidden) {
            SD_StrongSelf;
            if (hidden == YES) {
                [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.barView.mas_top);
                }];
            }else {
                [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.barView.mas_top).mas_equalTo(-20);
                }];
            }
        };
    }
    return _barView;
}
- (SDCartListTableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[SDCartListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_listTableView addMJRefresh];
        SD_WeakSelf;
        _listTableView.block = ^{
            SD_StrongSelf;
            [self updateBageCount];
        };
        _listTableView.pushToDetailVCBlock = ^(id  _Nonnull model) {
            SD_StrongSelf;
            [self pushToGoodDetailVC:model];
        };
    }
    
    return _listTableView;
}
- (NSArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = @[@"及时达",@"次日达"];
    }
    return _sectionArray;
}
#pragma mark Function
- (void)pushToGoodDetailVC:(SDGoodModel *)goodModel{
    if (goodModel.type.integerValue == SDGoodTypeNamoal) {
        SDGoodDetailViewController *detailVC = [[SDGoodDetailViewController alloc] init];
        detailVC.goodModel = goodModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeSecondkill){
        SDSecondKillViewController *vc = [[SDSecondKillViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeDiscount){
        SDDisCountViewController *vc = [[SDDisCountViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SDSystemDetailViewController *vc = [[SDSystemDetailViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark HMSegmented Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    
}
- (void)pushToPayDetailVC{
    if ([self.navigationController.topViewController isKindOfClass:[SDCartOrderViewController class]]) {
        return;
    }
    if ([SDUserModel sharedInstance].isLogin) {
        SDCartOderRequestModel *payModel = [[SDCartOderRequestModel alloc] init];
        payModel.goods = [SDCartDataManager getSelectGoodArray];
        payModel.isPrepay = @"1";
        if (!payModel.goods.count) {
            [SDToastView HUDWithString:@"请选择您要购买的商品!"];
            return;
        }
        [SDCartDataManager getCartSelectGoodsPriceCompleteBlock:^(id  _Nonnull model) {
            SDCartCalculateModel *caModel = (SDCartCalculateModel *)model;
            if (caModel.type == SDValuationTypeNoDelivery) {
                 self.barView.payBtn.enabled = YES;
                 [self refreshCartListTableView];
            }else{
                [SDCartDataManager sharedInstance].prepayModel = payModel;
                SD_WeakSelf;
                [SDCartDataManager cartToOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel completeBlock: ^(id model){
                    SD_StrongSelf;
                    if (![self.navigationController.topViewController isEqual:self]) {
                        return;
                    }
                    SDCartOrderViewController *vc = [[SDCartOrderViewController alloc] init];
                    
                    vc.orderModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.barView.payBtn.enabled = YES;
//                    });
                } failedBlock:^(id model){
                    self.barView.payBtn.enabled = YES;
                    [SDCartDataManager handelGoodDetailRequestFailed:model listTableView:self.listTableView];
                }];
            }
            
        } failedBlock:^(id model){
            [self refreshCartListTableView];
            self.barView.payBtn.enabled = YES;
            
        }];
        
      
    }else{
        [SDLoginViewController present];
    }
    
}

- (BOOL)fd_prefersNavigationBarHidden {
    return NO;
}
#pragma mark Notification
- (void)refreshCartListTableView{
    [self.listTableView refreshAction];
}
- (void)reloadCartListTableView{
    [self.listTableView reloadData];
}
@end
