//
//  SDSystemProgressView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemProgressView.h"
#import "SDSystemTimeView.h"
#import "SDProgress.h"

@interface  SDSystemProgressView ()<SDSystemTimeViewDelegate>
@property (nonatomic ,strong) SDSystemTimeView *timeView;
@property (nonatomic ,strong) UIView *progressView;
@property (nonatomic ,strong) UILabel *coutLabel;
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) SDProgress *progress;
@property (nonatomic ,strong) UIView *priceLadderView;
@property (nonatomic ,strong) UIView *countLadderView;
@property (nonatomic ,strong) UIView *currentCountView;
@property (nonatomic ,strong) UILabel *currentCountLabel;
@property (nonatomic ,strong) UIImageView *currentCountBg;
@property (nonatomic ,strong) UILabel *beginLabel;
@end

@implementation SDSystemProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.timeView];
    [self addSubview:self.progressView];
    
    [self addSubview:self.beginLabel];
    self.beginLabel.hidden = YES;
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(21);
        make.top.mas_equalTo(0);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.progressView);
    }];
    
    [self.progressView addSubview:self.coutLabel];
    [self.progressView addSubview:self.priceLabel];
    [self.progressView addSubview:self.progress];
    [self.progressView addSubview:self.priceLadderView];
    [self.progressView addSubview:self.countLadderView];
    
    
    
    [self.coutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(48);
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(19);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(48);
        make.left.mas_equalTo(14);
        make.top.equalTo(self.coutLabel.mas_bottom).offset(33);
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-30);
        make.left.equalTo(self.coutLabel.mas_right).offset(10);
        make.top.equalTo(self.coutLabel.mas_bottom).offset(10);
    }];
    
    [self.priceLadderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(-30);
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.top.equalTo(self.priceLabel.mas_top);
    }];
    
    [self.countLadderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(-30);
        make.left.equalTo(self.coutLabel.mas_right).offset(10);
         make.top.equalTo(self.coutLabel.mas_top);
    }];
    
    [self.countLadderView addSubview:self.currentCountView];
//    [self.currentCountView addSubview:self.currentCountBg];
    [self.currentCountView addSubview:self.currentCountLabel];
    self.currentCountView.hidden = YES;
    
    [self.currentCountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(25);
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@0);
    }];
    
//    [self.currentCountBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.currentCountView);
//    }];
    [self.currentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.centerX.centerY.equalTo(self.currentCountView);
    }];
    
    
}
- (UILabel *)beginLabel{
    if (!_beginLabel) {
        _beginLabel = [[UILabel alloc] init];
        _beginLabel.textAlignment = NSTextAlignmentCenter;
        _beginLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _beginLabel.textColor = [UIColor colorWithHexString:@"0xC7C8CB"];
        _beginLabel.text = @"敬请期待...";
    }
    return _beginLabel;
}

- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    if (detailModel == nil) {
        return;
    }
    _detailModel = detailModel;
    [self layoutIfNeeded];
    [self.timeView setStartTime:_detailModel.startTime endTime:detailModel.endTime];
    [self.timeView fire];
    if (self.timeView.isBegin) {
        if ([self checkProgressGreaterThanMax]) {
            self.progress.numberOfNodes = _detailModel.priceLadder.count + 1;
            self.progress.fullNode = NO;
        }else{
            self.progress.numberOfNodes = _detailModel.priceLadder.count;
            self.progress.fullNode = YES;
        }
        
        [self loadRateViews:self.progress.numberOfNodes];
        [self setCurrentCount];
    }
    [self updateLayoutWith:self.timeView.isBegin];
}
- (void)updateLayoutWith:(BOOL )begin{
    self.progressView.hidden = !begin;
    self.beginLabel.hidden = begin;
}
- (void)setCurrentCount{
    NSInteger count = self.detailModel.sold.integerValue;
//    CGFloat bili = (float)(self.detailModel.priceLadder.count - 1 )/ (self.detailModel.priceLadder.count);
////    CGFloat rate = self.detailModel.rate.floatValue * bili;
//    CGFloat maxCount = [[self.detailModel.priceLadder.lastObject objectForKey:@"num"] floatValue];
//    CGFloat rate = (CGFloat)(count / maxCount) * bili;
//    if (rate > 1 || self.detailModel.priceLadder.count == 1 || count > maxCount ) {
//        rate = 1;
//    }
    CGFloat rate = [self getCurrentRate];
    [self.progress setProgress:rate animated:NO];
    if (count) {
        self.currentCountView.hidden = NO;
        self.currentCountLabel.text = self.detailModel.sold;
        [self.progress addSubview:self.currentCountView];
//        CGFloat centerX = (self.countLadderView.width)* rate;
        CGFloat centerX = (self.countLadderView.width - 7.5*2)*rate + 7.5;
//        if (rate == 1) {
//            centerX = centerX - 8;
//        }else{
////            centerX = centerX + 2;
//        }
        [self.currentCountLabel sizeToFit];
        [self.currentCountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(self.currentCountLabel.width + 10).priorityLow();
            make.width.greaterThanOrEqualTo(@25);
            make.centerY.equalTo(self.progress.mas_centerY);
            make.centerX.equalTo(self.progress.mas_left).offset(centerX);
        }];
        [self.currentCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.currentCountView);
        }];
        NSLog(@"");
    }else{
        self.currentCountView.hidden = YES;
    }
}
- (BOOL )checkProgressGreaterThanMax{
    NSInteger count = self.detailModel.sold.integerValue;
    NSInteger maxCount = [[self.detailModel.priceLadder.lastObject objectForKey:@"num"] integerValue];
    if (self.detailModel.priceLadder.count == 1 || count > maxCount) {
        return YES;
    }
    return NO;
}
- (CGFloat )getCurrentRate{
    CGFloat rate = 0;
    NSInteger count = self.detailModel.sold.integerValue;
    NSInteger maxCount = [[self.detailModel.priceLadder.lastObject objectForKey:@"num"] integerValue];
    if (self.detailModel.priceLadder.count == 1 || count > maxCount) {
        return 1;
    }
//    CGFloat bili = (float)(self.detailModel.priceLadder.count - 1 )/ (self.detailModel.priceLadder.count);
    NSInteger lastNode = 0;
    NSInteger preNode = 0;
    NSInteger currentNode = 0;
    NSString *preNodeStr = nil;
    NSString *lastNodeStr = nil;
    NSString *currentNodeStr = nil;
    NSArray *array = self.detailModel.priceLadder;
    for (NSInteger i = array.count - 1; i >= 0; i --) {
        NSString *nodeCount = [[array objectAtIndex:i] objectForKey:@"num"];
        NSString *preNodeCount = [[array objectAtIndex:i-1] objectForKey:@"num"];
        if (count == nodeCount.integerValue) {
            currentNode = i;
            currentNodeStr = nodeCount;
            break;
        }
        if (count < nodeCount.integerValue && count > preNodeCount.integerValue) {
            preNodeStr = preNodeCount;
            lastNodeStr = nodeCount;
            preNode = i - 1;
            lastNode = i;
            break;
        }
    }
    if (currentNode == 0 && array.count == 0) {
        self.progress.numberOfHighlightNodes = 1;
        return 0;
    }
    if (currentNode != 0) {
//        floorf(progress * _numberOfNodes + 0.5)
//        return (currentNode + 0.5) / array.count;
        self.progress.numberOfHighlightNodes = currentNode + 1;
        return currentNode / (self.progress.numberOfNodes - 1.0);
    }
    if (lastNode != 0) {
//        CGFloat offsetNeedWidth = 20;
//        CGFloat totalLength = self.countLadderView.width - 30;
//        CGFloat preLength = totalLength / array.count;
        rate = preNode / (CGFloat )(self.progress.numberOfNodes - 1);
//        CGFloat offsetNeedRate = offsetNeedWidth / totalLength;
        
        CGFloat offset = (count - preNodeStr.integerValue)/ (CGFloat )(lastNodeStr.integerValue - preNodeStr.integerValue) * 1 / (self.progress.numberOfNodes - 1);
//        CGFloat offsetWidth = totalLength * offset;
//        if (offsetWidth < offsetNeedWidth) {
//            offset = offsetNeedRate;
//        }else if (preLength - offsetWidth < offsetNeedWidth){
//            offset = (preLength - offsetNeedWidth) / totalLength;
//        }else if (offsetWidth < offsetNeedWidth && (preLength - offsetWidth < offsetNeedWidth) ){
//            offset = 1.0 / array.count * 0.5;
//        }
        
        self.progress.numberOfHighlightNodes = preNode + 1;
        rate = rate + offset;
    }
    return rate;
}
- (void)loadRateViews:(NSInteger )count{
    if (self.detailModel.priceLadder.count) {
        for (UIView *view in self.priceLadderView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.countLadderView.subviews) {
            [view removeFromSuperview];
        }
//        NSUInteger count = self.detailModel.priceLadder.count;
//        count = count - 1;
        CGFloat priceItemWith = (self.priceLadderView.width -15)/ (count - 1);//15是由于progress中前后有7.5的留白
        CGFloat countItemWith = (self.priceLadderView.width - 15 ) / (count - 1);
        for (int i = 0; i < count; i ++) {
            if (i >= self.detailModel.priceLadder.count) {
                continue;
            }
            NSDictionary *dic = [self.detailModel.priceLadder objectAtIndex:i];
            NSString *counts = dic[@"num"];
            NSString *price = dic[@"price"];
            
            UILabel *countsLabel = [self itemLabel:counts];
            NSString *priceStr = [NSString stringWithFormat:@"%@",price];
            UILabel *pricesLabel = [self itemLabel:[NSString stringWithFormat:@"￥ %@",[priceStr subPriceStr:2]]];
            
            [self.countLadderView addSubview:countsLabel];
            CGFloat countLeft = countItemWith * i - countsLabel.width / 2.0 + 7.5;
            [countsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.countLadderView);
                make.left.mas_equalTo(countLeft);
                make.width.mas_equalTo(countsLabel.width);
            }];
            
            if (i == count - 1) {
                [self.priceLadderView addSubview:pricesLabel];
                CGFloat priceLeft = countItemWith * i - pricesLabel.width / 2.0 + 7.5;
                [pricesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.priceLadderView);
                    make.left.mas_equalTo(priceLeft);
                    make.width.mas_equalTo(pricesLabel.width);
                }];
            }else{
                [self.priceLadderView addSubview:pricesLabel];
                CGFloat left =  i * priceItemWith;
                [pricesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.priceLadderView);
                    make.left.mas_equalTo(left);
                    make.width.mas_equalTo(pricesLabel.width);
                }];
            }
            
        }
    }
}
- (UILabel *)itemLabel:(NSString *)text {
    if (![text isKindOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"%@",text];
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:kSDPFBoldFont size:12];
    label.textColor = [UIColor colorWithHexString:@"0x131413"];
    label.text = text;
    [label sizeToFit];
    return label;
}
#pragma mark init
- (SDSystemTimeView *)timeView{
    if (!_timeView) {
        _timeView = [[[NSBundle mainBundle] loadNibNamed:@"SDSystemTimeView" owner:nil options:nil] objectAtIndex:0];
        _timeView.delegate = self;
    }
    return _timeView;
}
- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
    }
    return _progressView;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:kSDPFBoldFont size:12];
        _priceLabel.textColor = [UIColor colorWithHexString:@"0xC7C8CB"];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.text = @"单价";
    }
    return _priceLabel;
}
- (UILabel *)coutLabel{
    if (!_coutLabel) {
        _coutLabel = [[UILabel alloc] init];
        _coutLabel.font = [UIFont fontWithName:kSDPFBoldFont size:12];
        _coutLabel.textColor = [UIColor colorWithHexString:@"0xC7C8CB"];
        _coutLabel.textAlignment = NSTextAlignmentRight;
        _coutLabel.text = @"拼团份数";
    }
    return _coutLabel;
}
- (SDProgress *)progress{
    if (!_progress) {
        _progress = [[SDProgress alloc] initWithFrame:CGRectMake(30, 200, 300, 15)];
        _progress.backgroundColor = [UIColor clearColor];
        _progress.layer.cornerRadius = 10;
        _progress.progressTintColors = @[LRColorWithRGB(0x16BC2E)];
        _progress.hideStripes = YES;
        _progress.numberOfNodes = 5;
        _progress.hideAnnulus = YES;
    }
    return _progress;
}
- (UIView *)priceLadderView{
    if (!_priceLadderView) {
        _priceLadderView = [[UIView alloc] init];
    }
    return _priceLadderView;
}
- (UIView *)countLadderView{
    if (!_countLadderView) {
        _countLadderView = [[UIView alloc] init];
    }
    return _countLadderView;
}
- (UIView *)currentCountView{
    if (!_currentCountView) {
        _currentCountView = [[UIView alloc] init];
        _currentCountView.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _currentCountView.layer.cornerRadius = 7.5;
        _currentCountView.clipsToBounds = YES;
    }
    return _currentCountView;
}
- (UIImageView *)currentCountBg{
    if (!_currentCountBg) {
        _currentCountBg = [[UIImageView alloc] init];
        _currentCountBg.image = [UIImage imageNamed:@"good_sg_currentcount"];
    }
    return _currentCountBg;
}
- (UILabel *)currentCountLabel{
    if (!_currentCountLabel) {
        _currentCountLabel = [[UILabel alloc] init];
        _currentCountLabel.font = [UIFont fontWithName:kSDPFBoldFont size:12];
        _currentCountLabel.textColor = [UIColor whiteColor];
        _currentCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentCountLabel;
}
- (void)startTimeToEndTime{
    if (self.timeChangeEndBlock) {
        self.timeChangeEndBlock();
    }
}
@end
