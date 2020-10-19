//
//  SDAmoyMoneyViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAmoyMoneyViewController.h"
#import "SDAmoyMoneyCell.h"

@interface SDAmoyMoneyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SDAmoyMoneyViewController

static NSString * const CellID = @"SDAmoyMoneyCell<##>";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor randomColor];
    [self initTableView];
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
    [tableView registerClass:[SDAmoyMoneyCell class] forCellReuseIdentifier:CellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}



#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDAmoyMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
