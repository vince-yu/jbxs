//
//  SDSettlementViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSettlementViewController.h"
#import "SDAmoyMoneyCell.h"
#import "SDAmoyMoneyViewController.h"

@interface SDSettlementViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, weak) HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation SDSettlementViewController

static NSString * const CellID = @"SDAmoyMoneyCell<##>";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initScrollView];
    [self initTopView];
}

- (void)initNav {
    self.navigationItem.title = @"结算记录";
}

- (void)initTopView {
    SDSegmentedControl  *segmentedControl = [[SDSegmentedControl alloc] initWithSectionTitles:self.titlesArr];
    SD_WeakSelf
    segmentedControl.block = ^(NSInteger index) {
        SD_StrongSelf
        CGPoint offset =  CGPointMake(index * SCREEN_WIDTH, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    };
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
}

- (void)initScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat y = SegmentedControlH + kTopHeight;
    CGRect frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titlesArr.count, 0);
    scrollView.delegate = self;
    //    [scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - y) animated:NO];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    for (int i = 0; i < self.titlesArr.count; i++) {
        SDAmoyMoneyViewController *vc = [[SDAmoyMoneyViewController alloc] init];
        vc.settlementType = i;
        [self addChildViewController:vc];
    }
   
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - lazy
- (NSArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = @[@"处理中", @"结算成功", @"结算失败"];
    }
    return _titlesArr;
}

#pragma mark - action


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.width;
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

@end
