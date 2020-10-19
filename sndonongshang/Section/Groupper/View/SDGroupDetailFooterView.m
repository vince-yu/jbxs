//
//  SDGroupDetailFooterView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGroupDetailFooterView.h"
#import "SDSettingModel.h"
#import "SDOrderDetailModel.h"

@interface SDGroupDetailFooterView ()

@property (nonatomic, strong) NSArray *footerDataArr;
@property (nonatomic, strong) NSMutableArray *generalViewArr;

@property (nonatomic, strong) UILabel *amountTitleLabel;
/** 实付款或者需付款 View */
@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *ratioTitleLabel;
/** 佣金比例 label */
@property (nonatomic, strong) UILabel *ratioLabel;

@property (nonatomic, strong) UILabel *brokerageTitleLabel;
/** 佣金 label */
@property (nonatomic, strong) UILabel *brokerageLabel;
/** 退款 label */
@property (nonatomic, strong) UILabel *refundTitleLabel;

@property (nonatomic, strong) UILabel *refundLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation SDGroupDetailFooterView

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
    [self addSubview:self.amountTitleLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.ratioTitleLabel];
    [self addSubview:self.ratioLabel];
    [self addSubview:self.brokerageTitleLabel];
    [self addSubview:self.brokerageLabel];
    [self addSubview:self.refundTitleLabel];
    [self addSubview:self.refundLabel];
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
        make.height.mas_equalTo(14);
    }];
    
    [self.amountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLabel);
        make.right.mas_equalTo(self.amountLabel.mas_left);
        make.height.mas_equalTo(14);
    }];
    
    if ([self.detailModel.refundedAmount isEqualToString:@"0.00"]) {
        [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.amountLabel.mas_bottom).mas_equalTo(Margin);
            make.left.mas_equalTo(self.amountLabel);
            make.height.mas_equalTo(14);
        }];
    }else {
        [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.amountLabel.mas_bottom).mas_equalTo(Margin);
            make.left.mas_equalTo(self.amountLabel);
            make.height.mas_equalTo(14);
        }];
        
        [self.refundTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.refundLabel);
            make.right.mas_equalTo(self.refundLabel.mas_left);
            make.height.mas_equalTo(14);
        }];
        
        [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.refundLabel.mas_bottom).mas_equalTo(Margin);
            make.left.mas_equalTo(self.refundLabel);
            make.height.mas_equalTo(14);
        }];
    }
    
    
    [self.ratioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ratioLabel);
        make.right.mas_equalTo(self.ratioLabel.mas_left);
        make.height.mas_equalTo(14);
    }];
    
    [self.brokerageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ratioLabel.mas_bottom).mas_equalTo(Margin);
        make.left.mas_equalTo(self.ratioLabel);
        make.height.mas_equalTo(14);
    }];
    
    [self.brokerageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brokerageLabel);
        make.right.mas_equalTo(self.brokerageLabel.mas_left);
        make.height.mas_equalTo(14);
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
    self.amountLabel.text = [NSString stringWithFormat:@"￥%@",[self.detailModel.amount priceStr]];
    NSString *rateStr =  [NSString stringWithFormat:@"%f", self.detailModel.rate.doubleValue * 100];
    self.ratioLabel.text = [NSString stringWithFormat:@"%@%%", [rateStr subPriceStr:2]];
    self.brokerageLabel.text = [NSString stringWithFormat:@"￥%@",[self.detailModel.brokerage priceStr]];
    self.refundLabel.text = [NSString stringWithFormat:@"￥%@", [self.detailModel.refundedAmount priceStr]];
    if ([self.detailModel.refundedAmount isEqualToString:@"0.00"]) {
        self.refundLabel.hidden = YES;
        self.refundTitleLabel.hidden = YES;
    }else {
        self.refundLabel.hidden = NO;
        self.refundTitleLabel.hidden = NO;
    }
//    NSString *amountStr = [NSString stringWithFormat:@"%@￥%@", title, [_detailModel.amount priceStr]];
    
//    NSMutableAttributedString *amountText = [[NSMutableAttributedString alloc] initWithString:amountStr];
//    amountText.yy_font = [UIFont fontWithName:kSDPFBoldFont size:14];
//    amountText.yy_color = [UIColor colorWithHexString:kSDRedTextColor];
//    NSRange range = NSMakeRange(0, title.length);
//    [amountText yy_setColor:[UIColor colorWithRGB:0x31302E] range:range];
//    [amountText yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:14] range:range];
//    self.amountLabel.attributedText = amountText;
    
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

- (UILabel *)amountTitleLabel {
    if (!_amountTitleLabel) {
        _amountTitleLabel = [[UILabel alloc] init];
        _amountTitleLabel.text = @"实付款：";
        _amountTitleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _amountTitleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    }
    return _amountTitleLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _amountLabel.textColor = [UIColor colorWithHexString:kSDRedTextColor];
    }
    return _amountLabel;
}

- (UILabel *)ratioTitleLabel {
    if (!_ratioTitleLabel) {
        _ratioTitleLabel = [[UILabel alloc] init];
        _ratioTitleLabel.text = @"佣金比例：";
        _ratioTitleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _ratioTitleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    }
    return _ratioTitleLabel;
}

- (UILabel *)ratioLabel {
    if (!_ratioLabel) {
        _ratioLabel = [[UILabel alloc] init];
        _ratioLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _ratioLabel.textColor = [UIColor colorWithHexString:kSDRedTextColor];
    }
    return _ratioLabel;
}

- (UILabel *)brokerageTitleLabel {
    if (!_brokerageTitleLabel) {
        _brokerageTitleLabel = [[UILabel alloc] init];
        _brokerageTitleLabel.text = @"佣金：";
        _brokerageTitleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _brokerageTitleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    }
    return _brokerageTitleLabel;
}

- (UILabel *)brokerageLabel {
    if (!_brokerageLabel) {
        _brokerageLabel = [[UILabel alloc] init];
        _brokerageLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _brokerageLabel.textColor = [UIColor colorWithHexString:kSDRedTextColor];
    }
    return _brokerageLabel;
}

- (UILabel *)refundTitleLabel{
    if (!_refundTitleLabel) {
        _refundTitleLabel = [[UILabel alloc] init];
        _refundTitleLabel.text = @"退款金额：";
        _refundTitleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _refundTitleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    }
    return _refundTitleLabel;
}

- (UILabel *)refundLabel {
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _refundLabel.textColor = [UIColor colorWithHexString:kSDRedTextColor];
    }
    return _refundLabel;
}

@end
