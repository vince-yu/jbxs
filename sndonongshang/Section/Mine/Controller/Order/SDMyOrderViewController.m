//
//  SDMyOrderViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyOrderViewController.h"
#import "SDSegmentedControl.h"

@interface SDMyOrderViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, weak) SDSegmentedControl *segmentedControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation SDMyOrderViewController

static NSString *const SDHMSegmentedControlIndicatorLayer = @"_selectionIndicatorStripLayer";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initTopView];
    [self initScrollView];
}

- (void)initNav {
    self.navigationItem.title = @"我的订单";
}

- (void)initTopView {
    SDSegmentedControl *segmentedControl = [[SDSegmentedControl alloc] initWithSectionTitles:self.titlesArr];
    segmentedControl.selectedSegmentIndex = self.orderType;
    SD_WeakSelf
    segmentedControl.block = ^(NSInteger index) {
        SD_StrongSelf
        switch (index) {
                case SDOrderTypeAll:
                [SDStaticsManager umEvent:kme_order_all];
                break;
                case SDOrderTypeNoPay:
                [SDStaticsManager umEvent:kme_order_topay];
                break;
                case SDOrderTypeNoReceive:
                [SDStaticsManager umEvent:kme_order_dsh];
                break;
                case SDOrderTypeDone:
                [SDStaticsManager umEvent:kme_order_complete];
                break;
            default:
                break;
        }
        CGPoint offset =  CGPointMake(index * SCREEN_WIDTH, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    };
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(SegmentedControlH);
    }];
}

- (void)initScrollView {
    CGFloat y = self.segmentedControl.cp_h + kTopHeight;
//    CGRect frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.segmentedControl.mas_bottom);
    }];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titlesArr.count, SCREEN_HEIGHT - y);
    scrollView.delegate = self;
   
    for (int i = 0; i < self.titlesArr.count; i++) {
        SDOrderContentViewController *vc = [SDOrderContentViewController orderContentType:i];
        [self addChildViewController:vc];
    }
    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * self.orderType, 0);
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


#pragma mark - lazy
- (NSArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = @[@"全部", @"待付款", @"待收货", @"已完成"];
    }
    return _titlesArr;
}

@end
