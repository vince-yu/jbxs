//
//  SDChooseGoodsControllerViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChooseGoodsController.h"
#import "SDGroupChooseTableView.h"
#import "SDChooseGoodsBarView.h"
#import "HMSegmentedControl.h"

@interface SDChooseGoodsController ()
@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;
@property (nonatomic ,strong) SDGroupChooseTableView *listTableView;
@property (nonatomic ,strong) SDChooseGoodsBarView *barView;
@property (nonatomic ,strong) NSArray *sectionArray;
@end

@implementation SDChooseGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品列表";
    [self initSubViews];
}
- (void)initSubViews{
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.barView];
    self.barView.backgroundColor = [UIColor whiteColor];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.barView.mas_top);
    }];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(55 + kBottomSafeHeight);
    }];
    
    //    [self.barView addSubview:self.cartBtn];
    //    [self.barView addSubview:self.payBtn];
    //
    //    [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(13);
    //        make.left.mas_equalTo(30);
    //        make.height.mas_equalTo(21);
    //        make.width.mas_equalTo(21);
    //    }];
    //    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.cartBtn.mas_right).offset(23);
    //        make.right.mas_equalTo(-10);
    //        make.top.mas_equalTo(8);
    //        make.height.mas_equalTo(40);
    //    }];
    
}
#pragma mark init view
- (NSArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = @[@"热卖",@"蔬菜",@"水果",@"秒杀",@"拼团"];
    }
    return _sectionArray;
}
- (SDChooseGoodsBarView *)barView{
    if (!_barView) {
        _barView = [[[NSBundle mainBundle] loadNibNamed:@"SDChooseGoodsBarView" owner:nil options:nil] objectAtIndex:0];
    }
    return _barView;
}
- (SDGroupChooseTableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[SDGroupChooseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_listTableView addMJRefresh];
        [_listTableView addMJMoreFoot];
    }
    return _listTableView;
}
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.sectionArray];
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x4e7dd3)};
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
        //        _segmentedControl.enlargeEdgeInset = UIEdgeInsetsMake(100, 100, 0, 0);
        //        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(10, 20, 0, 20);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        //        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _segmentedControl.height-1, _segmentedControl.width, 1)];
        //        line.backgroundColor = UIColorFromRGB(0xededed);
        _segmentedControl.selectionIndicatorHeight = 3.0f;  // 线的高度
        _segmentedControl.selectionIndicatorColor = UIColorFromRGB(0x4e7dd3);  //线条的颜色
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe; //线充满整个长度
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown; //线的位置
        //        [_segmentedControl addSubview:line];
    }
    return _segmentedControl;
}
#pragma mark Function
- (void)pushToCartDetailVC{
    
}
- (void)pushToPayDetailVC{
    
}
#pragma mark HMSegmented Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    
}

@end
