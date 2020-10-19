//
//  SDCartOrderViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOrderViewController.h"
#import "SDCartOrderTableView.h"
#import "SDCartOrderBarView.h"
#import "SDCartOderSegementView.h"
#import "SDCartOrderListView.h"
#import "SDPayView.h"
#import "SDAlterView.h"
#import "SDPayViewController.h"
#import "SDCartAddressView.h"
#import "SDRepoViewController.h"
#import "SDCartDataManager.h"
#import "SDAddressMgrViewController.h"
#import "SDAddAddressViewController.h"
#import "SDCartOrderAdressCell.h"
#import "SDPayRequest.h"

@interface SDCartOrderViewController ()
@property (nonatomic ,strong) SDCartOrderTableView *listTableView;
@property (nonatomic ,strong) SDCartOrderBarView *barView;
@property (nonatomic ,strong) UIImageView *headerViewBg;
@property (nonatomic ,strong) SDCartOderSegementView *segementView;
@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) SDCartAddressView *addressView;
@property (nonatomic ,assign) SDCartOrderType type;
@property (nonatomic ,strong) SDPopView *popView;

@end

@implementation SDCartOrderViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = [SDCartDataManager sharedInstance].prepayModel.type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提交订单";
    
    [self initSubViews];
    
//    [self.listTableView firtLoadAction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderData) name:kNotifiCartPrePayReload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderWithData) name:kNotifiRefreshOrderTableView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorOder) name:kNotifiOderWithErrorPrePay object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiCartPrePayReload object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshOrderTableView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiOderWithErrorPrePay object:nil];
}
#pragma mark notifaction
- (void)updateOrderData{
    [self.listTableView refreshAction];
}
- (void)handleErrorOder{
    SDCartDataManager *dataMgr = [SDCartDataManager sharedInstance];
    dataMgr.prepayModel.isPrepay = @"1";
    dataMgr.prepayModel.prepayHash = nil;
    [SDToastView HUDWithErrString:@"有商品价格发生变化，需要重新结算"];
    [self.listTableView refreshAction];
//    [_popView removeFromSuperview];
//    _popView = nil;
//    _popView = [SDPopView showPopViewWithContent:@"商品信息已改变，请重新下单!" noTap:NO confirmBlock:^{
//
//    } cancelBlock:nil];
}
- (void)updateOrderWithData{
    [self.listTableView reloadData];
    [self reloadOrderData];
}
- (void)setOrderModel:(SDCartOderModel *)orderModel {
    _orderModel = orderModel;
    self.listTableView.orderModel = orderModel;
    [self.listTableView reloadData];
    if (self.listTableView.updateBlock) {
         self.listTableView.updateBlock(self.orderModel.totalPrice, self.orderModel.reducePrice);
    }
}

- (void)initSubViews{
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
//    [self.view addSubview:self.segementView];
    
    [self.view addSubview:self.barView];
    self.barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerViewBg];
    [self.view addSubview:self.headerView];
//     [self.view addSubview:self.segementView];
    [self.view addSubview:self.listTableView];
   
    
    [self.headerViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(190 - kTabBarHeight);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(165);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset( 10);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.barView.mas_top);
    }];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(50 + kBottomSafeHeight);
    }];
    
    [self.headerView addSubview:self.segementView];
    [self.headerView addSubview:self.addressView];
    
    [self.segementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(0);
    }];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segementView.mas_bottom).offset(-10);
        make.left.right.equalTo(self.segementView);
        make.bottom.equalTo(self.headerView);
    }];
}
#pragma mark init view
- (SDCartOrderBarView *)barView{
    if (!_barView) {
        _barView = [[[NSBundle mainBundle] loadNibNamed:@"SDCartOrderBarView" owner:nil options:nil] objectAtIndex:0];
        SD_WeakSelf;
        _barView.submitBlock = ^{
            SD_StrongSelf;
            [self createRealOrder];
        };
    
    }
    return _barView;
}
- (SDCartOrderTableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[SDCartOrderTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _listTableView.scrollEnabled = NO;
        SD_WeakSelf;
        _listTableView.updateBlock = ^(NSString *pric, NSString *reducePric) {
            SD_StrongSelf;
            [self reloadOrderData];
        };
        _listTableView.failedRefreshBlock = ^(id model){
            SD_StrongSelf;
            [self handlePayOrderRequestFailed:model];
        };
    }
    return _listTableView;
}
- (UIImageView *)headerViewBg{
    if (!_headerViewBg) {
        _headerViewBg = [[UIImageView alloc] init];
        _headerViewBg.image = [UIImage cp_imageByCommonGreenWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    }
    return _headerViewBg;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView  = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}
- (SDCartOderSegementView *)segementView{
    if (!_segementView) {
        _segementView = [[[NSBundle mainBundle] loadNibNamed:@"SDCartOderSegementView" owner:nil options:nil] objectAtIndex:0];
        SD_WeakSelf;
        _segementView.type = [SDCartDataManager sharedInstance].prepayModel.type;
        _segementView.leftBlock = ^{
            SD_StrongSelf;
            if (self.type == SDCartOrderTypeDelivery) {
                return ;
            }
            self.type = SDCartOrderTypeDelivery;
            [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeDelivery;
            [self updateOrderWithData];
        };
        _segementView.rightBlock = ^{
            SD_StrongSelf;
            if (self.type == SDCartOrderTypeSelfTake) {
                return ;
            }
            self.type = SDCartOrderTypeSelfTake;
            [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeSelfTake;
            [self updateOrderWithData];
        };
        _segementView.failedRefreshBlock = ^(id  _Nonnull model) {
            SD_StrongSelf;
            [self handlePayOrderRequestFailed:model];
        };
    }
    return _segementView;
}
- (SDCartAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[[NSBundle mainBundle] loadNibNamed:@"SDCartAddressView" owner:nil options:nil] objectAtIndex:0];
        _addressView.userInteractionEnabled = YES;
        SD_WeakSelf;
        _addressView.newAddressBlock = ^{
            SD_StrongSelf;
            [self pushToAddressNewVC];
        };
        _addressView.repolistBlock = ^{
            SD_StrongSelf;
            [self pushToRepoList];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSelectVC)];
        [_addressView addGestureRecognizer:tap];
    }
    return _addressView;
}
#pragma mark Function
- (void)pushSelectVC{
    if ([SDCartDataManager sharedInstance].prepayModel.type == SDCartOrderTypeSelfTake) {
        [SDStaticsManager umEvent:kpurchase_tostore_addresslist];
        [self pushToRepoList];
    }else{
        if ([SDCartDataManager sharedInstance].selectAddressModel) {
            [self pushToAddressListVC];
        }
        
    }
}
- (void)pushToOrderListView{
    
}
- (void)pushToRepoList{
    SDRepoViewController *vc = [[SDRepoViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushtoPayView{
    SDPayViewController *vc = [[SDPayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToAddressListVC{
    SDAddressMgrViewController *addVC = [[SDAddressMgrViewController alloc] init];
    addVC.selectedAddrModel = [SDCartDataManager sharedInstance].selectAddressModel;
    SD_WeakSelf;
    addVC.selectedAddrBlock = ^(SDAddressModel * _Nonnull addrModel, BOOL isDel) {
        SD_StrongSelf;
        if (!isDel) {
            [self addressUpdateOrder:addrModel];
        }else{
            [self relodAddressListAndOrder];
        }
    };
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)relodAddressListAndOrder{
    SD_WeakSelf;
    [SDCartDataManager cartOrderGetAddressListArrayCompleteBlock:^(id  _Nonnull model) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiCartPrePayReload object:nil];
    } failedBlock:^(id model){
    }];
}
- (void)pushToAddressNewVC{
    SDAddAddressViewController *addVC = [[SDAddAddressViewController alloc] init];
    addVC.block = ^(SDAddressModel * _Nonnull addrModel, SDAddrStatusType statusType) {
        if (statusType == SDAddrStatusTypeAdd) {
            [self addressUpdateOrder:addrModel];
        }
    };
    [self.navigationController pushViewController:addVC animated:YES];
    
}
- (void)addressUpdateOrder:(SDAddressModel *)address{

    [SDCartDataManager sharedInstance].selectAddressModel = address;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiCartPrePayReload object:nil];

    
}
- (BOOL)fd_prefersNavigationBarHidden {
    return NO;
}
- (void)reloadOrderData{
    [self.barView updateTotalPrice];
    [self.addressView updateAddressType:self.type];
    [self.headerView layoutIfNeeded];
    if (!self.headerView.superview) {
        [self.view addSubview:self.headerView];
    }
    if (self.type == SDCartOrderTypeSelfTake || self.type == SDCartOrderTypeHeader || [SDCartDataManager sharedInstance].preOrderModel.tips.length) {
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(kTopHeight);
            make.height.mas_equalTo(175);
            make.width.mas_equalTo(SCREEN_WIDTH - 20);
        }];
    }else{
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(kTopHeight);
            make.height.mas_equalTo(150);
            make.width.mas_equalTo(SCREEN_WIDTH - 20);
        }];
    }
    [SDCartDataManager checkPrePayData];
//    [self pushToExpressViewShowToast:NO];
}
- (void)pushToExpressViewShowToast:(BOOL )show{
    if (self.type == SDCartOrderTypeDelivery && [SDCartDataManager sharedInstance].checkOrderExpress) {
        if (self.orderModel.goodsInfo.count == 1) {
            if (show) {
                [SDToastView HUDWithString:@"收货地址太远，该商品无法送货上门!"];
            }
            
        }else{
            [SDCartDataManager pushToOrderExpressView];
        }
    }
}
#pragma mark - network
/** 正式下单 */
- (void)createRealOrder {
    [self.view endEditing:YES];
    if (self.type == SDCartOrderTypeDelivery && [SDCartDataManager sharedInstance].checkOrderExpress) {
        [self pushToExpressViewShowToast:YES];
        
        return;
    }

    if ((self.type == SDCartOrderTypeDelivery || self.type == SDCartOrderTypeDeliveryOnly )&& ![SDCartDataManager sharedInstance].prepayModel.userAddrId.length) {
        [SDToastView HUDWithString:@"请选择收货地址!"];
        return;
    }
    if ((self.type == SDCartOrderTypeSelfTake || self.type == SDCartOrderTypeSelfTakeOnly) && ![SDCartDataManager sharedInstance].prepayModel.repoId.length) {
        [SDToastView HUDWithString:@"请选择前置仓地址!"];
        return;
    }
    if (self.type == SDCartOrderTypeSelfTake && ![[SDCartDataManager sharedInstance].prepayModel.mobile isPhoneNumber]) {
        [SDToastView HUDWithString:@"请输入11位手机号码!"];
        return;
    }
    SDCartDataManager *dataMgr = [SDCartDataManager sharedInstance];
    dataMgr.prepayModel.isPrepay = @"0";
    dataMgr.prepayModel.prepayHash = dataMgr.preOrderModel.prepayHash;
    SD_WeakSelf;
    [SDCartDataManager nomalOrderWithOrderRequestModel:dataMgr.prepayModel completeBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
        if ([model isKindOfClass:[SDCartOderModel class]]) {
            SDCartOderModel *orderModel = (SDCartOderModel *)model;
            SDPayViewController *vc = [[SDPayViewController alloc] init];
            vc.orderModel = orderModel;
            [SDCartDataManager saveSelfTakePersonAndMobile];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartListTableView object:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failedBlock:^(id model){
        SD_StrongSelf;
        [self handlePayOrderRequestFailed:model];
        
    }];
    
}
- (void)handlePayOrderRequestFailed:(id )model{
    [SDCartDataManager handlePayOrderRequestFailed:model viewController:self refreshTable:self.listTableView];
}
@end
