//
//  SDGroupOrderTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGroupOrderTableView.h"
#import "SDGroupOderCell.h"

@interface SDGroupOrderTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SDGroupOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)initConfig{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"SDGroupOderCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:[SDGroupOderCell cellIdentifier]];
    
}
#pragma mark data
- (void)loadMoreAction{
    [self.mj_footer endRefreshing];
}
- (void)refreshAction{
    [self.mj_header endRefreshing];
}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SDGroupOderCell *cell = [self dequeueReusableCellWithIdentifier:[SDGroupOderCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
