//
//  SDCartListTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartListTableView.h"
#import "SDCartListCell.h"
#import "SDCartDataManager.h"
#import "SDSKLimitCartList.h"

@interface SDCartListTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) UIView *empityView;
@property (nonatomic ,strong) UIButton *addBtn;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation SDCartListTableView

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
    UINib *nib = [UINib nibWithNibName:@"SDCartListCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:[SDCartListCell cellIdentifier]];
    UINib *nib1 = [UINib nibWithNibName:@"SDSKLimitCartList" bundle: [NSBundle mainBundle]];
    [self registerNib:nib1 forCellReuseIdentifier:[SDSKLimitCartList cellIdentifier]];
    [self addSubview:self.empityView];
    [self loadEmpityView];
    [self.empityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(220);
    }];
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}
- (UIView *)empityView{
    if (!_empityView) {
        _empityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    }
    return _empityView;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor colorWithHexString:@"0x131413"] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        _addBtn.layer.borderWidth = 1.0;
        _addBtn.layer.cornerRadius = 13.5;
        _addBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        _addBtn.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
        [_addBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchDown];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
    }
    return _addBtn;
}
- (void)loadEmpityView{
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_no_good"]];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您还没有添加商品哦";
    titleLabel.textColor = [UIColor colorWithHexString:@"0x848487"];
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    [titleLabel sizeToFit];
    
    
    
    [self.empityView addSubview:image];
    [self.empityView addSubview:titleLabel];
    [self.empityView addSubview:self.addBtn];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.empityView);
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(120);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.empityView);
        make.top.equalTo(image.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(titleLabel.width);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.empityView);
        make.top.equalTo(titleLabel.mas_bottom).offset(35);
        make.height.mas_equalTo(27);
        make.width.mas_equalTo(75);
    }];
}
- (void)pushAction{
    [_addBtn setTitleColor:[UIColor colorWithHexString:@"0xF5F6F5"] forState:UIControlStateNormal];
    _addBtn.layer.borderWidth = 0.0;
    _addBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
}
- (void)addAction{
    self.viewController.tabBarController.selectedIndex = 0;
}
- (void)upAction{
    [_addBtn setTitleColor:[UIColor colorWithHexString:@"0x131413"] forState:UIControlStateNormal];
    _addBtn.layer.borderWidth = 1.0;
    _addBtn.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
}
#pragma mark data
- (void)refreshAction{
    SD_WeakSelf;
    [SDCartDataManager refreshCartListCompleteBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
        self.dataArray = [SDCartDataManager sharedInstance].cartListArray;
        [self reloadData];
        [self.mj_header endRefreshing];
        [self updateViewStatus];
    } failedBlock:^(id model){
        [self.mj_header endRefreshing];
    } hideHud:NO];
}
- (void)updateViewStatus{
    if (self.dataArray.count) {
        self.empityView.hidden = YES;
    }else{
        self.empityView.hidden = NO;
    }
    if (self.block) {
        self.block();
    }
}
- (void)deleteAction:(NSIndexPath *)index{
    SDGoodModel *good = [self.dataArray objectAtIndex:index.section];
    SD_WeakSelf;
    [SDCartDataManager deleteCartGood:good completeBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
        [self deleteSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:UITableViewRowAnimationLeft];
        [SDToastView HUDWithString:@"删除商品成功！"];
        [self updateViewStatus];
    } failedBlock:^(id model){
        SD_StrongSelf;
        [self refreshAction];
    }];
}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SDGoodModel *good = [self.dataArray objectAtIndex:indexPath.row];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.textLabel.text =good.name;
//    return cell;
    SDGoodModel *good = [self.dataArray objectAtIndex:indexPath.section];
    if (good.moreModel.type == SDCalculateTypeSecondKillUserLimit || good.moreModel.type == SDCalculateTypeSecondKillUserNone || good.moreModel.type == SDCalculateTypeSecondKillUserLimitNoBuy || good.moreModel.type == SDCalculateTypeSecondKillGoodLimitBeyond) {
        SDSKLimitCartList *cell = [self dequeueReusableCellWithIdentifier:[SDSKLimitCartList cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = good;
        return cell;
    }else{
        SDCartListCell *cell = [self dequeueReusableCellWithIdentifier:[SDCartListCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = good;
        return cell;
    }
    
    
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count - 1) {
        return 20;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 10;
}

//- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 135;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDGoodModel *good = [self.dataArray objectAtIndex:indexPath.section];
    [SDStaticsManager umEvent:kgoods_cart_item attr:@{@"_id":good.goodId,@"name":good.name,@"type":good.type}];
    if (good.status.integerValue != SDCartListCellTypeNomal) {
        SD_WeakSelf;
        [SDPopView showPopViewWithContent:@"点击确定后将该商品移出购物车，点击取消保留该商品。" noTap:NO confirmBlock:^{
            SD_StrongSelf;
            [self deleteAction:indexPath];
        } cancelBlock:^{
            
        }];
        return;
    }
    if (self.pushToDetailVCBlock) {
        self.pushToDetailVCBlock(good);
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SD_WeakSelf;
        [SDPopView showPopViewWithContent:@"确定要将该商品移出购物车？" noTap:NO confirmBlock:^{
            SD_StrongSelf;
            [self deleteAction:indexPath];
        } cancelBlock:^{
            
        }];
        
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
