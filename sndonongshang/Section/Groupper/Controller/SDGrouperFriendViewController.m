//
//  SDGrouperFriednViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperFriendViewController.h"
#import "SDGrouperFriendCell.h"
#import "SDGrouperFriendModel.h"
#import "SDGrouperFriendListRequest.h"
#import "SDShareManager.h"
#import "SDJumpManager.h"
#import "SDBaseTableView.h"

@interface SDGrouperFriendViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic ,strong) UIView *topView;
@property (nonatomic ,strong) UIImageView *greenBGView;
@property (nonatomic ,strong) UILabel *totalTitleLabel;
@property (nonatomic ,strong) UILabel *totalLabel;
@property (nonatomic ,strong) UIButton *inviteBtn;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UILabel *titleLable;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) SDBaseTableView *contentTableView;
@property (nonatomic ,strong) UIView *tableHeaderView;

@property (nonatomic ,strong) UIView *tipsView;
@property (nonatomic ,strong) UILabel *tipsLabel;
@property (nonatomic ,strong) UIButton *beGrouperBtn;

@property (nonatomic ,strong) NSString *page;
@property (nonatomic ,strong) NSString *limit;
@end

@implementation SDGrouperFriendViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = @"1";
        self.limit = @"20";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    
    [self initTableHeadView];
    
    [self initTipsView];
    
    [self initSubViews];
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal && ![SDUserModel sharedInstance].isRegiment) {
        self.contentTableView.hidden = YES;
        self.tipsView.hidden = NO;
    }else{
        self.contentTableView.hidden = NO;
        self.tipsView.hidden = YES;
        [self.contentTableView.mj_header beginRefreshing];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal && ![SDUserModel sharedInstance].isRegiment) {
        
    }else{
        [self changeNavType:SDBSVCNaveTypeGreen];
    }
}
- (void)initNav{
    self.navigationItem.title = @"我的好友";
}
- (void)initTipsView{
    [self.view addSubview:self.tipsView];
    [self.tipsView addSubview:self.tipsLabel];
    [self.tipsView addSubview:self.beGrouperBtn];
    
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self.beGrouperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(90);
    }];
}
- (void)initSubViews{
    [self.view addSubview:self.contentTableView];
    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight);
    }];
}
- (void)initTableHeadView{
    [self.tableHeaderView addSubview:self.topView];
    [self.tableHeaderView addSubview:self.lineView];
    [self.tableHeaderView addSubview:self.titleLable];
    
    self.titleLable.hidden = YES;
    self.lineView.hidden = YES;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tableHeaderView);
        make.height.mas_equalTo(150 - kNavBarHeight - 20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableHeaderView);
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.topView.mas_bottom).offset(20);
        make.height.mas_equalTo(15);
    }];
    
    [self.topView addSubview:self.greenBGView];
    [self.topView addSubview:self.totalTitleLabel];
    [self.topView addSubview:self.totalLabel];
    [self.topView addSubview:self.inviteBtn];
    
    [self.greenBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.topView);
    }];
    
    [self.totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(13);
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.totalTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.topView);
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
- (SDBaseTableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[SDBaseTableView alloc] init];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"SDGrouperFriendCell" bundle: [NSBundle mainBundle]];
        [_contentTableView registerNib:nib forCellReuseIdentifier:[SDGrouperFriendCell getIdentifier]];
        SD_WeakSelf;
        _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            SD_StrongSelf;
            [self refreshAction];
        }];
        _contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            SD_StrongSelf;
            [self loadMoreAction];
        }];
        
    }
    return _contentTableView;
}
- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeaderView;
}
- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont fontWithName:kSDPFMediumFont size:25];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.text = @"0";
    }
    return _totalLabel;
}
- (UILabel *)totalTitleLabel{
    if (!_totalTitleLabel) {
        _totalTitleLabel = [[UILabel alloc] init];
        _totalTitleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        _totalTitleLabel.textColor = [UIColor whiteColor];
        _totalTitleLabel.text = @"好友总人数";
    }
    return _totalTitleLabel;
}
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setTitle:@"邀请更多好友" forState:UIControlStateNormal];
        _inviteBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
        _inviteBtn.backgroundColor = [UIColor clearColor];
        _inviteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _inviteBtn.layer.borderWidth = 0.4;
        _inviteBtn.layer.cornerRadius = 15;
        
        [_inviteBtn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        
    }
    return _topView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xededed"];
    }
    return _lineView;
}
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _titleLable.textColor = [UIColor colorWithHexString:@"0x131413"];
        _titleLable.text = @"好友购买TOP榜";
    }
    return _titleLable;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (UIView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
        
    }
    return _tipsView;
}
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _tipsLabel.text = @"1、申请成为团长后，可以邀请好友赚佣金\n2、你的好友通过你的分享购买商品后，你可以拿佣金。\n3、你和好友建立的是永久绑定关系 ，只要好友下单，你都可以拿佣金";
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}
- (UIButton *)beGrouperBtn{
    if (!_beGrouperBtn) {
        _beGrouperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beGrouperBtn setTitle:@"申请成为团长" forState:UIControlStateNormal];
        [_beGrouperBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _beGrouperBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _beGrouperBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:18];
        _beGrouperBtn.layer.cornerRadius = 22.5;
        [_beGrouperBtn addTarget:self action:@selector(beGrouperAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beGrouperBtn;
}
#pragma mark Action
- (void)inviteAction{
    [SDJumpManager jumpUrl:kH5NewUser push:YES parentsController:self animation:YES];
}
- (void)beGrouperAction{
    [SDJumpManager jumpUrl:KUserBeGrouperUrl push:YES parentsController:self animation:YES];
}
- (void)refreshAction{
    self.page = @"1";
    [self loadListData];
}
- (void)loadMoreAction{
    NSInteger page = self.page.integerValue;
    self.page = [NSString stringWithFormat:@"%ld", ++page];
    [self loadListData];
}
- (void)loadListData{
    SDGrouperFriendListRequest *request = [[SDGrouperFriendListRequest alloc] init];
    request.page = self.page;
    request.limit = self.limit;
    SD_WeakSelf;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDGrouperFriendListRequest * _Nonnull request) {
        SD_StrongSelf;
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
        if (self.page.integerValue == 1) {
            [self.dataArray removeAllObjects];
            if (request.listModel.list.count % self.limit.integerValue != 0) {
                [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.contentTableView.mj_footer resetNoMoreData];
            }
            
        }else{
            if (request.listModel.list.count % self.limit.integerValue != 0) {
                [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.dataArray addObjectsFromArray:request.listModel.list];
        
        self.totalLabel.text = request.listModel.count;
        [self updateViewStatus];
        [self.contentTableView reloadData];
    } failure:^(__kindof SDGrouperFriendListRequest * _Nonnull request) {
        SD_StrongSelf;
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
    }];
}
- (void)updateViewStatus{
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal && ![SDUserModel sharedInstance].isRegiment) {
        return;
    }
    if (self.dataArray.count == 0) {
        self.titleLable.hidden = YES;
        self.lineView.hidden = YES;
        [self.topView addSubview:self.tipsLabel];
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.greenBGView.mas_bottom).offset(60);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
    }else{
        self.titleLable.hidden = NO;
        self.lineView.hidden = NO;
        [self.tipsView removeFromSuperview];
    }
}
#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDGrouperFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDGrouperFriendCell getIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
//    cell.sepa
    return cell;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (self.dataArray != 0 && [SDUserModel sharedInstance].role == SDUserRolerTypeNormal && ![SDUserModel sharedInstance].isRegiment) {
    
        height = 150 - kNavBarHeight - 20 + 55 + 200;
    }else{
        height = 150 - kNavBarHeight - 20 + 55;
    }
    self.contentTableView.sectionHeaderHeight = height;
    return height;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeaderView;
}

@end
