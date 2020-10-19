//
//  SDSettingButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSettingButton.h"

@implementation SDSettingButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       [self setImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.cp_y = 0;
    self.imageView.cp_x = self.cp_w - self.imageView.cp_w - 10;
}

@end
