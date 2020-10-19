//
//  SDOrderContentViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderContentViewController.h"
#import "SDMyOrderCell.h"
#import "SDOrderListRequest.h"
#import "SDOrderDetailViewController.h"

@interface SDOrderContentViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) SDOrderType orderType;
@property (nonatomic, strong) NSMutableArray *ordersArr;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIImageView *emptyIv;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign, getter=isLoadFail) BOOL loadFail;


@end

@implementation SDOrderContentViewController

static NSString * const cellID = @"SDMyOrderCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self initTableView];
}

+ (instancetype)orderContentWithFrame:(CGRect)frame type:(SDOrderType)orderType {
    return [[self alloc] initWithOrderContentWithFrame:frame type:orderType];
}

- (instancetype)initWithOrderContentWithFrame:(CGRect)frame type:(SDOrderType)orderType {
    if (self = [super init]) {
        self.orderType = orderType;
    }
    return self;
}

+ (instancetype)orderContentType:(SDOrderType)orderType {
    return [[self alloc] initWithOrderContentType:orderType];
}

- (instancetype)initWithOrderContentType:(SDOrderType)orderType {
    if (self = [super init]) {
        self.orderType = orderType;
        
    }
    return self;
}

- (void)initTableView {
    self.view.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    [tableView registerClass:[SDMyOrderCell class] forCellReuseIdentifier:cellID];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.rowHeight = 196 + 10;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
    SD_WeakSelf;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SD_StrongSelf;
        self.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self getOrderListData];
    }];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SD_StrongSelf;
        self.page = self.page + 1;
        [self getOrderListData];
    }];
    [tableView.mj_header beginRefreshing];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ordersArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    SDOrderListModel *model = self.ordersArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ordersArr.count == 0) {
        return;
    }
    SDOrderListModel *model = self.ordersArr[indexPath.row];
    SDOrderDetailViewController *vc = [[SDOrderDetailViewController alloc] init];
    vc.orderId = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

#pragma mark - DZNEmptyDataSetSource tableView
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -20;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (!_emptyView) {
        [self.emptyView addSubview:self.emptyIv];
        [self.emptyView addSubview:self.tipsLabel];
        [self.emptyView addSubview:self.loadBtn];
    }
    CGFloat x = (SCREEN_WIDTH - 120) * 0.5;
    if (self.isLoadFail) {
        self.loadBtn.hidden = NO;
        self.tipsLabel.text = @"加载失败";
        self.emptyIv.image = [UIImage imageNamed:@"load_fail"];
        self.emptyView.frame = CGRectMake(x, 0, 120, 120 + 14 + 35 + 27);
    }else {
        self.loadBtn.hidden = YES;
        self.tipsLabel.text = @"暂无数据";
        self.emptyIv.image = [UIImage imageNamed:@"cart_no_good"];
        self.emptyView.frame = CGRectMake(x, 0, 120, 120);
    }
    self.emptyIv.frame = CGRectMake(x , 0, 120, 120);
    self.tipsLabel.frame = CGRectMake(x , CGRectGetMaxY(self.emptyIv.frame), 120, 14);
    self.loadBtn.frame = CGRectMake((SCREEN_WIDTH - 75) * 0.5, CGRectGetMaxY(self.emptyIv.frame) + 30, 75, 27);
    self.emptyView.superview.userInteractionEnabled = YES;
    
    return self.emptyView;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self emptyDataClick];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - action
- (void)emptyDataClick {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - network
- (void)getOrderListData {
    SDOrderListRequest *request = [[SDOrderListRequest alloc] init];
    request.status = [NSString stringWithFormat:@"%lu", (unsigned long)self.orderType + 1];
    request.page = [NSString stringWithFormat:@"%d", self.page];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDOrderListRequest * _Nonnull request) {
        if (self.page > 1) {
            if (!request.listModel || request.listModel.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        }else {
            [self.ordersArr removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        }
        [self.ordersArr addObjectsFromArray:request.listModel];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        if (self.page == 1) {
            self.loadFail = YES;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - lazy
- (NSMutableArray *)ordersArr {
    if (!_ordersArr) {
        _ordersArr = [NSMutableArray array];
    }
    return _ordersArr;
}

- (UIButton *)loadBtn{
    if (!_loadBtn) {
        _loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_loadBtn setTitleColor:[UIColor colorWithHexString:@"0x131413"] forState:UIControlStateNormal];
        _loadBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        _loadBtn.layer.borderWidth = 0.5;
        _loadBtn.layer.cornerRadius = 13.5;
        _loadBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        _loadBtn.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
        [_loadBtn addTarget:self action:@selector(emptyDataClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadBtn;
}

- (UIImageView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIImageView alloc] init];
        _emptyView.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xf7f7f7] size:CGSizeMake(SCREEN_WIDTH, 120 + 14 + 35 + 27)];
    }
    return _emptyView;
}

- (UIImageView *)emptyIv {
    if (!_emptyIv) {
        _emptyIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_no_good"]];
    }
    return _emptyIv;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"加载失败";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _tipsLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    }
    return _tipsLabel;
}

@end
