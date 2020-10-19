//
//  SDAddressMgrViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressMgrViewController.h"
#import "SDAddAddressViewController.h"
#import "SDGetAddrListReqeust.h"
#import "SDDelAddrReqeust.h"
#import "SDNoDataView.h"

@interface SDAddressMgrViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressArr;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, strong) SDNoDataView *noDataView;

@end

@implementation SDAddressMgrViewController

static NSString * const CellID = @"SDAddressMgrCell<##>";
static CGFloat const HeaderViewH = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAddrList];
    [self initNav];
//    [self initHeaderView];
    [self initBottomView];
    [self initTableView];
}

- (void)initNav {
    self.navigationItem.title = @"地址管理";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    headerView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, HeaderViewH);
    [self.view addSubview:headerView];
    self.headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(HeaderViewH);
    }];
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor whiteColor];
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
    tableView.emptyDataSetSource = self;
    [tableView registerClass:[SDAddressMgrCell class] forCellReuseIdentifier:CellID];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 + kTopHeight);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addButton.mas_top).mas_equalTo(-20);
    }];
}

- (void)initBottomView {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
    addButton.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    [addButton addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.layer.cornerRadius = 22;
    [self.view addSubview:addButton];
    self.addButton = addButton;
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-20 - kBottomSafeHeight);
    }];
}

/** 检查地址列表的数量 大于 新增收货地址置灰  */
- (BOOL)checkAddressCount {
    if (self.addressArr.count >= 5) {
        self.addButton.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
        return YES;
    }else {
        self.addButton.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        return NO;
    }
}

#pragma mark - network
- (void)getAddrList {
    SDGetAddrListReqeust *request = [[SDGetAddrListReqeust alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDGetAddrListReqeust * _Nonnull request) {
        self.noDataView.loadFail = NO;
        [self.addressArr removeAllObjects];
        [self.addressArr addObjectsFromArray:request.addrList];
        if (self.selectedAddrModel) {
            for (SDAddressModel *model in self.addressArr) {
                if ([model.addrId isEqualToString:self.selectedAddrModel.addrId]) {
                    model.selected = YES;
                    break;
                }
            }
        }
        [self checkAddressCount];
        if (self.addressArr.count > 0) {
            self.tableView.backgroundColor = [UIColor whiteColor];
            self.view.backgroundColor = [UIColor whiteColor];
        }else {
            self.tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
            self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
        }
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.noDataView.loadFail = YES;
        [self.tableView reloadData];
    }];
}

- (void)deleteAddrNetWorkForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"deldededede");
    SDAddressModel *model = self.addressArr[indexPath.row];
    if (!model.addrId || [model.addrId isEmpty]) {
        return;
    }
    SDDelAddrReqeust *request = [[SDDelAddrReqeust alloc] init];
    request.addrId = model.addrId;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"地址已删除"];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiAddressUpdate object:nil];
        [self.addressArr removeObjectAtIndex:indexPath.row];
        [self checkAddressCount];
        [self.tableView reloadData];
        if (self.selectedAddrModel) {
            if ([model.addrId isEqualToString:self.selectedAddrModel.addrId]) {
                if (self.selectedAddrBlock) {
                    self.selectedAddrBlock(model, YES);
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithErrString:@"地址删除失败，请重新设置"];
    }];
}


#pragma mark - action
- (void)addAddressClick {
    [SDStaticsManager umEvent:kaddress_add];
    if ([self checkAddressCount]) {
        [SDToastView HUDWithWarnString:@"超出最大地址数量，请删除无效地址"];
        return;
    }
    SDAddAddressViewController *vc = [[SDAddAddressViewController alloc] init];
    SD_WeakSelf
    vc.block = ^(SDAddressModel * _Nonnull addrModel, SDAddrStatusType statusType) {
        SD_StrongSelf
        if (self.selectedAddrModel) {
            if ([addrModel.addrId isEqualToString:self.selectedAddrModel.addrId]) {
                if (self.selectedAddrBlock) {
                    BOOL isDel = statusType == SDAddrStatusTypeDelete ? YES : NO;
                    self.selectedAddrBlock(addrModel, isDel);
                }
            }
        }
        [self getAddrList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDAddressMgrCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    SDAddressModel *model = self.addressArr[indexPath.row];
    SD_WeakSelf
    cell.block = ^{
        SD_StrongSelf
        SDAddAddressViewController *vc = [[SDAddAddressViewController alloc] init];
        vc.addressModel = model;
        vc.update = YES;
        vc.block = ^(SDAddressModel * _Nonnull addrModel, SDAddrStatusType statusType) {
            SD_StrongSelf
            if (self.selectedAddrModel) {
                if ([addrModel.addrId isEqualToString:self.selectedAddrModel.addrId]) {
                    if (self.selectedAddrBlock) {
                        BOOL isDel = statusType == SDAddrStatusTypeDelete ? YES : NO;
                        self.selectedAddrBlock(addrModel, isDel);
                    }
                }
            }
            [self getAddrList];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedAddrModel) {
        SDAddressModel *model = self.addressArr[indexPath.row];
        if (![model.addrId isEqualToString:self.selectedAddrModel.addrId]) {
            if (self.selectedAddrBlock) {
                self.selectedAddrBlock(model, NO);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [SDStaticsManager umEvent:kaddress_del];
    [self showDelPopView:indexPath];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    if (@available(iOS 11.0, *)) {
        SD_WeakSelf
        UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            SD_StrongSelf
            [self showDelPopView:indexPath];
        }];
        delete.backgroundColor = [UIColor colorWithRGB:0xfd7573];
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
        return config;
     } else {
         return nil;
    }
}

- (void)showDelPopView:(NSIndexPath *)indexPath {
    SD_WeakSelf
    [SDPopView showPopViewWithContent:@"确认删除该地址吗" noTap:NO confirmBlock:^{
        SD_StrongSelf
        [self deleteAddrNetWorkForRowAtIndexPath:indexPath];
    } cancelBlock:^{

    }];
}

#pragma mark - DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.addressArr.count > 0) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
    }else {
        self.tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
        self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    }
    return self.noDataView;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -20;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self getAddrList];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - lazy
- (NSMutableArray *)addressArr {
    if (!_addressArr) {
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}

- (SDNoDataView *)noDataView {
    if (!_noDataView) {
        NSString *tips = @"您还没有添加收货地址哦";
        SD_WeakSelf
       _noDataView = [SDNoDataView noDataViewWithTips:tips loadClickBlock:^{
           SD_StrongSelf
           [self getAddrList];
        }];
    }
    return _noDataView;
}

@end
