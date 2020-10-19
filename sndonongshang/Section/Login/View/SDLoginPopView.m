
//
//  SDLoginPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLoginPopView.h"

@interface SDLoginPopView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UIButton *confirmBtn;

@end

@implementation SDLoginPopView

static CGFloat const contentH = 220;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRGB:0xcccccc alpha:0.8];
        [self addGesture];
        [self initSubView];
    }
    return  self;
}

- (void)addGesture{
    self.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewClick)];
    [self addGestureRecognizer:tap];
}

- (void)initSubView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView setCornerRadius:10];
    self.contentView = contentView;
    [self addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"温馨提示";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel = titleLabel;
    [contentView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xe6e6e6];
    self.lineView = lineView;
    [contentView addSubview:lineView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"手机号及账户密码不能为空";
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.textColor = [UIColor colorWithRGB:0x8a8a8b];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel = tipsLabel;
    [contentView addSubview:tipsLabel];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(popViewClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setCornerRadius:25];
    self.confirmBtn = confirmBtn;
    [contentView addSubview:confirmBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat topMargin = (SCREEN_HEIGHT - contentH) * 0.5;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(topMargin);
        make.height.mas_equalTo(contentH);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SDMargin);
        make.right.mas_equalTo(-SDMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(23);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(30);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_equalTo(36);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark - action
- (void)popViewClick {
    [self popCompletion:nil];
}

@end
