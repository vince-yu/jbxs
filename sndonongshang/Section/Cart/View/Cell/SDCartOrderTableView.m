//
//  SDCartOrderListView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOrderTableView.h"
#import "SDCartOrderCell.h"
#import "SDOderSelfTakeCell.h"
#import "SDCartDataManager.h"
#import "SDCartOderModel.h"

@interface SDCartOrderTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UIView *headerView;

@end

@implementation SDCartOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)initConfig{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UINib *nib = [UINib nibWithNibName:@"SDCartOrderCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:[SDCartOrderCell cellIdentifier]];
    UINib *nib1 = [UINib nibWithNibName:@"SDOderSelfTakeCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib1 forCellReuseIdentifier:[SDOderSelfTakeCell cellIdentifier]];
    
    //    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    //    [self.backgroundView addSubview:self.headerView];
    //    self.headerView.backgroundColor = [UIColor purpleColor];
    ////    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
    ////        make.top.left.right.bottom.equalTo(self);
    ////    }];
    //    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.equalTo(self);
    //        make.width.mas_equalTo(SCREEN_WIDTH);
    //        make.height.mas_equalTo(100);
    //    }];
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}
#pragma mark data
- (void)refreshAction{
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    SD_WeakSelf;
    [SDCartDataManager prepayNomalOrderWithOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel isCartTO:NO completeBlock: ^(id model){
        SD_StrongSelf;
        self.orderModel = model;
        [self reloadData];
        [self.mj_header endRefreshing];
        if (self.updateBlock) {
            self.updateBlock(self.orderModel.totalPrice, self.orderModel.reducePrice);
        }
    } failedBlock:^(id model){
        [self.mj_header endRefreshing];
        if (self.failedRefreshBlock) {
            self.failedRefreshBlock(model);
        }
    }];
}
- (void)refreshActionWithNoFailedFreshBlock{
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    SD_WeakSelf;
    [SDCartDataManager prepayNomalOrderWithOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel isCartTO:NO completeBlock: ^(id model){
        SD_StrongSelf;
        self.orderModel = model;
        [self reloadData];
        [self.mj_header endRefreshing];
        if (self.updateBlock) {
            self.updateBlock(self.orderModel.totalPrice, self.orderModel.reducePrice);
        }
    } failedBlock:^(id model){
        [self.mj_header endRefreshing];
        [SDCartDataManager handlePayOrderRequestFailedRepeat:model viewController:self.viewController refreshTable:self];
//        if (self.failedRefreshBlock) {
//            self.failedRefreshBlock(model);
//        }
    }];
}
- (void)firtLoadAction{
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    SD_WeakSelf;
    [SDCartDataManager cartToOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel completeBlock: ^(id model){
        SD_StrongSelf;
        self.orderModel = model;
        [self reloadData];
        [self.mj_header endRefreshing];
        if (self.updateBlock) {
            self.updateBlock(self.orderModel.totalPrice, self.orderModel.reducePrice);
        }
    } failedBlock:^(id model){
        [self.mj_header endRefreshing];
    }];
}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && [SDCartDataManager sharedInstance].prepayModel.type == SDCartOrderTypeSelfTake) {
        cell = [self dequeueReusableCellWithIdentifier:[SDOderSelfTakeCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SDOderSelfTakeCell *selftakeCell = (SDOderSelfTakeCell *)cell;
        selftakeCell.orderModel = [SDCartDataManager sharedInstance].preOrderModel;
    }else{
        cell = [self dequeueReusableCellWithIdentifier:[SDCartOrderCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SDCartOrderCell *orderCell = (SDCartOrderCell *)cell;
        orderCell.orderModel = [SDCartDataManager sharedInstance].preOrderModel;
    }
    
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([SDCartDataManager sharedInstance].prepayModel.type == SDCartOrderTypeSelfTake) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
