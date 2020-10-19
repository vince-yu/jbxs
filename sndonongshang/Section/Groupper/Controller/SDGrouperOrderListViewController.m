
//
//  SDGrouperOrderListViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperOrderListViewController.h"
#import "SDGrouperOrderMgrViewController.h"

@interface SDGrouperOrderListViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, weak) UIScrollView *scrollView;


@end

@implementation SDGrouperOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    [self initTopView];
    [self initScrollView];
}

- (void)initTopView {
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - kTabBarHeight);
    [self.view addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(255);
        make.centerX.mas_equalTo(self.view);
    }];
}

- (void)initScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.segmentControl.mas_bottom).mas_equalTo(15);
    }];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titles.count, SCREEN_HEIGHT - kTopHeight - kTabBarHeight);
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    
    for (int i = 0; i < self.titles.count; i++) {
        /** [全部:1 待发货:3 已完成:4] */
//  @[@"待收货", @"已完成", @"全部"];
        NSString *status = nil;
        if (i == 0 ) { // 待发货 待收货
            status = @"3";
        }else if (i == 1) { // 已完成
            status = @"4";
        }else if (i == 2) { // 全部
            status = @"1";
        }
        SDGrouperOrderMgrViewController *vc = [SDGrouperOrderMgrViewController orderContentType:self.rolerType status:status];
        [self addChildViewController:vc];
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
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//    int index = scrollView.contentOffset.x / scrollView.width;
//    self.se
//    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
//}

#pragma mark - action
- (void)selected:(UISegmentedControl*)control{
    if (control.selectedSegmentIndex == 0) {
        if ([SDUserModel sharedInstance].role) {
            [SDStaticsManager umEvent:kordermg_tab_dsh attr:@{@"role":@"1"}];
        }else{
            [SDStaticsManager umEvent:kordermg_tab_dsh attr:@{@"role":@"0"}];
        }
        
    }else if (control.selectedSegmentIndex == 1) {
        if ([SDUserModel sharedInstance].role) {
            [SDStaticsManager umEvent:kordermg_tab_complete attr:@{@"role":@"1"}];
        }else{
            [SDStaticsManager umEvent:kordermg_tab_complete attr:@{@"role":@"0"}];
        }
    }else{
        if ([SDUserModel sharedInstance].role) {
            [SDStaticsManager umEvent:kordermg_tab_all attr:@{@"role":@"1"}];
        }else{
            [SDStaticsManager umEvent:kordermg_tab_all attr:@{@"role":@"0"}];
        }
    }
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * control.selectedSegmentIndex, 0) animated:YES];
}

#pragma mark - lazy
- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:self.titles];
        _segmentControl.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _segmentControl.selectedSegmentIndex = 0;
        NSDictionary *selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:kSDPFMediumFont size:14], NSForegroundColorAttributeName: [UIColor whiteColor]};
        NSDictionary *normalTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:kSDPFMediumFont size:14], NSForegroundColorAttributeName: [UIColor colorWithHexString:kSDGreenTextColor]};
        [_segmentControl setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
        [_segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (NSArray *)titles {
    if (!_titles) {
        if (self.rolerType) {
            _titles = @[@"待发货", @"已完成", @"全部"];
        }else{
            _titles = @[@"待收货", @"已完成", @"全部"];
        }
    }
    return _titles;
}

@end
