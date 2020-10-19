//
//  SDOrderDetailViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderDetailViewController.h"
#import "SDShopCell.h"
#import "SDOrderDetailRequest.h"
#import "SDPayViewController.h"
#import "SDOrderDetailFooterView.h"
#import "SDOrderDetailHeaderView.h"
#import "SDLogisticsReqest.h"

@interface SDOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) SDOrderDetailHeaderView *headerView;
@property (nonatomic, strong) SDOrderDetailFooterView *footerView;
@property (nonatomic, strong) UIButton *goPayBtn;
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) YYLabel *bottomAmountLabel;


@property (nonatomic, assign) SDDistributionType distributionType;
@property (nonatomic, assign) Boolean noPay;
@property (nonatomic, strong) SDOrderDetailModel *detailModel;

@end

@implementation SDOrderDetailViewController

static NSString * const cellID = @"SDShopCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self getOrderDetailData];
}

- (void)initNav {
    self.navigationItem.title = @"订单详情";
}

- (void)initTableView {
    CGFloat extra = self.noPay ? 50 : 0;
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
}

- (UIView *)setupHeaderView {
    if (!self.headerView) {
        self.headerView = [SDOrderDetailHeaderView headerView:self.detailModel];
    }
    return self.headerView;
}

- (UIView *)setupFooterView {
    if (!self.footerView) {
        self.footerView = [SDOrderDetailFooterView footerView:self.detailModel];
    }
    return self.footerView;
}

- (void)initBottomView {
    if (self.noPay) {
        [self.view addSubview:self.goPayBtn];
        [self.view addSubview:self.bottomLeftView];
        [self.view addSubview:self.bottomAmountLabel];
        [self.bottomLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-kBottomSafeHeight);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(SCREEN_WIDTH * 250 / 375);
        }];
        
        [self.goPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-kBottomSafeHeight);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(SCREEN_WIDTH * 125 / 375);
        }];
        
        NSString *amount = [self.detailModel.amount priceStr];
        NSString *amountStr = [NSString stringWithFormat:@"需付款：￥%@", amount];
        NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amountStr];
        amountText.yy_font = [UIFont fontWithName:kSDPFMediumFont size:14];
        amountText.yy_color = [UIColor colorWithHexString:kSDRedTextColor];
        [amountText yy_setColor:[UIColor colorWithRGB:0x9B9A98] range:NSMakeRange(0, 4)];
        [amountText yy_setFont:[UIFont fontWithName:kSDPFBoldFont size:15] range:NSMakeRange(4, 1)];
        [amountText yy_setFont:[UIFont fontWithName:kSDPFBoldFont size:18] range:NSMakeRange(5, amount.length)];
        self.bottomAmountLabel.attributedText = amountText;
        [self.bottomAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.bottomLeftView);
        }];
        
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
            height = 230 ;
        }else if (self.detailModel.receiver.length > 0) {
            height = 265 + 70;
        }else{
           height = 265 + 35;
        }
        if (self.detailModel.status.integerValue == 15) {
            height = height + 60;
        }
        if (self.detailModel.expressModel) {
            CGSize size = [self.detailModel.expressModel.desc sizeWithFont:[UIFont fontWithName:kSDPFMediumFont size:16] maxSize:CGSizeMake(self.view.bounds.size.width - 15 - 15 - 8 - 20, 32)];
            height = height + size.height + 60;
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
        return 348;
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
- (void)goPayBtnClick {
    if (!self.detailModel) {
        return;
    }
    SDCartOderModel *orderModel = [[SDCartOderModel alloc] init];
    orderModel.amount = self.detailModel.amount;
    orderModel.orderId = self.detailModel.orderId;
    
    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *subVc = self.navigationController.viewControllers[i];
        if ([subVc isKindOfClass:[SDPayViewController class]]) {
            [self.navigationController popToViewController:subVc animated:YES];
            return;
        }
    }
    SDPayViewController *vc = [[SDPayViewController alloc] init];
    vc.orderModel = orderModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network
- (void)getOrderDetailData {
    SDOrderDetailRequest *request = [[SDOrderDetailRequest alloc] init];
    request.orderId = self.orderId;
    [SDToastView show];
    SD_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof SDOrderDetailRequest * _Nonnull request) {
        SD_StrongSelf;
        self.detailModel = request.orderModel;
        if (self.detailModel.expressNo.length) {
            SDLogisticsReqest *expressRe = [[SDLogisticsReqest alloc] init];
            expressRe.orderId = self.detailModel.orderId;
            SD_WeakSelf;
            [expressRe startWithCompletionBlockWithSuccess:^(__kindof SDLogisticsReqest * _Nonnull request) {
                SD_StrongSelf;
                if (expressRe.listModel.list.count) {
                    self.detailModel.expressModel = expressRe.listModel.list.firstObject;
                }
                
                [self reloadView];
            } failure:^(__kindof SDLogisticsReqest * _Nonnull request) {
                [self reloadView];
            }];
        }else{
            [self reloadView];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}
- (void)reloadView{
    self.distributionType = [self.detailModel.distribution isEqualToString:@"2"] ? SDDistributionTypeGoShop : SDDistributionTypeGoDoor;
    self.noPay = [self.detailModel.status intValue] <= 2 ? YES : NO;
    [self initTableView];
    [self initBottomView];
}
#pragma mark - lazy
- (UIButton *)goPayBtn {
    if (!_goPayBtn) {
        _goPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goPayBtn setTitle:@"去付款" forState:UIControlStateNormal];
        [_goPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goPayBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [_goPayBtn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goPayBtn;
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
