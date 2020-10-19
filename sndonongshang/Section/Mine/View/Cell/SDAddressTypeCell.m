//
//  SDAddressTypeCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressTypeCell.h"

@interface SDAddressTypeCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *typeBtnArr;
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation SDAddressTypeCell

static CGFloat margin = 20;
static CGFloat buttonW = 40;
static CGFloat buttonH = 23;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"地址类型";
    titleLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    NSArray *typeArr = @[@"家", @"公司", @"学校", @"其他"];
    for (int i = 0; i < typeArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        [button setTitle:typeArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:kSDGrayTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor colorWithHexString:kSDGrayTextColor].CGColor;
        [button setCornerRadius:2.5];
        [self.contentView addSubview:button];
        [self.typeBtnArr addObject:button];
    }
}

- (void)setType:(NSString *)type {
    _type = type;
    if (!_type || [type isEmpty]) {
        return;
    }
    for (UIButton *button in self.typeBtnArr) {
        if ([button.titleLabel.text isEqualToString:type]) {
            [self typeBtnClick:button];
            break;
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    for (UIButton *button in self.typeBtnArr) {
        CGFloat x = (button.tag - 100) * (margin + buttonW) + 15;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonW, buttonH));
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(x);
        }];
    }
}

#pragma mark - action
- (void)typeBtnClick:(UIButton *)clickBtn {
    if (clickBtn == self.selectedBtn) {
        if (clickBtn.selected) {
            clickBtn.selected = NO;
            self.selectedBtn.layer.borderColor =  [UIColor colorWithHexString:kSDGrayTextColor].CGColor;
            self.selectedBtn.backgroundColor = [UIColor whiteColor];
            self.selectedBtn = nil;
            if (self.block) {
                self.block(@"");
            }
            return;
        }
    }
    self.selectedBtn.selected = NO;
    self.selectedBtn.layer.borderColor =  [UIColor colorWithHexString:kSDGrayTextColor].CGColor;
    self.selectedBtn.backgroundColor = [UIColor whiteColor];
    clickBtn.selected = YES;
    clickBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    clickBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    self.selectedBtn = clickBtn;
    if (self.block) {
        self.block(self.selectedBtn.titleLabel.text);
    }
}

#pragma mark - lazy
- (NSMutableArray *)typeBtnArr {
    if (!_typeBtnArr) {
        _typeBtnArr = [NSMutableArray array];
    }
    return _typeBtnArr;
}
@end
