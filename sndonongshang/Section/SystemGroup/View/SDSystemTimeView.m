//
//  SDSystemTimeView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemTimeView.h"

@interface SDSystemTimeView ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *daySignLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *mimuteSignLabel;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) NSString *currentTime;
@property (nonatomic ,strong) NSString *setTime;
@property (nonatomic ,assign) NSInteger time;
@property (nonatomic ,copy) NSString *startTime;
@property (nonatomic ,copy) NSString *endTime;

@end

@implementation SDSystemTimeView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.dayLabel.layer.cornerRadius = 4.0;
    self.hourLabel.layer.cornerRadius = 4.0;
    self.minuteLabel.layer.cornerRadius = 4.0;
    self.secondLabel.layer.cornerRadius = 4.0;
    self.dayLabel.layer.masksToBounds = YES;
    self.hourLabel.layer.masksToBounds = YES;
    self.minuteLabel.layer.masksToBounds = YES;
    self.secondLabel.layer.masksToBounds = YES;
    _time = 0;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSTimer *)timer{
    if (!_timer) {
        
//        _timer = [NSTimer timerWithTimeInterval:1.0 target:_timer selector:@selector(refreshTime) userInfo:nil repeats:YES];
        SD_WeakSelf;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            SD_StrongSelf;
//            [self refreshTime];
//        }];
        _timer = [NSTimer sd_timerWithTimeInterval:1.0 repeats:YES block:^{
            SD_StrongSelf;
            [self refreshTime];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
    }
    return _timer;
}

- (void)dealloc
{
    [_timer invalidate];
    _time = 0;
}
- (void)refreshTime{
    if (_currentTime.length && self.time > 0) {
        NSString *d = [self convertDateStringWithTimeStr:@"dd"];
        NSString *h = [self convertDateStringWithTimeStr:@"HH"];
        NSString *m = [self convertDateStringWithTimeStr:@"mm"];
        NSString *s = [self convertDateStringWithTimeStr:@"ss"];
        
        self.hourLabel.text = h;
        self.dayLabel.text = d;
        self.minuteLabel.text = m;
        self.secondLabel.text = s;
        _time --;
        self.currentTime = [NSString stringWithFormat:@"%ld",_time];
        if (self.isBegin == NO && _time <= 0) {
            [self setStartTime:self.startTime endTime:self.endTime];
            if (self.delegate && [self.delegate respondsToSelector:@selector(startTimeToEndTime)]) {
                [self.delegate startTimeToEndTime];
            }
        }
        if (self.isBegin == YES) {
            if ([self.timer isValid] && self.time == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshListViewWithEndTime object:self.endTime];
            }
        }
    }
}
- (void)setTime:(NSInteger)time{
    
        _time = time;
        self.currentTime = [NSString stringWithFormat:@"%ld",time];

}
- (void)setStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    if (!startTime.length && !endTime.length) {
        return;
    }
    self.startTime = startTime;
    self.endTime = endTime;
    NSInteger start = startTime.length ? [startTime groupTime] : 0;
    NSInteger end = endTime.length ? [endTime groupTime] : 0;
    if (end < 0) {
        self.isEnded = YES;
    }else{
        self.isEnded = NO;
        if (start > 0) {
            self.isBegin = NO;
            self.time = start;
            self.currentTime = [NSString stringWithFormat:@"%ld",self.time];
        }else{
            self.isBegin = YES;
            self.time = end;
            self.currentTime = [NSString stringWithFormat:@"%ld",self.time];
        }
    }
    
    [self updateLayout];
}
- (void)fire{
//    [self.timer invalidate];
    if (![self.timer isValid] && self.time > 0) {
        [self.timer fire];
    }
    
}
- (NSString *)convertDateStringWithTimeStr:(NSString *)formatterStr{
    
    NSInteger ss = (NSInteger)_time % 60;
    NSInteger tm = (NSInteger)_time / 60;
    NSInteger mm = tm % 60;
    NSInteger th = tm / 60;
    NSInteger hh = th % 24;
    NSInteger td = th / 24;
    NSString *str = @"00";
    if ([formatterStr containsString:@"dd"]) {
        str = [NSString stringWithFormat:@"%ld",td];
    }else if ([formatterStr containsString:@"HH"]){
        str = [NSString stringWithFormat:@"%ld",hh];
    }else if ([formatterStr containsString:@"mm"]){
        str = [NSString stringWithFormat:@"%ld",mm];
    }else if ([formatterStr containsString:@"ss"]){
        str = [NSString stringWithFormat:@"%ld",ss];
    }
    if (str.length >= 2) {
        return str;
    }else{
        return [NSString stringWithFormat:@"0%@",str];
    }
}
- (void)cancel{
    [_timer invalidate];
    _time = 0;
}
- (void)updateLayout{
    if (self.isEnded) {
        self.nameLabel.text = @"已结束";
        NSString *signTextColor = @"0xCFD0D2";
        NSString *timeBackColor = @"0xC3C4C7";
        
        self.nameLabel.textColor = [UIColor colorWithHexString:signTextColor];
        self.daySignLabel.textColor = [UIColor colorWithHexString:signTextColor];
        self.hourSignLabel.textColor = [UIColor colorWithHexString:signTextColor];
        self.mimuteSignLabel.textColor = [UIColor colorWithHexString:signTextColor];
        
        self.dayLabel.backgroundColor = [UIColor colorWithHexString:timeBackColor];
        self.hourLabel.backgroundColor = [UIColor colorWithHexString:timeBackColor];
        self.minuteLabel.backgroundColor = [UIColor colorWithHexString:timeBackColor];
        self.secondLabel.backgroundColor = [UIColor colorWithHexString:timeBackColor];
        
        self.dayLabel.textColor = [UIColor whiteColor];
        self.hourLabel.textColor = [UIColor whiteColor];
        self.minuteLabel.textColor = [UIColor whiteColor];
        self.secondLabel.textColor = [UIColor whiteColor];
        
        self.secondLabel.layer.borderWidth = 0;
        self.dayLabel.layer.borderWidth = 0;
        self.hourLabel.layer.borderWidth = 0;
        self.minuteLabel.layer.borderWidth = 0;
    }else{
        
        self.daySignLabel.textColor = [UIColor blackColor];
        self.hourSignLabel.textColor = [UIColor blackColor];
        self.mimuteSignLabel.textColor = [UIColor blackColor];
        
        self.nameLabel.text = self.isBegin ? @"距结束" : @"距开始";
        self.dayLabel.backgroundColor = self.isBegin ? [UIColor blackColor] :[UIColor whiteColor];
        self.hourLabel.backgroundColor = self.isBegin ? [UIColor blackColor] :[UIColor whiteColor];
        self.minuteLabel.backgroundColor = self.isBegin ? [UIColor blackColor] :[UIColor whiteColor];
        self.secondLabel.backgroundColor = self.isBegin ? [UIColor blackColor] :[UIColor whiteColor];
        
        self.dayLabel.textColor = self.isBegin ? [UIColor whiteColor] :[UIColor blackColor];
        self.hourLabel.textColor = self.isBegin ? [UIColor whiteColor] :[UIColor blackColor];
        self.minuteLabel.textColor = self.isBegin ? [UIColor whiteColor] :[UIColor blackColor];
        self.secondLabel.textColor = self.isBegin ? [UIColor whiteColor] :[UIColor blackColor];
        
        self.dayLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.hourLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.minuteLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.secondLabel.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.secondLabel.layer.borderWidth = self.isBegin ? 0 : 1;
        self.dayLabel.layer.borderWidth = self.isBegin ? 0 : 1;
        self.hourLabel.layer.borderWidth = self.isBegin ? 0 : 1;
        self.minuteLabel.layer.borderWidth = self.isBegin ? 0 : 1;
    }
    
}
@end
