//
//  SDMyCouponsViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyCouponsViewController.h"
#import "SDMyCouponsCell.h"
#import "SDMyCouponsRequest.h"
#import "SDJumpManager.h"

@interface SDMyCouponsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *couponsArr;
@property (nonatomic, assign) int page;

@end

@implementation SDMyCouponsViewController

static NSString * const CellID = @"SDMyCouponsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.page = 1;
    [self initTableView];
}

- (void)initNav {
    self.navigationItem.title = @"我的优惠券";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    [tableView registerClass:[SDMyCouponsCell class] forCellReuseIdentifier:CellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
    SD_WeakSelf
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SD_StrongSelf;
        self.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self getMyCouponsData];
    }];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SD_StrongSelf;
        self.page = self.page + 1;
        [self getMyCouponsData];
    }];
    [tableView.mj_header beginRefreshing];
}

#pragma mark - network
- (void)getMyCouponsData {
    SDMyCouponsRequest *request = [[SDMyCouponsRequest alloc] init];
    request.limit = 500;
    request.page = self.page;
    [SDToastView show];
    SD_WeakSelf
    [request startWithCompletionBlockWithSuccess:^(__kindof SDMyCouponsRequest * _Nonnull request) {
        SD_StrongSelf
        if (self.page > 1) {
            if (!request.couponsModel || request.couponsModel.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        }else {
            [self.couponsArr removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        }
        for (SDCouponsModel *model in request.couponsModel) {
            model.displayType = SDCouponsDisplayTypeUseButton;
        }
        if (request.couponsModel.count > 0) {
            [self.couponsArr addObjectsFromArray:request.couponsModel];
        }
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.couponsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDMyCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (self.couponsArr.count > 0 && self.couponsArr.count > indexPath.section) {
        SDCouponsModel *model = [self.couponsArr objectAtIndex:indexPath.section];
        cell.couponsModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SDCouponsModel *model = [self.couponsArr objectAtIndex:indexPath.section];
    if (self.couponsArr.count > 0 && self.couponsArr.count > indexPath.section) {
        
        [SDStaticsManager umEvent:kcoupon_item attr:@{@"_id":model.couponsId,@"type":model.type}];
    }
    if (model.notObtain && [SDUserModel sharedInstance].activiting) {
        [SDJumpManager jumpUrl:kH5NewUser push:YES parentsController:nil animation:YES];
    }else{
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.couponsArr.count - 1) {
        return 15;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRGB:0xEFEFF4];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRGB:0xEFEFF4];
    return footerView;
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"cart_no_good"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *str = @"很遗憾暂无可用的优惠券";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 14], NSForegroundColorAttributeName: [UIColor colorWithHexString:kSDGrayTextColor]} range:NSMakeRange(0, str.length)];
    return attStr;
}



#pragma mark - lazy
- (NSMutableArray *)couponsArr {
    if (!_couponsArr) {
        _couponsArr = [NSMutableArray array];
    }
    return _couponsArr;
}

@end
