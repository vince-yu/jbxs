//
//  SDBaseTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"


@interface SDBaseTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SDBaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTime) name:kNotifiListRefreshTime object:nil];
    }
    return self;
}
- (void)addMJRefresh{
    SD_WeakSelf;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SD_StrongSelf;
        [self refreshAction];
    }];
}
- (void)addMJMoreFoot{
    SD_WeakSelf;
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SD_StrongSelf;
        [self loadMoreAction];
    }];
}
- (void)refreshAction{
    
}
- (void)loadMoreAction{
    
}
#pragma mark delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger )numberOfSections{
    return 1;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.sectionHeaderHeight < 0) {
        return;
    }
    if(scrollView == self) {
        CGFloat sectionHeaderHeight = self.sectionHeaderHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiListRefreshTime object:nil];
}
//进入前台 刷新服务器时间
- (void)refreshTime{
    if (self.refresTime) {
        [self reloadData];
    }
}
#pragma mark 缓存已有的cell高度，避免自动布局时，cell乱跳
- (NSMutableDictionary *)cellHightDict {
    if (!_cellHightDict) {
        _cellHightDict = [NSMutableDictionary new];
    }
    return _cellHightDict;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = cell.height;
    [self.cellHightDict setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%ld:%ld", (long)indexPath.section,(long)indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyStr = [NSString stringWithFormat:@"%ld:%ld",indexPath.section,indexPath.row];
    NSNumber *height = [self.cellHightDict objectForKey:keyStr];
    if (height) {
        return height.floatValue;
    }
    return UITableViewAutomaticDimension;
}
@end
