//
//  SDMineButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMineButton.h"

@implementation SDMineButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        if (iPhone4 || iPhone5) {
            self.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        }
        [self setTitleColor:[UIColor colorWithRGB:0x131413] forState:UIControlStateNormal];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.cp_y = 20;
    self.imageView.cp_x = (self.cp_w - self.imageView.cp_w) * 0.5;
    self.titleLabel.cp_x = (self.cp_w - self.titleLabel.cp_w) * 0.5;
    self.titleLabel.cp_y = CGRectGetMaxY(self.imageView.frame) + self.margin ;

}

@end
