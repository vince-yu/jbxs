//
//  SDWeChatLoginButton.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDWeChatLoginButton.h"

@implementation SDWeChatLoginButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor colorWithRGB:0x8a8a8b] forState:UIControlStateNormal];
    }
    return  self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = CGSizeMake(49, 49);
    self.imageView.x = (self.cp_w - self.imageView.cp_w) * 0.5;
    self.imageView.y = 0;
    [self.titleLabel sizeToFit];
    self.titleLabel.x = (self.cp_w - self.titleLabel.cp_w) * 0.5;
    self.titleLabel.y = self.imageView.cp_w + 15;
}

@end
