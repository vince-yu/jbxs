//
//  SDRepoListTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRepoListTableView.h"
#import "SDRepoCell.h"
#import "SDCartDataManager.h"
#import "SDSKLimitCartList.h"

@interface SDRepoListTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation SDRepoListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)initConfig{
//    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    [self addMJRefresh];
//    [self addMJMoreFoot];
    self.tableFooterView = [UIView new];
    UINib *nib = [UINib nibWithNibName:@"SDRepoCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:[SDRepoCell cellIdentifier]];
    
    
    
}
#pragma mark data
- (void)refreshAction{
    SD_WeakSelf;
    [SDCartDataManager cartOrderRepoListArrayCompleteBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
        self.dataArray = model;
        [self updateSelectStatus];
        [self reloadData];
        [self.mj_header endRefreshing];
    } failedBlock:^(id model){
        [self.mj_header endRefreshing];
    }];
}
- (void)updateSelectStatus{
    SDCartRepoListModel *selectRepo = [SDCartDataManager sharedInstance].selectRepoModel;
    for (SDCartRepoListModel *repo in self.dataArray) {
        if ([selectRepo.repoId isEqualToString:repo.repoId]) {
            repo.selected = @"1";
        }
    }
}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDCartRepoListModel *repo = [self.dataArray objectAtIndex:indexPath.row];
    SDRepoCell *cell = [self dequeueReusableCellWithIdentifier:[SDRepoCell cellIdentifier] forIndexPath:indexPath];
    cell.repoModel = repo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:247 / 255.0 alpha:1];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
//- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 135;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDCartRepoListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.selected) {
        return;
    }
    [SDCartDataManager sharedInstance].selectRepoModel = model;
    if (self.selectBlock) {
        self.selectBlock();
    }
    [SDCartDataManager checkPrePayData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiCartPrePayReload object:nil];
}


@end
