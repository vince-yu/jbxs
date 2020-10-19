//
//  SDChooseAddressViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChooseAddressViewController.h"
#import "SDAddressCell.h"
#import "SDLocationCell.h"
#import "SDMyOrderViewController.h"
#import "SDOrderDetailViewController.h"

@interface SDChooseAddressViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nearArr;
@end

@implementation SDChooseAddressViewController

static CGFloat const topViewH = 44;
static CGFloat const bottomH = 58;
static NSString * const locationCellID = @"SDLocationCell";
static NSString * const addressCellID = @"SDAddressCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initTopView];
    [self initBottomView];
    [self initTableView];
}

- (void)initNav {
    self.navigationItem.title = @"选择地址";
}

- (void)initTopView {
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(topViewH);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor colorWithRGB:0xf5f6f7];
    contentView.userInteractionEnabled = YES;
    [contentView setCornerRadius:15];
    [topView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *chooseCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseCityBtn setTitle:@"成都市" forState:UIControlStateNormal];
    [chooseCityBtn setTitleColor:[UIColor colorWithHexString:kSDMainTextColor] forState:UIControlStateNormal];
    chooseCityBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    [contentView addSubview:chooseCityBtn];
    chooseCityBtn.frame = CGRectMake(0, 0, 80, 30);
    [chooseCityBtn addRightBorderWithColor:[UIColor colorWithHexString:kSDGrayTextColor] andWidth:1];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"请输入收货地址";
    addressLabel.font =  [UIFont fontWithName:kSDPFMediumFont size:13];;
    addressLabel.textColor = [UIColor colorWithHexString:kSDGrayTextColor];
    [contentView addSubview:addressLabel];
    addressLabel.userInteractionEnabled = NO;
    addressLabel.frame = CGRectMake(90, 0, SCREEN_WIDTH - 15 * 2 - 80 - 10, 30);
}

- (void)initBottomView {
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    [addAddressBtn setTitleColor:[UIColor colorWithHexString:kSDMainTextColor] forState:UIControlStateNormal];
    [addAddressBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressBtn];
    [addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(- kBottomSafeHeight);
        make.height.mas_equalTo(bottomH);
    }];
}

- (void)initTableView {
    CGFloat y = kTopHeight + topViewH;
    CGFloat h = SCREEN_HEIGHT - y - bottomH;
    CGRect frame = CGRectMake(0, y, SCREEN_WIDTH, h);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithRGB:0xefeff4];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [tableView registerClass:[SDAddressCell class] forCellReuseIdentifier:addressCellID];
    [tableView registerClass:[SDLocationCell class] forCellReuseIdentifier:locationCellID];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - action
- (void)addAddressBtnClick {
//    SDMyOrderViewController *vc = [[SDMyOrderViewController alloc] init];
    SDOrderDetailViewController *vc = [[SDOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 4;
    return self.nearArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SDLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCellID];
        return cell;
    }
    
    SDAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellID];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        YYLabel *label = [[YYLabel alloc] init];
        label.numberOfLines = 2;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"因各地区商品可能存在差异，请选择准确的收货地址\n当前地址"];
        text.yy_font = [UIFont systemFontOfSize:12];
        text.yy_color = [UIColor colorWithHexString:kSDOrangeTextColor];
        [text yy_setColor:[UIColor colorWithHexString:kSDSecondaryTextColor] range:NSMakeRange(24, 4)];
        text.yy_lineSpacing = 9;
        label.attributedText = text;
        label.frame = CGRectMake(15, 0, SCREEN_WIDTH - 15, 55);
        [headerView addSubview:label];
    }else {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"附近位置";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
        label.frame = CGRectMake(15, 0, SCREEN_WIDTH - 15, 32);
        [headerView addSubview:label];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55;
    }
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}



#pragma mark - lazy
- (NSMutableArray *)nearArr {
    if (!_nearArr) {
        _nearArr = [NSMutableArray array];
    }
    return _nearArr;
}

@end
