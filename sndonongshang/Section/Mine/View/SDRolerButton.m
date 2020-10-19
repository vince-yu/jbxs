//
//  SDRolerButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRolerButton.h"

@implementation SDRolerButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        [self setTitleColor:[UIColor colorWithRGB:0x131413] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"cart_good_selected"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"cart_good_unselected"] forState:UIControlStateNormal];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.cp_x = 25;
    self.imageView.cp_x = self.cp_w - self.imageView.cp_w - 30;
}


@end
