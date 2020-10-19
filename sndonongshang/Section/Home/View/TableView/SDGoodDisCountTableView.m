//
//  SDGoodDisCountTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodDisCountTableView.h"
#import "SDGoodDetailCell.h"
#import "SDGoodHeadCell.h"
#import "SDGoodPictureCell.h"
#import "SDGroupMembeerCell.h"
#import "SDGroupRuleCell.h"
#import "SDHomeDataManager.h"
#import "SDGoodDetailModel.h"
#import "SDGoodRecommedCell.h"
#import "SDBannerCell.h"
#import "SDDiscountTitleCell.h"

@interface SDGoodDisCountTableView ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic ,strong) SDGoodModel *goodModel;

@property (nonatomic ,assign) SDGoodDetailType detailType;
@end


@implementation SDGoodDisCountTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style goodModel:(SDGoodModel *)goodModel{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.goodModel = goodModel;
        if (self.goodModel.type.integerValue == SDGoodTypeNamoal) {
            self.detailType = SDGoodDetailTypeNomal;
        }
        [self initConfig];
        [self refreshActionWithHiddenToast:NO];
    }
    return self;
}
- (void)initConfig{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    UINib *nib1 = [UINib nibWithNibName:@"SDGoodDetailCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib1 forCellReuseIdentifier:[SDGoodDetailCell cellIdentifier]];
    UINib *nib2 = [UINib nibWithNibName:@"SDGoodPictureCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib2 forCellReuseIdentifier:[SDGoodPictureCell cellIdentifier]];
    [self registerClass:[SDGoodRecommedCell class] forCellReuseIdentifier:[SDGoodRecommedCell cellIdentifier]];
    UINib *nib7 = [UINib nibWithNibName:@"SDBannerCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib7 forCellReuseIdentifier:[SDBannerCell cellIdentifier]];
    UINib *nib6 = [UINib nibWithNibName:@"SDDiscountTitleCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib6 forCellReuseIdentifier:[SDDiscountTitleCell cellIdentifier]];
    
}

#pragma mark data
- (void)loadMoreAction{
    [self.mj_footer endRefreshing];
}
- (void)refreshActionWithHiddenToast:(BOOL)hidden {
    SD_WeakSelf;
    [SDHomeDataManager refreshGoodDetailWithGoodModel:self.goodModel hiddenToast:hidden completeBlock:^(id  _Nonnull mdoel) {
        SD_StrongSelf;
        self.loadFail = NO;
        self.detailModel = mdoel;
        [self loadImages];
        [self reloadData];
        [self.mj_header endRefreshing];
        if (self.updateBlock) {
            self.updateBlock(self.detailModel.goodsremind,YES);
        }
        if (self.hiddeBarBlock) {
            if (self.detailModel.status.integerValue == SDCartListCellTypeNomal) {
                self.hiddeBarBlock(NO);
            }else{
                self.hiddeBarBlock(YES);
            }
            
        }
        if (self.CartCalculateBlock && !hidden) {
            self.CartCalculateBlock(self.detailModel);
        }
    } failedBlock:^(id model){
        self.loadFail = YES;
        self.hiddeBarBlock(YES);
        [self.mj_header endRefreshing];
    }];
}


#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self handleBannerCellWithIndexPath:indexPath];
        
    }else if (indexPath.section == 1) {
         cell = [self handleTitleCellWithIndexPath:indexPath];
    }else if (indexPath.section == 2) {
        SDGoodDetailCell *detailCell = [self dequeueReusableCellWithIdentifier:[SDGoodDetailCell cellIdentifier] forIndexPath:indexPath];
        detailCell.detailDic = self.detailModel.attr;
        cell = detailCell;
    }else if (indexPath.section == 4){
        SDGoodRecommedCell *headCell = [self dequeueReusableCellWithIdentifier:[SDGoodRecommedCell cellIdentifier] forIndexPath:indexPath];
        headCell.dataArray = self.detailModel.recommend;
        cell = headCell;
    }else{
        SDGoodPictureCell *picCell = [self dequeueReusableCellWithIdentifier:[SDGoodPictureCell cellIdentifier] forIndexPath:indexPath];
        picCell.imageUrl = [self.detailModel.detail objectAtIndex:indexPath.row];
        
        cell = picCell;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!section) {
        return 0.0001;
    }else if (section == 3){
        return 70;
    }
    return 10;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.detailModel.detail.count;
    }
    return 1;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.detailModel || (self.detailModel.status.integerValue != SDCartListCellTypeNomal)) {
        return 0;
    }
    if (self.detailModel.recommend.count) {
        return 5;
    }
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
        headView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 60)];
        view.backgroundColor = [UIColor whiteColor];
        [headView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(headView);
            make.top.mas_equalTo(10);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [view addSubview:lineView];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
        nameLabel.text = @"商品详情";
        
        [view addSubview:nameLabel];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(14);
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lineView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.mas_equalTo(15);
        }];
        
        return headView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat )sectionHeaderHeight{
    return 70;
}
- (NSString *)status{
    return self.detailModel.status;
}
@end
