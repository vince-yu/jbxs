//
//  SDGrouperOrdrController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperOrdrController.h"
#import "SDGroupOrderTableView.h"
#import "SDSegmentedControl.h"
#import "SDGrouperOrderListViewController.h"
#import "SDJumpManager.h"

@interface SDGrouperOrdrController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, weak) SDSegmentedControl *segmentedControl;
@property (nonatomic, weak) UIScrollView *scrollView;
/** 是否是团长 */
@property (nonatomic, assign, getter=isGrouper) BOOL grouper;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic ,strong) UIView *tipsView;
@property (nonatomic ,strong) UILabel *tipsLabel;
@property (nonatomic ,strong) UIButton *beGrouperBtn;
@end

@implementation SDGrouperOrdrController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grouper = [SDUserModel sharedInstance].isRegiment;
    [self initNav];
    [self initTipsView];
    [self initScrollView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF5F5F7"];
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal && ![SDUserModel sharedInstance].isRegiment) {
        self.scrollView.hidden = YES;
        self.tipsView.hidden = NO;
    }else{
//        self.
        self.scrollView.hidden = NO;
        self.tipsView.hidden = YES;
    }
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
- (void)initNav {
    if (self.isOnlyShowGrouper) {
        self.navigationItem.title = @"团长订单";
        return;
    }
    if (self.isGrouper) {
        SDSegmentedControl *segmentedControl = [[SDSegmentedControl alloc] initWithSectionTitles:self.titlesArr];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.cp_h = 44.0;
        segmentedControl.cp_w = 190;
        segmentedControl.cp_y = 0;
        segmentedControl.cp_x = (SCREEN_WIDTH - 190) * 0.5;
        SD_WeakSelf
        segmentedControl.block = ^(NSInteger index) {
            SD_StrongSelf
            if (index) {
                [SDStaticsManager umEvent:kordermg_normal];
            }else{
                [SDStaticsManager umEvent:kordermg_tz];
            }
            CGPoint offset =  CGPointMake(index * SCREEN_WIDTH, 0);
            [self.scrollView setContentOffset:offset animated:YES];
        };
        self.segmentedControl = segmentedControl;
        self.navigationItem.titleView = segmentedControl;
    }else {
        self.navigationItem.title = @"好友订单";
    }
    
}

- (void)initTopView {
    SDSegmentedControl *segmentedControl = [[SDSegmentedControl alloc] initWithSectionTitles:self.titlesArr];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.cp_h = 44.0;
    segmentedControl.cp_w = 180;
    segmentedControl.cp_x = (SCREEN_WIDTH - 180) * 0.5;
    SD_WeakSelf
    segmentedControl.block = ^(NSInteger index) {
        SD_StrongSelf
        CGPoint offset =  CGPointMake(index * SCREEN_WIDTH, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    };
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
}

- (void)initScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight);
    }];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titlesArr.count, SCREEN_HEIGHT - kTopHeight - kTabBarHeight);
    scrollView.delegate = self;
    
    if (self.isOnlyShowGrouper) {
        SDGrouperOrderListViewController *vc = [[SDGrouperOrderListViewController alloc] init];
        vc.rolerType = SDUserRolerTypeGrouper;
        [self addChildViewController:vc];
    }else {
        if (self.isGrouper) {
            for (int i = 0; i < self.titlesArr.count; i++) {
                if (i == 0) {
                    SDGrouperOrderListViewController *vc = [[SDGrouperOrderListViewController alloc] init];
                    vc.rolerType = SDUserRolerTypeGrouper;
                    [self addChildViewController:vc];
                }else{
                    SDGrouperOrderListViewController *vc = [[SDGrouperOrderListViewController alloc] init];
                    vc.rolerType = SDUserRolerTypeNormal;
                    [self addChildViewController:vc];
                }
            }
        }else {
            SDGrouperOrderListViewController *vc = [[SDGrouperOrderListViewController alloc] init];
            vc.rolerType = SDUserRolerTypeNormal;
            [self addChildViewController:vc];
        }
    }
    scrollView.contentOffset = CGPointMake(0, 0);
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    if (willShowChildVc.isViewLoaded && willShowChildVc.view.window) return;
    
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    int index = scrollView.contentOffset.x / scrollView.width;
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
}

#pragma mark Action
- (void)beGrouperAction{
    [SDJumpManager jumpUrl:KUserBeGrouperUrl push:YES parentsController:self animation:YES];
}
#pragma mark - lazy
- (NSArray *)titlesArr {
    if (!_titlesArr) {
        if (self.isGrouper) {
            _titlesArr = @[@"团长订单", @"好友订单"];
        }else {
            _titlesArr = @[@"好友订单"];
        }
        if (self.isOnlyShowGrouper) {
            _titlesArr = @[@"团长订单"];
        }
    }
    return _titlesArr;
}

- (UIButton *)backButton {
    if (_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    }
    return _backButton;
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
@end
