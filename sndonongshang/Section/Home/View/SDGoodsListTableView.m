//
//  SDGoodsListTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodsListTableView.h"
#import "SDGoodsCell.h"
#import "SDHomeDataManager.h"
#import "SDSystemGroupGoodCell.h"
#import "SDSecondKillGoodCell.h"
#import "SDDiscountGoodCell.h"
#import "SDGoodModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SDCartDataManager.h"

@interface SDGoodsListTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic ,strong) NSString *limit;
@property (nonatomic ,strong) NSString *page;
@property (nonatomic ,strong) NSString *tabId;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIImageView *emptyIv;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign, getter=isLoadFail) BOOL loadFail;


@end

@implementation SDGoodsListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style tabId:(NSString *)tabId{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        [self addMJRefresh];
        [self addMJMoreFoot];
        self.limit = @"20";
        self.page = @"1";
        self.tabId = tabId;
        [self initConfig];
        [self refreshAction];
    }
    return self;
}
- (void)initConfig{
    self.separatorInset = UIEdgeInsetsMake(0, 0.5, 0, 0);
    self.separatorColor = [UIColor colorWithHexString:@"0xededed"];
    self.delegate = self;
    self.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"SDGoodsCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:[SDGoodsCell cellIdentifier]];
    UINib *nib1 = [UINib nibWithNibName:@"SDSystemGroupGoodCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib1 forCellReuseIdentifier:[SDSystemGroupGoodCell cellIdentifier]];
    UINib *nib3 = [UINib nibWithNibName:@"SDDiscountGoodCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib3 forCellReuseIdentifier:[SDDiscountGoodCell cellIdentifier]];
    UINib *nib4 = [UINib nibWithNibName:@"SDSecondKillGoodCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib4 forCellReuseIdentifier:[SDSecondKillGoodCell cellIdentifier]];
    self.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableWithEndTime:) name:kNotifiRefreshListViewWithEndTime object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWithGoodId:) name:kNotifiRefreshGoodDetailVC object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark data
- (void)loadMoreAction{
    NSInteger pageValue = self.page.integerValue;
    self.page = [NSString stringWithFormat:@"%ld",(long)++ pageValue];
    SD_WeakSelf;
    [SDHomeDataManager refreshGoodListWithId:self.tabId limit:self.limit page:self.page completeBlock:^(id  _Nonnull mdoel) {
        SD_StrongSelf;
        [self.mj_footer endRefreshing];
        [self.dataArray addObjectsFromArray:mdoel];
        if (self.dataArray.count % self.limit.integerValue > 0) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadData];
    } failedBlock:^(id model){
        [self.mj_footer endRefreshing];
    }];
}
- (void)refreshAction{
    SD_WeakSelf;
    self.page = @"1";
    [SDHomeDataManager refreshGoodListWithId:self.tabId limit:self.limit page:self.page completeBlock:^(id  _Nonnull mdoel) {
        SD_StrongSelf;
        self.loadFail = NO;
        [self.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:mdoel];
        if (self.dataArray.count % self.limit.integerValue > 0) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadData];
    } failedBlock:^(id model){
        [self.mj_header endRefreshing];
         self.loadFail = YES;
        [self reloadData];
    }];

}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    SDGoodModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.type.integerValue == SDGoodTypeNamoal) {
        cell = [self dequeueReusableCellWithIdentifier:[SDGoodsCell cellIdentifier] forIndexPath:indexPath];
        SDGoodsCell *goodCell = (SDGoodsCell *)cell;
        goodCell.model = model;
    }else if (model.type.integerValue == SDGoodTypeGroup) {
        cell = [self dequeueReusableCellWithIdentifier:[SDSystemGroupGoodCell cellIdentifier] forIndexPath:indexPath];
        SDSystemGroupGoodCell *goodCell = (SDSystemGroupGoodCell *)cell;
        goodCell.model = model;
    }else if (model.type.integerValue == SDGoodTypeDiscount) {
        cell = [self dequeueReusableCellWithIdentifier:[SDDiscountGoodCell cellIdentifier] forIndexPath:indexPath];
        SDDiscountGoodCell *goodCell = (SDDiscountGoodCell *)cell;
        goodCell.model = model;
    }else if (model.type.integerValue == SDGoodTypeSecondkill) {
        cell = [self dequeueReusableCellWithIdentifier:[SDSecondKillGoodCell cellIdentifier] forIndexPath:indexPath];
        SDSecondKillGoodCell *goodCell = (SDSecondKillGoodCell *)cell;
        goodCell.model = model;
    }else{
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.goodDetailBlock){
        SDGoodModel *good = [self.dataArray objectAtIndex:indexPath.row];
        [SDStaticsManager umEvent:kgoods_item attr:@{@"_id":good.goodId,@"name":good.name,@"type":good.type}];
        self.goodDetailBlock(good);
    }
}

#pragma mark - action
- (void)emptyDataClick {
    [self.mj_header beginRefreshing];
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
        _emptyView.image = [UIImage cp_imageWithColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1] size:CGSizeMake(SCREEN_WIDTH, 120 + 14 + 35 + 27)];
//        _emptyView.backgroundColor = [UIColor clearColor];
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
#pragma mark notification
- (void)reloadTableWithEndTime:(NSNotification *)note{
    NSString *time = [note object];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
    for (SDGoodModel *good in self.dataArray) {
        if (good.type.integerValue == SDGoodTypeGroup || good.type.integerValue == SDGoodTypeSecondkill) {
            if ([good.endTime isEqualToString:time]) {
                [array removeObject:good];
            }
        }
    }
    self.dataArray = array;
    
    [self reloadData];
}
- (void)refreshWithGoodId:(NSNotification *)note{
    NSString *goodId = [note object];
    NSDictionary *dic = [SDCartDataManager arrayToHashDic:self.dataArray hashKey:@"goodId"];
    if ([dic objectForKey:goodId]) {
        [self refreshAction];
    }
    
}
#pragma suprer params
- (BOOL)refresTime{
    return YES;
}
@end
