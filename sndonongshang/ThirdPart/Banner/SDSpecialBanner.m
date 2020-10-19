//
//  SDSpecialBanner.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSpecialBanner.h"

@interface SDSpecialBanner ()<iCarouselDelegate ,iCarouselDataSource>
@property (nonatomic ,strong) iCarousel *icarouselView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation SDSpecialBanner
- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.imageArray = array;
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.icarouselView];
    [self.icarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self);
    }];
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(10);
    }];
}
- (iCarousel *)icarouselView{
    if (!_icarouselView) {
        _icarouselView = [[iCarousel alloc] init];
        _icarouselView.type = iCarouselTypeRotary;
        _icarouselView.delegate = self;
        _icarouselView.dataSource = self;
        _icarouselView.pagingEnabled = YES;
//        _icarouselView.isWrapEnabled
//        _icarouselView.perspective = - 0.005;
//        _icarouselView.viewpointOffset = CGSizeMake(100, 100);
//        _icarouselView.contentOffset = CGSizeMake(100, 100);
//        _icarouselView se
    }
    return _icarouselView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}
- (NSTimer *)timer{
    if (!_timer) {
//        _timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(scrollAction) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)setImageArray:(NSArray *)imageArray{
    if (!imageArray.count) {
        return;
    }
    _imageArray = imageArray;
//    int i = rand() % 3;
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (int offset = 0; offset <= i; offset ++) {
//        [array addObject:imageArray.firstObject];
//    }
//    _imageArray = array;
    self.pageControl.numberOfPages = _imageArray.count;
    [self.icarouselView reloadData];
    if (_imageArray.count == 1) {
        self.icarouselView.scrollEnabled = NO;
        [self invalidateTimer];
        self.pageControl.hidden = YES;
    }else{
        self.icarouselView.scrollEnabled = YES;
        self.pageControl.hidden = NO;
        if (![self.timer isValid]) {
            [self.timer fire];
        }
    }
    
}
- (void)scrollAction{
    NSInteger index = self.icarouselView.currentItemIndex;
    index ++ ;
    if (index > self.imageArray.count - 1) {
        index = 0;
    }
    [self.icarouselView scrollToItemAtIndex:index animated:YES];
    
//    [self.icarouselView scrollToItemAtIndex:index duration:0.5];
    self.pageControl.currentPage = index;
}
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}
#pragma mark icarous Delegate
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
            break;
        case iCarouselOptionSpacing:
        {
            if (_imageArray.count >= 3) {
                return value * 1.04;
            }else if (_imageArray.count == 2){
                return value * 1.06;
            }else {
                return value * 1.1;
            }
            
        }
        case iCarouselOptionArc:
        {
            return 2 * M_PI * 0.05;
        }
            default:
        {
            return value;
        }
    }
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.imageArray count];;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30 , (SCREEN_WIDTH - 30) * self.bili)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    return imageView;
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:index];
    }
}
- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;
}
- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    [self invalidateTimer];
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    [self timer];
    self.pageControl.currentPage = carousel.currentItemIndex;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;
}
@end
