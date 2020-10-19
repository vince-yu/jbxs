//
//  SDNewVerisonPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDNewVerisonPopView.h"

@interface SDNewVerisonPopView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) YYLabel *titleLabel;
@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) YYLabel *infoLabel;
@property (nonatomic, weak) UIButton *rejustBtn;
@property (nonatomic, weak) UIButton *updateBtn;

@end

@implementation SDNewVerisonPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.6];
        [self initSubView];
    }
    return  self;
}

- (void)initSubView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = YES;
    self.contentView = contentView;
    [self addSubview:contentView];
}

@end
