//
//  SDSexButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSexButton.h"

@implementation SDSexButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        [self setTitleColor:[UIColor colorWithRGB:0x131413] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"address_sex_selected"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"address_sex"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.cp_size = CGSizeMake(22, 22);
    self.imageView.cp_x = 0;
    self.imageView.cp_y = (self.cp_h - self.imageView.cp_h) * 0.5;
    self.titleLabel.cp_x = CGRectGetMaxX(self.imageView.frame) + 11;
    self.titleLabel.cp_y = (self.cp_h - self.titleLabel.cp_h) * 0.5;
}
@end
