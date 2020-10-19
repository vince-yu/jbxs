//
//  SDChooseCityButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChooseCityButton.h"

@interface SDChooseCityButton ()

@property (nonatomic, weak) UIView *lineView;


@end

@implementation SDChooseCityButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithRGB:0x131413] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"mine_location_down"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        self.backgroundColor = [UIColor colorWithRGB:0xf5f6f7];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRGB:0xc3c4c7 alpha:0.3];
        self.lineView = lineView;
        [self addSubview:lineView];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(self.cp_w - 1, 0, 1, self.cp_h);
    self.titleLabel.cp_x = 14;
    self.imageView.cp_x = CGRectGetMaxX(self.titleLabel.frame) + 6;
    self.titleLabel.cp_y = (self.cp_h - self.titleLabel.cp_h) * 0.5;
    self.imageView.cp_y = (self.cp_h - self.imageView.cp_h) * 0.5;
}



@end
