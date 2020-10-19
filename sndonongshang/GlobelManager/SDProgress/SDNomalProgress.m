//
//  SDNomalProgress.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/27.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDNomalProgress.h"

@interface SDNomalProgress ()
@property(strong,nonatomic)UIView *aView;
@property(strong,nonatomic)UIView *UIProess;
@property(strong,nonatomic)UILabel *progressLabel;
@end

@implementation SDNomalProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.backgroundColor = [UIColor clearColor];
        self.aView=[[UIView alloc] initWithFrame:frame];
        self.aView.backgroundColor=[UIColor whiteColor];
        self.aView.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        self.aView.layer.borderWidth = 1;
        self.UIProess=[[UIView alloc] init];
        self.aView.layer.cornerRadius= 6.5;
        self.aView.layer.masksToBounds=YES;
//        self.UIProess.layer.cornerRadius=self.height / 2.0;
//        self.UIProess.layer.masksToBounds=YES;
        self.UIProess.backgroundColor= [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:0.3];
        
        self.UIProess.center = self.aView.center;
        
        [self addSubview:self.aView];
        [self.aView addSubview:self.UIProess];
        
        self.progressLabel = [[UILabel alloc] init];
        [self.aView addSubview:self.progressLabel];
        self.progressLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
        self.progressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.aView);
        }];
        
        [self.aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        [self.UIProess mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.mas_equalTo(12);
        }];
    }
    return self;
}
- (void)setValue:(CGFloat)value{
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(100 * (value > 1 ? 1 : value))];

    [self.UIProess mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.aView);
        make.width.equalTo(self.aView.mas_width).multipliedBy(value);
    }];
    [self.UIProess addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(6.5, 6.5) viewRect:CGRectMake(0, 0, self.aView.width * value, self.aView.height)];
}
@end
