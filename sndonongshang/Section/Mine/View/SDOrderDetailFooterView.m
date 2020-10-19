//
//  SDOrderDetailFooterView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderDetailFooterView.h"
#import "SDSettingModel.h"
#import "SDOrderDetailModel.h"

@interface SDOrderDetailFooterView ()

@property (nonatomic, strong) NSArray *footerDataArr;
@property (nonatomic, strong) NSMutableArray *generalViewArr;
/** 实付款或者需付款 View */
@property (nonatomic, strong) YYLabel *amountLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SDOrderDetailFooterView

static CGFloat const Margin = 20;
static CGFloat const TextH = 15;


+ (instancetype)footerView:(SDOrderDetailModel *)detailModel {
    return [[self alloc] initWithFooterView:detailModel];
}

- (instancetype)initWithFooterView:(SDOrderDetailModel *)detailModel {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.detailModel = detailModel;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    for (int i = 0; i < self.footerDataArr.count ; i++) {
        SDSettingModel *dataModel = self.footerDataArr[i];
        UIView *generalView = [self generalViewWithData:dataModel valueColor:nil];
        [self addSubview:generalView];
        [self.generalViewArr addObject:generalView];
    }
    [self addSubview:self.lineView];
    [self addSubview:self.amountLabel];
}

#pragma mark - private method
- (UIView *)generalViewWithData:(SDSettingModel *)dataModel valueColor:(UIColor *)valueColor {
    UIView *generalView = [[UIView alloc] init];
    generalView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    titleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    [generalView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(generalView);
    }];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = dataModel.value;
    valueLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    valueLabel.textColor = [UIColor colorWithRGB:0x131413];
    if (valueColor) {
        valueLabel.textColor = valueColor;
    }
    [generalView addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(generalView);
    }];
    return generalView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.generalViewArr.count; i++) {
        UIView *generalView = self.generalViewArr[i];
        CGFloat topMargin = i * (TextH + Margin) + Margin;
        [generalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(TextH);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(topMargin);
        }];
        if (i == self.footerDataArr.count - 1) {
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(0);
                make.top.mas_equalTo(generalView.mas_bottom).mas_equalTo(Margin);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(Margin);
        make.right.mas_equalTo(-20);
    }];
}

- (void)setDetailModel:(SDOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    NSString *title = [_detailModel.status isEqualToString:@"2"] ? @"需付款：" : @"实付款：";
    NSArray *tempArr = @[@{@"title" : @"小计", @"value" : [NSString stringWithFormat:@"￥%@", [self.detailModel.totalPrice priceStr]]},
                         @{@"title" : @"运费", @"value" : [NSString stringWithFormat:@"+￥%@", [self.detailModel.transPrice priceStr]]},
                         @{@"title" : @"优惠券", @"value" : [NSString stringWithFormat:@"-￥%@", [self.detailModel.reducePrice priceStr]]},
                         ];
    self.footerDataArr = [SDSettingModel mj_objectArrayWithKeyValuesArray:tempArr];
    NSString *amountStr = [NSString stringWithFormat:@"%@￥%@", title, [_detailModel.amount priceStr]];
    NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amountStr];
    amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:14];
    amountText.yy_color = [UIColor colorWithHexString:kSDRedTextColor];
    NSRange range = NSMakeRange(0, title.length);
    [amountText yy_setColor:[UIColor colorWithRGB:0x31302E] range:range];
    [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:14] range:range];
    self.amountLabel.attributedText = amountText;

}

#pragma mark - lazy
- (NSArray *)footerDataArr {
    if (!_footerDataArr) {
        _footerDataArr = [NSArray array];
    }
    return _footerDataArr;
}

- (NSMutableArray *)generalViewArr {
    if (!_generalViewArr) {
        _generalViewArr = [NSMutableArray array];
    }
    return _generalViewArr;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _lineView;
}

- (YYLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[YYLabel alloc] init];
    }
    return _amountLabel;
}

@end
