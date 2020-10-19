//
//  SDGrouperOrderMgrViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/7.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperOrderMgrViewController.h"
#import "SDGrouperOrderCell.h"
#import "SDGrouperOrderDetailViewController.h"
#import "SDOrderListRequest.h"
#import "SDNoDataView.h"

@interface SDGrouperOrderMgrViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) SDUserRolerType rolerType;
/** [全部:1 待发货:3 已完成:4] */
@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, strong) SDNoDataView *noDataView;

@property (nonatomic, assign) int page;

@end

@implementation SDGrouperOrderMgrViewController

static NSString * const CellID = @"SDGrouperOrderCell<##>";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataView.loadFail = NO;
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    [self initTableView];
}

+ (instancetype)orderContentType:(SDUserRolerType)rolerType status:(nonnull NSString *)status {
    return [[self alloc] initWithOrderContentType:rolerType status:status];
}

- (instancetype)initWithOrderContentType:(SDUserRolerType)rolerType status:(nonnull NSString *)status {
    if (self = [super init]) {
        self.rolerType = rolerType;
        self.status = status;
    }
    return self;
}

- (void)initTableView {
    NSUInteger count = self.tabBarController.viewControllers.count;
    CGFloat bottomMargin = count == 3 ? -kBottomSafeHeight : 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomMargin);
        make.top.mas_equalTo(0);
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDGrouperOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    SDOrderListModel *model = [self.orderArr objectAtIndex:indexPath.section];
    cell.rolerType = self.rolerType;
    cell.model = model;
    SD_WeakSelf;
    cell.sendGoodBlock = ^(SDOrderListModel * _Nonnull model) {
        SD_StrongSelf;
        [self.tableView.mj_header beginRefreshing];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDOrderListModel *model = [self.orderArr objectAtIndex:indexPath.section];
    CGFloat height = 252;
    if (model) {
        
        if (model.distribution.integerValue == 1) {
            if (model.transInfo.name.length > 0) {
                height = 252;
            }else {
                height = 252 - 29;
            }
            if (model.status.integerValue == 15) {
                height = height + 29;
            }
        }else{
            if (model.receiver.length > 0) {
                height = 252;
            }else {
                height = 252 - 29;
            }
            if (model.status.integerValue == 15) {
                height = height + 29;
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderArr.count == 0) {
        return;
    }
    SDGrouperOrderDetailViewController *vc = [[SDGrouperOrderDetailViewController alloc] init];
    SDOrderListModel *model = [self.orderArr objectAtIndex:indexPath.section];
    vc.rolerType = self.rolerType;
    vc.orderId = model.orderId;
    SD_WeakSelf;
    vc.sendGoodBlock = ^{
        SD_StrongSelf;
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - DZNEmptyDataSetSource tableView
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return 20;
//}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return self.noDataView;
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
- (void)getOrderListData{
    SDOrderListRequest *request = [[SDOrderListRequest alloc] init];
    request.status = self.status;
    request.page = [NSString stringWithFormat:@"%d", self.page];
    request.role = [NSString stringWithFormat:@"%lu",(unsigned long)self.rolerType];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDOrderListRequest * _Nonnull request) {
        self.noDataView.loadFail = NO;
        if (self.page > 1) {
            if (!request.listModel || request.listModel.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return;
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        }else {
            [self.orderArr removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        }
        [self.orderArr addObjectsFromArray:request.listModel];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.noDataView.loadFail = YES;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - lazy
- (NSMutableArray *)orderArr {
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

- (SDNoDataView *)noDataView {
    if (!_noDataView) {
        NSString *tips = @"暂无数据";
        SD_WeakSelf
        _noDataView = [SDNoDataView noDataViewWithTips:tips loadClickBlock:^{
            SD_StrongSelf
            [self.tableView.mj_header beginRefreshing];
        }];
    }
    return _noDataView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView registerClass:[SDGrouperOrderCell class] forCellReuseIdentifier:CellID];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        SD_WeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            SD_StrongSelf;
            self.page = 1;
            [self.tableView.mj_footer resetNoMoreData];
            [self getOrderListData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            SD_StrongSelf;
            self.page = self.page + 1;
            [self getOrderListData];
        }];
    }
    return _tableView;
}

@end
