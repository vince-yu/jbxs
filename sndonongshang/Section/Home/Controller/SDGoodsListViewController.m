//
//  SDGoodsListViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodsListViewController.h"
#import "SDSegmentedControl.h"
#import "SDGoodsListTableView.h"
#import "SDGoodBarView.h"
#import "SDHomeDataManager.h"
#import "SDGoodListTabModel.h"
#import "SDCartDataManager.h"
#import "SDGoodDetailViewController.h"
#import "SDSystemDetailViewController.h"
#import "SDDisCountViewController.h"
#import "SDSecondKillViewController.h"

@interface SDGoodsListViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong) SDSegmentedControl *segmentedControl;
//@property (nonatomic ,strong) SDGoodsListTableView *listTableView;
@property (nonatomic ,strong) NSArray *sectionArray;
@property (nonatomic ,strong) UIButton *cartBtn;
@property (nonatomic ,strong) UIButton *payBtn;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *cartView;
@property (nonatomic ,strong) NSMutableDictionary *dataDic;
@property (nonatomic ,strong) UIImageView *cartImageView;
@property (nonatomic ,strong) UILabel *cartLabel;
@property (nonatomic ,strong) UILabel *bageView;
@end

@implementation SDGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品列表";
    [self initSubViews];
    [self updateBageCount];
    [self getSectionArrayWithRequset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBageCount) name:kNotifiRefreshCartGoodCount object:nil];
    
}
- (void)updateBageCount{
    NSInteger count = [SDCartDataManager getAllCartGoodsCount];
    if (count <= 0) {
        self.bageView.hidden = YES;
    }else{
        self.bageView.hidden = NO;
        if (count <= 99) {
            self.bageView.text = [NSString stringWithFormat:@"%ld",count];
            self.bageView.layer.mask = nil;
            [self.bageView addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(8, 8) viewRect:CGRectMake(0, 0, 16, 16)];
            [self.bageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(16);
            }];
        }else{
            self.bageView.text = [NSString stringWithFormat:@"%d+",99];
            [self.bageView sizeToFit];
            self.bageView.layer.mask = nil;
            [self.bageView addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(8, 8) viewRect:CGRectMake(0, 0, 20, 16)];
            [self.bageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(20);
            }];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshCartGoodCount object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshGoodDetailVC object:nil];
}
- (void)getSectionArrayWithRequset{
    SD_WeakSelf;
    [SDHomeDataManager configListTable:^(id  _Nonnull mdoel) {
        SD_StrongSelf;
        self.sectionArray = mdoel;
        
        [self updateSegmentTitlesAndTableView];
        [self setSegmentedControlSelected];
    } failedBlock:^(id model){
        
    }];
}
- (void)updateSegmentTitlesAndTableView{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CGFloat totalWith = 0;
    for (int i = 0 ; i < self.sectionArray.count ; i ++) {
        SDGoodListTabModel *model = [self.sectionArray objectAtIndex:i];
        if (model.name.length) {
            [array addObject:model.name];
        }
        totalWith = totalWith + [model.name sizeWithFont:[UIFont fontWithName:kSDPFBoldFont size:18] maxSize:CGSizeMake(1000, 18)].width + 20;
        if (model.tabId.length) {
            SDGoodsListTableView *tableView = [[SDGoodsListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain tabId:model.tabId];
            SD_WeakSelf;
            tableView.goodDetailBlock = ^(id  _Nonnull model) {
                SD_StrongSelf;
                [self pushToGoodDetailVC:model];
            };
            [self.scrollView addSubview:tableView];
            [self.dataDic setValue:[NSString stringWithFormat:@"%d",i] forKey:model.tabId];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i * SCREEN_WIDTH);
                make.top.equalTo(self.scrollView);
                make.height.mas_equalTo(self.scrollView.height);
                make.width.mas_equalTo(SCREEN_WIDTH);
            }];
            
        }
    }
    
    if (totalWith > SCREEN_WIDTH) {
        self.segmentedControl.sectionTitles = array;
        self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self.segmentedControl layoutSubviews];
    }else{
        self.segmentedControl.sectionTitles = array;
        self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    }
    
    
    
    
    self.scrollView.contentSize = CGSizeMake(array.count * SCREEN_WIDTH,self.scrollView.height);
    
}
- (void)setSegmentedControlSelected{
    NSString *indexStr = [self.dataDic objectForKey:self.tabId];
    if (indexStr.length) {
        self.segmentedControl.selectedSegmentIndex = indexStr.integerValue;
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * indexStr.integerValue, 0)];
    }
}
- (void)updateListTable{
    
}
- (void)initSubViews{
    [self.view addSubview:self.segmentedControl];
//    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
    
    [self.view addSubview:self.cartView];
    [self.cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
        make.left.mas_equalTo(8);
        make.bottom.equalTo(self.view).offset(-127);
    }];
    
    [self.cartView addSubview:self.cartImageView];
    [self.cartView addSubview:self.cartLabel];
    [self.cartView addSubview:self.bageView];
    
    
    [self.cartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(21);
        make.top.mas_equalTo(10);
        make.centerX.equalTo(self.cartView.mas_centerX);
    }];
    [self.cartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(10);
        make.top.equalTo(self.cartImageView.mas_bottom).offset(4);
        make.centerX.equalTo(self.cartView.mas_centerX);
    }];
    [self.bageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(5);
        make.centerX.equalTo(self.cartImageView.mas_right);
    }];
    
}
#pragma mark init view
- (NSArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = @[];
    }
    return _sectionArray;
}
- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
//- (SDGoodsListTableView *)listTableView{
//    if (!_listTableView) {
//        _listTableView = [[SDGoodsListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        [_listTableView addMJRefresh];
//        [_listTableView addMJMoreFoot];
//    }
//    return _listTableView;
//}
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[SDSegmentedControl alloc] initWithSectionTitles:self.sectionArray];
//        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
//        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        SD_WeakSelf
        _segmentedControl.block = ^(NSInteger index) {
            SD_StrongSelf
            CGPoint offset =  CGPointMake(index * SCREEN_WIDTH, 0);
            SDGoodListTabModel *model = [self.sectionArray objectAtIndex:index];
            [SDStaticsManager umEvent:kgoods_tab attr:@{@"_id":model.tabId,@"name":model.name}];
            [self.scrollView setContentOffset:offset];
        };
    }
    return _segmentedControl;
}
- (UIButton *)cartBtn{
    if (!_cartBtn) {
        _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartBtn.backgroundColor = [UIColor greenColor];
        [_cartBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_cartBtn addTarget:self action:@selector(pushToCartDetailVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartBtn;
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_payBtn setTitle:@"去结算" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(pushToPayDetailVC) forControlEvents:UIControlEventTouchUpInside];
        _payBtn.backgroundColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
        _payBtn.layer.cornerRadius = 20;
    }
    return _payBtn;
}
- (UIView *)cartView{
    if (!_cartView) {
        _cartView = [[UIView alloc] init];
        _cartView.backgroundColor = [UIColor whiteColor];
        _cartView.layer.shadowColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:0.7].CGColor;
        _cartView.layer.shadowOffset = CGSizeMake(0,0);
        _cartView.layer.shadowOpacity = 1;
        _cartView.layer.shadowRadius = 20;
        _cartView.layer.cornerRadius = 27.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToCartListView)];
        _cartView.userInteractionEnabled = YES;
        [_cartView addGestureRecognizer:tap];
    }
    return _cartView;
}
- (UILabel *)cartLabel{
    if (!_cartLabel) {
        _cartLabel = [[UILabel alloc] init];
        _cartLabel.textColor = [UIColor colorWithHexString:@"0x868687"];
        _cartLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _cartLabel.text = @"购物车";
        _cartLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cartLabel;
}
- (UIImageView *)cartImageView{
    if (!_cartImageView) {
        _cartImageView = [[UIImageView alloc] init];
        _cartImageView.image = [UIImage imageNamed:@"tabbar_car"];
    }
    return _cartImageView;
}
- (UILabel *)bageView{
    if (!_bageView) {
        _bageView = [[UILabel alloc] init];
        _bageView.textColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _bageView.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _bageView.textAlignment = NSTextAlignmentCenter;
        _bageView.backgroundColor = [UIColor colorWithHexString:@"0x13BB2B"];
        [_bageView addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(8, 8) viewRect:CGRectMake(0, 0, 16, 16)];
    }
    return _bageView;
}
#pragma mark Function
- (void)pushToCartDetailVC{
    
}
- (void)pushToPayDetailVC{
    
}
- (void)pushToCartListView{
    [SDStaticsManager umEvent:kgoods_cart_click];
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)pushToGoodDetailVC:(SDGoodModel *)goodModel{
    if (goodModel.type.integerValue == SDGoodTypeNamoal) {
        SDGoodDetailViewController *detailVC = [[SDGoodDetailViewController alloc] init];
        detailVC.goodModel = goodModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeSecondkill){
        SDSecondKillViewController *vc = [[SDSecondKillViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeDiscount){
        SDDisCountViewController *vc = [[SDDisCountViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SDSystemDetailViewController *vc = [[SDSystemDetailViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark HMSegmented Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    
}
#pragma mark ScrollerView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
}
#pragma mark Nav Delegate
- (BOOL)fd_prefersNavigationBarHidden{
    return NO;
}
- (BOOL)fd_interactivePopDisabled{
    return NO;
}
@end
