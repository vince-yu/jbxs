//
//  SDChangeRolerPopView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDChangeRolerPopView.h"
#import "SDRolerButton.h"
@interface SDChangeRolerPopView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) SDRolerButton *grouperBtn;
@property (nonatomic, strong) SDRolerButton *commonBtn;
@property (nonatomic, strong) SDRolerButton *selectedBtn;

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *separateLineView;

@property (nonatomic, copy) SDRolerPopConfirmBlock confirmBlock;

@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) UIButton *cancelBtn;

@property (nonatomic, assign) SDUserRolerType rolerType;


@end

@implementation SDChangeRolerPopView

static CGFloat const ContentH = 244;
static CGFloat const ContentW = 280;

+ (instancetype)showPopViewWithConfirmBlock:(SDRolerPopConfirmBlock)confirmBlock{
    return [[self alloc] initWithShowPopViewWithConfirmBlock:confirmBlock];
}


- (instancetype)initWithShowPopViewWithConfirmBlock:(SDRolerPopConfirmBlock)confirmBlock {
    if (self = [super init]) {
        self.rolerType = [SDUserModel sharedInstance].role;
        self.confirmBlock = confirmBlock;
        [self addToWindow];
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
        [self addGesture];
        [self initSubView];
        [self showSelf];
    }
    return  self;
}

- (void)addToWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
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
    titleLabel.text = @"切换角色";
    titleLabel.textColor = [UIColor colorWithRGB:0x131413];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
    self.titleLabel = titleLabel;
    [contentView addSubview:titleLabel];
    
    [self.contentView addSubview:self.grouperBtn];
    [self.contentView  addSubview:self.commonBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [contentView addSubview:lineView];
    
    
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

- (void)setRolerType:(SDUserRolerType)rolerType {
    if (rolerType == SDUserRolerTypeGrouper) {
        self.selectedBtn =  self.grouperBtn;
    }else {
        self.selectedBtn = self.commonBtn;
    }
    self.selectedBtn.selected = YES;
}

- (void)showSelf {
    SD_WeakSelf
    CGFloat contentY = (SCREEN_HEIGHT - ContentH) * 0.5;
    CGFloat x = (SCREEN_WIDTH - ContentW) * 0.5;
    self.alpha = 0;
    self.contentView.frame = CGRectMake(x, SCREEN_HEIGHT + contentY, ContentW, ContentH);
    [UIView animateWithDuration:0.40 animations:^{
        SD_StrongSelf
        self.alpha = 1;
        self.contentView.frame = CGRectMake(x, contentY, ContentW, ContentH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSelf {
    SD_WeakSelf
    CGFloat contentY = (SCREEN_HEIGHT - ContentH) * 0.5;
    CGFloat x = (SCREEN_WIDTH - ContentW) * 0.5;
    [UIView animateWithDuration:0.40 animations:^{
        SD_StrongSelf
        self.alpha = 0;
        self.contentView.frame = CGRectMake(x, SCREEN_HEIGHT + contentY, ContentW, ContentH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - action
- (void)confirmBtnClick {
    if (self.confirmBlock) {
        NSString *role = @"0";
        if ([self.selectedBtn.titleLabel.text isEqualToString:@"团长用户"]) {
            role = @"1";
        }
        if ([SDUserModel sharedInstance].role != [role intValue]) {
            self.confirmBlock(role);
        }
    }
    [self hideSelf];
}

- (void)cancelBtnClick {
    [SDStaticsManager umEvent:kuserinfo_role_cancel];
    [self hideSelf];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];

    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top);
    }];
    
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
    
    [self.grouperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(ContentH * 0.5 - 50);
    }];
    
    [self.commonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(ContentH * 0.5);
    }];
    
}

#pragma mark - action
- (void)popViewClick {
    [self hideSelf];
}

- (void)rolerBtnClick:(SDRolerButton *)clickBtn {
    clickBtn.selected = YES;
    self.selectedBtn.selected = NO;
    self.selectedBtn = clickBtn;
}

#pragma mark - lazy
- (SDRolerButton *)grouperBtn {
    if (!_grouperBtn) {
        _grouperBtn = [SDRolerButton buttonWithType:UIButtonTypeCustom];
        [_grouperBtn setTitle:@"团长用户" forState:UIControlStateNormal];
        [_grouperBtn addTarget:self action:@selector(rolerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _grouperBtn;
}

- (SDRolerButton *)commonBtn {
    if (!_commonBtn) {
        _commonBtn = [SDRolerButton buttonWithType:UIButtonTypeCustom];
        [_commonBtn setTitle:@"普通用户" forState:UIControlStateNormal];
        [_commonBtn addTarget:self action:@selector(rolerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commonBtn;
}


@end
