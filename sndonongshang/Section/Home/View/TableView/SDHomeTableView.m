//
//  SDHomeTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeTableView.h"
#import "SDHomeHeaderTableViewCell.h"
#import "SDHomeCollectionTableViewCell.h"
#import "SDGoodsCell.h"
#import "SDHomeDataManager.h"
#import "SDHomeFloorModel.h"
#import "SDGoodModel.h"
#import "SDHomeCategroyModel.h"
#import "SDSystemGroupGoodCell.h"
#import "SDSecondKillGoodCell.h"
#import "SDDiscountGoodCell.h"
#import "SDHomeCategoryCell.h"
#import "SDHomeBannerModel.h"
#import "SDCartDataManager.h"

@interface SDHomeTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIImageView *bannerImageView;
@end

@implementation SDHomeTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfig];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableWithEndTime:) name:kNotifiRefreshListViewWithEndTime object:nil];
    }
    return self;
}
- (void)initConfig{
    self.separatorInset = UIEdgeInsetsMake(0.5, 0, 0, 0);
    self.separatorColor = [UIColor colorWithHexString:@"0xebebed"];
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [UIView new];
    UINib *nib = [UINib nibWithNibName:@"SDGoodsCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:[SDGoodsCell cellIdentifier]];
    UINib *nib1 = [UINib nibWithNibName:@"SDSystemGroupGoodCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib1 forCellReuseIdentifier:[SDSystemGroupGoodCell cellIdentifier]];
    [self registerClass:[SDHomeHeaderTableViewCell class] forCellReuseIdentifier:[SDHomeHeaderTableViewCell cellIdentifier]];
    [self registerClass:[SDHomeCollectionTableViewCell class] forCellReuseIdentifier:[SDHomeCollectionTableViewCell cellIdentifier]];
    UINib *nib3 = [UINib nibWithNibName:@"SDDiscountGoodCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib3 forCellReuseIdentifier:[SDDiscountGoodCell cellIdentifier]];
    UINib *nib4 = [UINib nibWithNibName:@"SDSecondKillGoodCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib4 forCellReuseIdentifier:[SDSecondKillGoodCell cellIdentifier]];
    
    [self registerClass:[SDHomeCategoryCell class] forCellReuseIdentifier:[SDHomeCategoryCell cellIdentifier]];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWithGoodId:) name:kNotifiRefreshGoodDetailVC object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark data
- (void)loadMoreAction{
    [self.mj_footer endRefreshing];
}
- (void)refreshAction{
    SD_WeakSelf;
    [SDHomeDataManager configHome:^(id model){
        SD_StrongSelf;
        [self reloadData];
        [self loadImages];
        [self.mj_header endRefreshing];
        
    } failedBlock:^(id model){
         [self.mj_header endRefreshing];
    }];
}
- (void)loadImages{
    NSArray *imageUrls = [SDHomeDataManager sharedInstance].bannerArray;
    SDHomeBannerModel *model = imageUrls.firstObject;
    NSString *imageUrl = model.picUrl;
    if (!imageUrl) {
        return;
    }
    [SDToastView show];
    SD_WeakSelf;
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [SDToastView dismiss];
        SD_StrongSelf;
        if (image) {
            [self reloadData];
        }
        
        
    }];
}
- (UIImageView *)bannerImageView{
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
    }
    return _bannerImageView;
}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && [self showBannerSection]) {
        if ([self bannerSectionCellCount] == 2) {
            if (indexPath.row == 0) {
                SDHomeHeaderTableViewCell *headCell = [self dequeueReusableCellWithIdentifier:[SDHomeHeaderTableViewCell cellIdentifier] forIndexPath:indexPath];
                [headCell reloadCategory];
//                SD_WeakSelf;
                cell = headCell;
            }else{
                SDHomeCategoryCell *headCell = [self dequeueReusableCellWithIdentifier:[SDHomeCategoryCell cellIdentifier] forIndexPath:indexPath];
                [headCell initCateGoryViewWithDataArray:[SDHomeDataManager sharedInstance].categoryArray];;
                SD_WeakSelf;
                headCell.clickCategoryBlock = ^(id  _Nonnull model) {
                    SD_StrongSelf;
                    SDHomeCategroyModel *categroy = (SDHomeCategroyModel *)model;
                    if (self.goodsListBlock) {
                        [SDStaticsManager umEvent:khome_channel attr:@{@"_id":categroy.tabId,@"name":categroy.name}];
                        self.goodsListBlock(categroy.tabId);
                    }
                };
                cell = headCell;
            }
        }else{
            if ([SDHomeDataManager sharedInstance].categoryArray.count) {
                SDHomeCategoryCell *headCell = [self dequeueReusableCellWithIdentifier:[SDHomeCategoryCell cellIdentifier] forIndexPath:indexPath];
                [headCell initCateGoryViewWithDataArray:[SDHomeDataManager sharedInstance].categoryArray];;
                SD_WeakSelf;
                headCell.clickCategoryBlock = ^(id  _Nonnull model) {
                    SD_StrongSelf;
                    SDHomeCategroyModel *categroy = (SDHomeCategroyModel *)model;
                    if (self.goodsListBlock) {
                        [SDStaticsManager umEvent:khome_channel attr:@{@"_id":categroy.tabId,@"name":categroy.name}];
                        self.goodsListBlock(categroy.tabId);
                    }
                };
                cell = headCell;
            }else{
                SDHomeHeaderTableViewCell *headCell = [self dequeueReusableCellWithIdentifier:[SDHomeHeaderTableViewCell cellIdentifier] forIndexPath:indexPath];
                [headCell reloadCategory];
                //                SD_WeakSelf;
                cell = headCell;
            }
        }
        
    }else{
        SDHomeFloorModel *floorModel = [[SDHomeDataManager sharedInstance].floorArray objectAtIndex:(indexPath.section ? indexPath.section - 1 : 0)];
        SDGoodModel *model = [floorModel.goods objectAtIndex:indexPath.row];
        [SDHomeDataManager sharedInstance].currentTime = model.currentTime;
        if (model.type.integerValue == SDGoodTypeNamoal) {
            cell = [self dequeueReusableCellWithIdentifier:[SDGoodsCell cellIdentifier] forIndexPath:indexPath];
            SDGoodsCell *goodCell = (SDGoodsCell *)cell;
            goodCell.where = SDGoodWhereTypeHome;
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
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && [self bannerSectionCellCount] == 1 && [SDHomeDataManager sharedInstance].categoryArray.count == 0){
        return 40;
    }
    if (section == 0 && [self bannerSectionCellCount] == 1 && [SDHomeDataManager sharedInstance].categoryArray.count != 0) {
        return 10;
    }
    if(section != 0 || (section == 0 && [self bannerSectionCellCount] == 0)){
        return 50;
    }
    return 0;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && [self showBannerSection]) {
        return [self bannerSectionCellCount];
    }else{
        SDHomeFloorModel *floorModel = [[SDHomeDataManager sharedInstance].floorArray objectAtIndex:section ? section - 1 : 0];
        return floorModel.goods.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 && [self bannerSectionCellCount] == 1 && [SDHomeDataManager sharedInstance].categoryArray.count == 0) {
        SDHomeFloorModel *floorModel = [SDHomeDataManager sharedInstance].floorArray[section - 1];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        titleLabel.textColor = [UIColor colorWithHexString:@"131413"];
        titleLabel.text = floorModel.name;
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.tag = 13000 + section;
        [moreBtn addTarget:self action:@selector(pushToGoodListVC:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        [moreBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:196/255.0 blue:199/255.0 alpha:1.0] forState:UIControlStateNormal];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"cart_select_time"];
        
        [titleView addSubview:imageView];
        [titleView addSubview:moreBtn];
        
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(5);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(9);
        }];
        
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(30);
            make.right.equalTo(imageView.mas_left).offset(-6);
            make.height.mas_equalTo(20);
        }];
        
        [titleView addSubview:lineView];
        [titleView addSubview:titleLabel];
        [view addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(14);
            make.centerY.equalTo(titleView.mas_centerY);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.height.mas_equalTo(20);
            //            make.height.mas_equalTo(148);
        }];
        
        UIView *headlineView = [[UIView alloc] init];
        headlineView.backgroundColor = [UIColor colorWithHexString:@"0xededed"];
        [view addSubview:headlineView];
        [headlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(view);
            make.height.mas_equalTo(0.5);
        }];
        
        return view;
    }
    if (section != 0 || (section == 1 && [SDHomeDataManager sharedInstance].categoryArray.count) || (section == 0 && [self bannerSectionCellCount] == 0)) {
        SDHomeFloorModel *floorModel = [[SDHomeDataManager sharedInstance].floorArray objectAtIndex:(section ? section - 1 : 0)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        titleLabel.textColor = [UIColor colorWithHexString:@"131413"];
        titleLabel.text = floorModel.name;
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.tag = 13000 + section;
        [moreBtn addTarget:self action:@selector(pushToGoodListVC:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        [moreBtn setTitleColor:[UIColor colorWithRed:195/255.0 green:196/255.0 blue:199/255.0 alpha:1.0] forState:UIControlStateNormal];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"cart_select_time"];
        
        [titleView addSubview:imageView];
        [titleView addSubview:moreBtn];
        
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(5);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(9);
        }];
        
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(30);
            make.right.equalTo(imageView.mas_left).offset(-6);
            make.height.mas_equalTo(20);
        }];
        
        [titleView addSubview:lineView];
        [titleView addSubview:titleLabel];
        [view addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(14);
            make.centerY.equalTo(titleView.mas_centerY);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.height.mas_equalTo(20);
//            make.height.mas_equalTo(148);
        }];
        
        UIView *headlineView = [[UIView alloc] init];
        headlineView.backgroundColor = [UIColor colorWithHexString:@"0xededed"];
        [view addSubview:headlineView];
        [headlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(view);
            make.height.mas_equalTo(0.5);
        }];
        
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        return view;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self showBannerSection]) {
        return 1 + [SDHomeDataManager sharedInstance].floorArray.count;
    }else{
        return [SDHomeDataManager sharedInstance].floorArray.count;
    }
    
}
- (NSInteger )bannerSectionCellCount{
    NSInteger count = 0;
    if ([self showBannerSection]) {
        if ([SDHomeDataManager sharedInstance].categoryArray.count && [SDHomeDataManager sharedInstance].bannerArray.count) {
            return 2;
        }else{
            return 1;
        }
    }
    return count;
}
- (BOOL )showBannerSection{
    if (![SDHomeDataManager sharedInstance].categoryArray.count && ![SDHomeDataManager sharedInstance].bannerArray.count) {
        return NO;
    }else{
        return YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (self.goodDetailBlock) {
            SDHomeFloorModel *floorModel = [SDHomeDataManager sharedInstance].floorArray[indexPath.section - 1];
            SDGoodModel *model = [floorModel.goods objectAtIndex:indexPath.row];
            [SDStaticsManager umEvent:kgoods_home_item attr:@{@"_id":model.goodId,@"name":model.name,@"type":model.type}];
            self.goodDetailBlock(model);
        }
    }else{
        if (self.goodDetailBlock && [self bannerSectionCellCount] == 0) {
            SDHomeFloorModel *floorModel = [[SDHomeDataManager sharedInstance].floorArray objectAtIndex:(indexPath.section ? indexPath.section -1 : 0)];
            SDGoodModel *model = [floorModel.goods objectAtIndex:indexPath.row];
            [SDStaticsManager umEvent:kgoods_home_item attr:@{@"_id":model.goodId,@"name":model.name,@"type":model.type}];
            self.goodDetailBlock(model);
        }
    }
    
}
- (CGFloat )sectionHeaderHeight{
    return 40;
}
- (void)pushToGoodListVC:(UIButton *)btn{
    if (self.goodsListBlock) {
        SDHomeFloorModel *floorModel = [[SDHomeDataManager sharedInstance].floorArray objectAtIndex:(btn.tag - 13000 ? btn.tag - 13000 - 1 : 0)];
        [SDStaticsManager umEvent:khome_floor attr:@{@"_id":floorModel.tabId,@"name":floorModel.name}];
        self.goodsListBlock(floorModel.tabId);
    }
}
- (void)reloadTableWithEndTime:(NSNotification *)note{
    NSString *time = [note object];
    for (SDHomeFloorModel *floorModel in [SDHomeDataManager sharedInstance].floorArray)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:floorModel.goods];
        for (SDGoodModel *good in floorModel.goods) {
            if (good.type.integerValue == SDGoodTypeGroup || good.type.integerValue == SDGoodTypeSecondkill) {
                if ([good.endTime isEqualToString:time]) {
                    [array removeObject:good];
                }
            }
        }
        floorModel.goods = array;
    }
    [self reloadData];
}
- (void)refreshWithGoodId:(NSNotification *)note{
    NSString *goodId = [note object];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (SDHomeFloorModel *model in [SDHomeDataManager sharedInstance].floorArray) {
        [dataArray addObjectsFromArray:model.goods];
    }
    NSDictionary *dic = [SDCartDataManager arrayToHashDic:dataArray hashKey:@"goodId"];
    if ([dic objectForKey:goodId]) {
        [self refreshAction];
    }
    
}
#pragma suprer params
- (BOOL)refresTime{
    return YES;
}
@end
