
//
//  SDArrowButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDArrowButton.h"

@implementation SDArrowButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        [self setTitleColor:[UIColor colorWithHexString:kSDSecondaryTextColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"common_arrow"] forState:UIControlStateNormal];

    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.cp_size = CGSizeMake(6, 11);
    self.imageView.cp_x = self.cp_w - self.imageView.cp_w;
    self.imageView.cp_y = (self.cp_h - self.imageView.cp_h) * 0.5;
    self.titleLabel.cp_x = self.imageView.cp_x - 5 - self.titleLabel.cp_w;
    self.titleLabel.cp_y = (self.cp_h - self.titleLabel.cp_h) * 0.5 ;
}
@end
