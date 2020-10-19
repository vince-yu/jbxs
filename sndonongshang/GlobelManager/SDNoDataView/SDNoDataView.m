//
//  SDNoDataView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDNoDataView.h"

@interface SDNoDataView ()
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, copy) loadClickBlock block;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIImageView *emptyIv;

@end

@implementation SDNoDataView

+ (instancetype)noDataViewWithTips:(NSString *)tips loadClickBlock:(loadClickBlock)block {
    return [[self alloc] initWithNoDataViewWithTips:tips loadClickBlock:block];
}

- (instancetype)initWithNoDataViewWithTips:(NSString *)tips loadClickBlock:(loadClickBlock)block {
    if (self = [super init]) {
        self.tips = tips;
        self.block = block;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xf5f5f7] size:CGSizeMake(SCREEN_WIDTH, 120 + 14 + 35 + 27)];
    self.userInteractionEnabled = YES;
    [self addSubview:self.emptyIv];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.loadBtn];
}

- (void)setLoadFail:(BOOL)loadFail {
    _loadFail = loadFail;
    CGFloat x = (SCREEN_WIDTH - 120) * 0.5;
    if (_loadFail) {
        self.loadBtn.hidden = NO;
        self.tipsLabel.text = @"加载失败";
        self.emptyIv.image = [UIImage imageNamed:@"load_fail"];
        self.frame = CGRectMake(x, 0, 120, 120 + 14 + 35 + 27);
    }else {
        self.loadBtn.hidden = YES;
        self.tipsLabel.text = self.tips;
        self.emptyIv.image = [UIImage imageNamed:@"cart_no_good"];
        self.frame = CGRectMake(x, 0, 120, 120);
    }
    self.emptyIv.frame = CGRectMake(x , 0, 120, 120);
    self.tipsLabel.frame = CGRectMake(0 , CGRectGetMaxY(self.emptyIv.frame), SCREEN_WIDTH, 14);
    self.loadBtn.frame = CGRectMake((SCREEN_WIDTH - 75) * 0.5, CGRectGetMaxY(self.emptyIv.frame) + 30, 75, 27);
}

#pragma mark - action
- (void)loadBtnClick {
    if (self.block) {
        self.block();
    }
}

#pragma mark - lazy
- (UIButton *)loadBtn{
    if (!_loadBtn) {
        _loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_loadBtn setTitleColor:[UIColor colorWithHexString:@"0x131413"] forState:UIControlStateNormal];
        _loadBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        _loadBtn.layer.borderWidth = 0.5;
        _loadBtn.layer.cornerRadius = 13.5;
        _loadBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        _loadBtn.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
        [_loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadBtn;
}

- (UIImageView *)emptyIv {
    if (!_emptyIv) {
        _emptyIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_no_good"]];
    }
    return _emptyIv;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = self.tips;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _tipsLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    }
    return _tipsLabel;
}

@end
