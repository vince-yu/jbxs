//
//  SDGrouperOrderDetailViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperOrderDetailViewController.h"
#import "SDShopCell.h"
#import "SDOrderDetailRequest.h"
#import "SDPayViewController.h"
#import "SDGroupDetailHeaderView.h"
#import "SDGroupDetailFooterView.h"
#import "SDSendGoodRequest.h"

@interface SDGrouperOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) SDGroupDetailHeaderView *headerView;
@property (nonatomic, strong) SDGroupDetailFooterView *footerView;
@property (nonatomic, strong) UIButton *deliverBtn;
@property (nonatomic, strong) UIView *bottomLeftView;

@property (nonatomic, strong) YYLabel *bottomAmountLabel;
@property (nonatomic, assign) SDDistributionType distributionType;
@property (nonatomic, assign) Boolean noDeliver;
@property (nonatomic, strong) SDOrderDetailModel *detailModel;

@end

@implementation SDGrouperOrderDetailViewController

static NSString * const cellID = @"SDShopCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.noDeliver = YES;
    [self getOrderDetailData];
}

- (void)initNav {
    self.navigationItem.title = @"订单详情";
}

- (void)initTableView {
    CGFloat extra = self.noDeliver ? 50 : 0;
    CGFloat height = SCREEN_HEIGHT - kTopHeight - extra;
    CGRect frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.bounces = NO;
    [tableView registerClass:[SDShopCell class] forCellReuseIdentifier:cellID];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-extra);
    }];
    
    [self.view addSubview:self.deliverBtn];
    [self.deliverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (UIView *)setupHeaderView {
    if (!self.headerView) {
        self.headerView = [SDGroupDetailHeaderView headerView:self.detailModel rolerType:self.rolerType];
        
    }
    return self.headerView;
}

- (UIView *)setupFooterView {
    if (!self.footerView) {
        self.footerView = [SDGroupDetailFooterView footerView:self.detailModel];
    }
    return self.footerView;
}

- (void)initBottomView {
    self.deliverBtn.hidden = NO;
    if (self.detailModel.status.integerValue == 3 && self.rolerType == SDUserRolerTypeGrouper) {
        _deliverBtn.enabled = YES;
        _deliverBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [self.deliverBtn setTitle:@"发货" forState:UIControlStateNormal];
        
    }else if (self.detailModel.status.integerValue == 31 && self.rolerType == SDUserRolerTypeGrouper){
        _deliverBtn.enabled = NO;
        [self.deliverBtn setTitle:@"已发货" forState:UIControlStateNormal];
        _deliverBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
    }else{
        self.deliverBtn.hidden = YES;
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.goodsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    SDGoodModel *goodModel = self.detailModel.goodsInfo[indexPath.row];
    cell.goodModel = goodModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDGoodModel *goodModel = self.detailModel.goodsInfo[indexPath.row];
    return goodModel.contentH;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        headerView = [self setupHeaderView];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat height = 0;
        if ([self.detailModel.distribution isEqualToString:@"1"]) {
            height = 230;
        }
        if (!self.detailModel.receiver || self.detailModel.receiver.length == 0 ) {
            height = 230;
        }else{
            height = 265;
        }
        if (self.detailModel.status.integerValue == 15) {
            height = height + 60;
        }
        return height;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [self setupFooterView];
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 348 + 14 + 6 * 2;
    }
    return 0.0001;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }else {
        self.tableView.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
}



#pragma mark - action
- (void)deliverBtnClick {
    if (!self.detailModel) {
        return;
    }
    [SDStaticsManager umEvent:kordermg_fh_dialog attr:@{@"_id":self.detailModel.orderId}];
    SD_WeakSelf;
    [SDPopView showPopViewWithContent:@"确认该订单已经发货吗？" noTap:NO confirmBlock:^{
        SD_StrongSelf;
        [SDStaticsManager umEvent:kordermg_fh_ok attr:@{@"_id":self.detailModel.orderId}];
        SDSendGoodRequest *send = [[SDSendGoodRequest alloc] init];
        send.orderId = self.detailModel.orderId;
        SD_WeakSelf;
        [send startWithCompletionBlockWithSuccess:^(__kindof SDSendGoodRequest * _Nonnull request) {
            SD_StrongSelf;
            if (self.sendGoodBlock) {
                self.sendGoodBlock();
            }
            [self updateSendStatus];
            [SDToastView HUDWithSuccessString:@"成功发货!"];
        } failure:^(__kindof SDSendGoodRequest * _Nonnull request) {
//            [SDToastView HUDWithSuccessString:request.msg];
        }];
    } cancelBlock:^{
        SD_StrongSelf;
        [SDStaticsManager umEvent:kordermg_fh_cancel attr:@{@"_id":self.detailModel.orderId}];
    }];
}
- (void)updateSendStatus{
    self.detailModel.status = @"31";
    [self initBottomView];
    [self.headerView updateStatusLabelText:@"31"];
}
#pragma mark - network
- (void)getOrderDetailData {
    SDOrderDetailRequest *request = [[SDOrderDetailRequest alloc] init];
    request.orderId = self.orderId;
    request.role = @"1";
    if (self.rolerType == SDUserRolerTypeNormal) {
        request.role = @"0";
    }
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDOrderDetailRequest * _Nonnull request) {
        self.detailModel = request.orderModel;
        self.distributionType = [self.detailModel.distribution isEqualToString:@"2"] ? SDDistributionTypeGoShop : SDDistributionTypeGoDoor;
        self.noDeliver = [self.detailModel.status intValue] <= 2 ? YES : NO;
        [self initTableView];
        [self initBottomView];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

#pragma mark - lazy
- (UIButton *)deliverBtn {
    if (!_deliverBtn) {
        _deliverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deliverBtn setTitle:@"发货" forState:UIControlStateNormal];
        [_deliverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deliverBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [_deliverBtn addTarget:self action:@selector(deliverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deliverBtn;
}

- (UIView *)bottomLeftView {
    if (!_bottomLeftView) {
        _bottomLeftView = [[UIView alloc] init];
        _bottomLeftView.backgroundColor = [UIColor colorWithRGB:0x2E302E];
    }
    return _bottomLeftView;
}

- (YYLabel *)bottomAmountLabel {
    if (!_bottomAmountLabel) {
        _bottomAmountLabel = [[YYLabel alloc] init];
    }
    return _bottomAmountLabel;
}

@end

