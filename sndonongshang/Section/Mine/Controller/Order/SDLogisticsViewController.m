//
//  SDLogisticsViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLogisticsViewController.h"
#import "SDLogisticsModel.h"
#import "SDLogisticsReqest.h"
#import "SDLogisticsCell.h"

@interface SDLogisticsViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UIImageView *greenBGView;
@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,strong) UIImageView *logisticsImageView;
@property (nonatomic ,strong) UILabel *logisticsLabel;
@property (nonatomic ,strong) UILabel *logisticsCodeLabel;

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic ,strong) SDLogisticsListModel *listModel;

@end

@implementation SDLogisticsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    
    [self initTableHeadView];
    
    
    [self initSubViews];
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal) {
        self.contentTableView.hidden = YES;
        
    }else{
        self.contentTableView.hidden = NO;
        
        [self.contentTableView.mj_header beginRefreshing];
    }
    
}
- (void)initNav{
    self.navigationItem.title = @"物流详情";
}

- (void)initSubViews{
    [self.view addSubview:self.contentTableView];
    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.top.mas_equalTo(kTopHeight);
    }];
}
- (void)initTableHeadView{
    [self.tableHeaderView addSubview:self.greenBGView];
    [self.tableHeaderView addSubview:self.contentView];
    
    [self.greenBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tableHeaderView);
        make.height.mas_equalTo(150 - kNavBarHeight - 20);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.greenBGView.mas_bottom);
    }];
    
    [self.contentView addSubview:self.logisticsImageView];
    [self.contentView addSubview:self.logisticsLabel];
    [self.contentView addSubview:self.logisticsCodeLabel];
    
    
    
    [self.logisticsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self.contentView);
    }];
    [self.logisticsCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsImageView.mas_right).offset(10);
        make.top.equalTo(self.logisticsLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsImageView.mas_right).offset(10);
        make.top.equalTo(self.logisticsImageView).offset(5);
        make.height.mas_equalTo(16);
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark lazy
- (UIImageView *)greenBGView {
    if (!_greenBGView) {
        _greenBGView = [[UIImageView alloc] init];
        _greenBGView.image = [UIImage cp_imageByCommonGreenWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150 - kNavBarHeight - 20)];
    }
    return _greenBGView;
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.backgroundColor = [UIColor clearColor];
        [_contentTableView registerClass:[SDLogisticsCell class] forCellReuseIdentifier:[SDLogisticsCell getIdentifier]];
        SD_WeakSelf;
        _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            SD_StrongSelf;
            [self loadListData];
        }];
    }
    return _contentTableView;
}
- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    return _tableHeaderView;
}
- (UILabel *)logisticsLabel{
    if (!_logisticsLabel) {
        _logisticsLabel = [[UILabel alloc] init];
        _logisticsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _logisticsLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _logisticsLabel.text = @"0";
    }
    return _logisticsLabel;
}
- (UILabel *)logisticsCodeLabel{
    if (!_logisticsCodeLabel) {
        _logisticsCodeLabel = [[UILabel alloc] init];
        _logisticsCodeLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
        _logisticsCodeLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
//        _logisticsCodeLabel.text = @"好友总人数（人）：";
    }
    return _logisticsCodeLabel;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10.0;
        _contentView.layer.shadowColor = [UIColor colorWithHexString:@"0x888686"].CGColor;
        _contentView.layer.shadowRadius = 8.0;
        
        _contentView.layer.shadowOpacity = 0.16;
        _contentView.layer.shadowOffset = CGSizeMake(1, 1);
    }
    return _contentView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (UIImageView *)logisticsImageView{
    if (!_logisticsImageView) {
        _logisticsImageView = [[UIImageView alloc] init];
        _logisticsImageView.image = [UIImage imageNamed:@"order_logistics_image"];
    }
    return _logisticsImageView;
}
#pragma mark Action
- (void)loadListData{
    SDLogisticsReqest *request = [[SDLogisticsReqest alloc] init];
    request.orderId = self.orderId;
    SD_WeakSelf;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDLogisticsReqest * _Nonnull request) {
        SD_StrongSelf;
        [self.contentTableView.mj_header endRefreshing];
        [self handleExpressListArray:request.listModel.list];
        self.listModel = request.listModel;
        self.logisticsLabel.text = self.listModel.expressCom;
        self.logisticsCodeLabel.text = [NSString stringWithFormat:@"快递单号：%@",self.listModel.expressNo.length ? self.listModel.expressNo : @"--"];
        [self.contentTableView reloadData];
    } failure:^(__kindof SDLogisticsReqest * _Nonnull request) {
        SD_StrongSelf;
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
    }];
}
- (void)handleExpressListArray:(NSArray *)array{
    [self.dataArray removeAllObjects];
    for (NSInteger i = 0; i < array.count; i ++) {
        SDLogisticsModel *model = [array objectAtIndex:i];
        if (i == 0) {
            model.status = SDLogisticsStatusFinal;
        }else if (i == array.count -1){
            model.status = SDLogisticsStatusStart;
        }else{
            model.status = SDLogisticsStatusProcess;
        }
        [self.dataArray addObject:model];
    }
}
#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDLogisticsCell getIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    //    cell.sepa
    return cell;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.listModel) {
        return 1;
    }
    return 0;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150 - kNavBarHeight - 20 + 55 + 20;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeaderView;
}

@end
