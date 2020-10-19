//
//  SDGrouperShopController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperShopController.h"
#import "SDGroupGoodsTableView.h"
#import "SDGrouperHeadView.h"
#import "SDGroupShopBarView.h"
#import "SDGrouperShopDetailContoller.h"

@interface SDGrouperShopController ()
@property (nonatomic ,strong) SDGroupShopBarView *barView;
@property (nonatomic ,strong) SDGrouperHeadView *headView;
@property (nonatomic ,strong) SDGroupGoodsTableView *listTableView;
@end

@implementation SDGrouperShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}
- (void)initSubView{
    self.navigationItem.title = @"店铺";
    [self.view addSubview:self.headView];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.barView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(155);
    }];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.bottom.equalTo(self.barView.mas_top);
        make.left.right.equalTo(self.view);
    }];
    
}
- (SDGrouperHeadView *)headView{
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"SDGrouperHeadView" owner:nil options:nil] objectAtIndex:0];
        SD_WeakSelf;
        _headView.editBlock = ^{
            SD_StrongSelf;
            [self pushToEditContoller];
        };
    }
    return _headView;
}
- (SDGroupShopBarView *)barView{
    if (!_barView) {
        _barView = [[[NSBundle mainBundle] loadNibNamed:@"SDGroupShopBarView" owner:nil options:nil] objectAtIndex:0];
    }
    return _barView;
}
- (SDGroupGoodsTableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[SDGroupGoodsTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_listTableView addMJRefresh];
        [_listTableView addMJMoreFoot];
    }
    return _listTableView;
}
- (void)pushToEditContoller{
    SDGrouperShopDetailContoller *detailVC = [[SDGrouperShopDetailContoller alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
