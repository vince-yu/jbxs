//
//  SDPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPopView.h"

@interface SDPopView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UIView *separateLineView;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) popConfirmBlock confirmBlock;
@property (nonatomic, copy) popCancelBlock cancelBlock;
@property (nonatomic, assign) CGFloat contentH;


@end

@implementation SDPopView

static CGFloat const contentW = 280;

+ (instancetype)showPopViewWithContent:(NSString *)content noTap:(BOOL )noTap confirmBlock:(popConfirmBlock)confirmBlock cancelBlock:(popCancelBlock)cancelBlock{
    return [[self alloc] initWithShowPopViewWithContent:content noTap:YES confirmBlock:confirmBlock cancelBlock:cancelBlock];
}

- (instancetype)initWithShowPopViewWithContent:(NSString *)content noTap:(BOOL )noTap confirmBlock:(popConfirmBlock)confirmBlock cancelBlock:(popCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.noTap = noTap;
        self.content = content;
        [self countContentH];
        self.confirmBlock = confirmBlock;
        self.cancelBlock = cancelBlock;
        [self addToWindow];
//        self.backgroundColor = [UIColor colorWithRGB:0xcccccc alpha:0.8];
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
        [self addGesture];
        [self initSubView];
        [self showSelf];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)addToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    self.alpha = 1;
    self.contentView.frame = CGRectMake(SDMargin, SCREEN_HEIGHT, SCREEN_WIDTH - 2 * SDMargin, self.contentH);
    [window addSubview:self];
}

- (void)countContentH {
    CGFloat maxW = contentW - 30 * 2;
    CGFloat tipsTextH = [self.content sizeWithFont:[UIFont fontWithName:kSDPFRegularFont size:14] maxSize:CGSizeMake(maxW, MAXFLOAT)].height;
    self.contentH = 134 + tipsTextH;
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
    CGFloat contentY = (SCREEN_HEIGHT - self.contentH) * 0.5;
    self.contentView.frame = CGRectMake(SDMargin, contentY, SCREEN_WIDTH - 2 * SDMargin, self.contentH);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提示";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
    self.titleLabel = titleLabel;
    [contentView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [contentView addSubview:lineView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
    tipsLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 2;
    tipsLabel.text = self.content;
    self.tipsLabel = tipsLabel;
    [contentView addSubview:tipsLabel];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:18];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithRGB:0x00C229] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setCornerRadius:20];
    self.confirmBtn = confirmBtn;
    [contentView addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:18];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRGB:0x131413] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setCornerRadius:20];
    self.cancelBtn = cancelBtn;
    [contentView addSubview:cancelBtn];
    
    UIView *separateLineView = [[UIView alloc] init];
    separateLineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.separateLineView = separateLineView;
    [contentView addSubview:separateLineView];
    
}

- (void)showSelf {
    SD_WeakSelf
    CGFloat contentY = (SCREEN_HEIGHT - self.contentH) * 0.5;
    CGFloat x = (SCREEN_WIDTH - contentW) * 0.5;
    self.alpha = 0;
    self.contentView.frame = CGRectMake(x, SCREEN_HEIGHT + contentY, contentW, self.contentH);
    [UIView animateWithDuration:0.40 animations:^{
        SD_StrongSelf
        self.alpha = 1;
        self.contentView.frame = CGRectMake(x, contentY, contentW, self.contentH);
    } completion:^(BOOL finished) {

    }];
}

- (void)hideSelf {
    SD_WeakSelf
    CGFloat contentY = (SCREEN_HEIGHT - self.contentH) * 0.5;
    CGFloat x = (SCREEN_WIDTH - contentW) * 0.5;
    [UIView animateWithDuration:0.40 animations:^{
        SD_StrongSelf
        self.alpha = 0;
        self.contentView.frame = CGRectMake(x, SCREEN_HEIGHT + contentY, contentW, self.contentH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - action
- (void)confirmBtnClick {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self hideSelf];
}

- (void)cancelBtnClick {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hideSelf];
}


- (void)layoutSubviews {
    [super layoutSubviews];
  
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(18);
//        make.bottom.mas_equalTo(self.lineView.mas_top).mas_equalTo(-18);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top);
    }];
    
   
    
    if (self.cancelBlock) {
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
            make.right.and.bottom.mas_equalTo(0);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
            make.left.and.bottom.mas_equalTo(0);
        }];
        
        [self.separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.mas_equalTo(self.confirmBtn);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(self.contentView);
        }];
    }else {
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.left.and.bottom.and.right.mas_equalTo(0);
        }];
    }
    
}

#pragma mark - action
- (void)popViewClick {
    if (self.noTap) {
        return;
    }
    [self hideSelf];
}

@end
