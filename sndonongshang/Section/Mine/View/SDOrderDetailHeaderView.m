//
//  SDOrderDetailHeaderView.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOrderDetailHeaderView.h"
#import "SDSettingModel.h"
#import "SDOrderDetailModel.h"
#import "SDLineView.h"
#import "SDLogisticsViewController.h"

@interface SDOrderDetailHeaderView ()

@property (nonatomic, strong) NSArray *headerDataArr;
@property (nonatomic, strong) UIImageView *greenView;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIView *shadowView;

//退款视图
@property (nonatomic ,strong) UIView *refundView;
@property (nonatomic ,strong) UILabel *refundLabel;
@property (nonatomic ,strong) SDLineView *refundLine;

//物流视图
@property (nonatomic ,strong) UIView *expressView;
@property (nonatomic ,strong) UILabel *expressLabel;
@property (nonatomic ,strong) UILabel *timerLabel;
@property (nonatomic ,strong) UIImageView *arrowImageView;
@property (nonatomic ,strong) SDLineView *expressLineView;

/** 配送方式label */
@property (nonatomic, strong) YYLabel *methodLabel;
/** 地图icon */
@property (nonatomic, strong) UIImageView *locaitonIv;
/** 订单状态label */
@property (nonatomic, strong) UILabel *statusLabel;

/** 顶部分割线 有半圆 */
@property (nonatomic, strong) SDLineView *topSeparateLineIv;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) NSMutableArray *generalViewArr;


@end

@implementation SDOrderDetailHeaderView

+ (instancetype)headerView:(SDOrderDetailModel *)detailModel {
    return [[self alloc] initWithHeaderView:detailModel];
}

- (instancetype)initWithHeaderView:(SDOrderDetailModel *)detailModel {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.detailModel = detailModel;
        [self initSubView];
    }
    return self;
}

- (void)dealloc {
    
    
}

- (void)initSubView {
    [self addSubview:self.greenView];
    
    if (self.detailModel.status.integerValue == 15) {
        [self initRefundView];
    }
    if (self.detailModel.expressModel) {
        [self initExpressView];
    }
    [self.shadowView addSubview:self.contentView];
    [self addSubview:self.shadowView];
    
    [self.contentView addSubview:self.methodLabel];
    [self.contentView addSubview:self.locaitonIv];
    [self.contentView addSubview:self.statusLabel];
   
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.addressLabel];
    
    [self.contentView addSubview:self.topSeparateLineIv];

    for (int i = 0; i < self.headerDataArr.count ; i++) {
        SDSettingModel *dataModel = self.headerDataArr[i];
        UIView *generalView = [self generalViewWithData:dataModel valueColor:nil];
        [self.contentView addSubview:generalView];
        [self.generalViewArr addObject:generalView];
    }
}
- (void)initRefundView{
    [self.contentView addSubview:self.refundView];
    [self.refundView addSubview:self.refundLabel];
    [self.refundView addSubview:self.refundLine];
}
- (void)initExpressView{
    [self.contentView addSubview:self.expressView];
    [self.expressView addSubview:self.expressLabel];
    [self.expressView addSubview:self.timerLabel];
    [self.expressView addSubview:self.expressLineView];
    [self.expressView addSubview:self.arrowImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToExpressView)];
    self.expressView.userInteractionEnabled = YES;
    [self.expressView addGestureRecognizer:tap];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(85);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (self.detailModel.status.integerValue == 15/**订单状态为已取消，不可以存在物流信息 **/) {
        [self.refundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.mas_equalTo(60);
        }];
        [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.refundView.mas_centerX);
            make.left.right.equalTo(@0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(16);
        }];
        [self.refundLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
        }];
        [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refundLine.mas_bottom).offset(20);
            make.left.mas_equalTo(35);
            make.height.mas_equalTo(14);
        }];
    }else{
        [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(35);
            make.height.mas_equalTo(14);
        }];
    }
    
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-10);
         make.bottom.mas_equalTo(-15);
    }];

//    [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
//        make.left.mas_equalTo(35);
//        make.height.mas_equalTo(14);
//    }];
    
    [self.locaitonIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.methodLabel);
        make.size.mas_equalTo(CGSizeMake(29 * 0.5, 32 * 0.5));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.methodLabel);
    }];
    
    if (self.detailModel.expressModel) {
        [self.expressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.methodLabel.mas_bottom);
            make.height.mas_equalTo(75);
        }];
        
        CGSize size = [self.detailModel.expressModel.desc sizeWithFont:self.expressLabel.font maxSize:CGSizeMake(self.bounds.size.width - 15 - 15 - 8, 32)];
        
        [self.expressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15);
            make.right.equalTo(self.arrowImageView.mas_left).offset(10);
            make.height.mas_equalTo(size.height);
        }];
        [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.expressLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.right.equalTo(self.arrowImageView.mas_left).offset(10);
            make.height.mas_equalTo(13);
        }];
        [self.expressLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.expressView);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.expressView);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(11);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locaitonIv);
            make.top.mas_equalTo(self.expressView.mas_bottom).mas_equalTo(20);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(self.phoneLabel.mas_left).mas_equalTo(-20).with.priorityHigh();
        }];
    }else{
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locaitonIv);
            make.top.mas_equalTo(self.methodLabel.mas_bottom).mas_equalTo(15);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(self.phoneLabel.mas_left).mas_equalTo(-20).with.priorityHigh();
        }];
    }
    
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.locaitonIv);
//        make.top.mas_equalTo(self.methodLabel.mas_bottom).mas_equalTo(15);
//        make.height.mas_equalTo(16);
//        make.right.mas_equalTo(self.phoneLabel.mas_left).mas_equalTo(-20).with.priorityHigh();
//    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locaitonIv);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-30);
    }];
    
    [self.topSeparateLineIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
    }];
    
    for (int i = 0; i < self.headerDataArr.count; i++) {
        UIView *generalView = self.generalViewArr[i];
        CGFloat topMargin = i * (14 + 20) + 12;
        [generalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(14);
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(self.topSeparateLineIv.mas_bottom).mas_equalTo(topMargin);
        }];
    }
}

- (void)setDetailModel:(SDOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    // 设置配送方式
    NSString *methodType = [_detailModel.distribution isEqualToString:@"1"] ? @"送货上门" : @"到店自提";
    NSString *methodStr = [NSString stringWithFormat:@"配送方式：%@", methodType];
    NSMutableAttributedString *methodText = [[NSMutableAttributedString alloc] initWithString:methodStr];
    methodText.yy_font = [UIFont fontWithName:kSDPFRegularFont size:14];
    methodText.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
    [methodText yy_setColor:[UIColor colorWithHexString:kSDMainTextColor] range:NSMakeRange(0, 5)];
    self.methodLabel.attributedText = methodText;
    if (self.detailModel.status.integerValue == 15) {
        self.refundLabel.attributedText = [NSString getAttributeStringWithStrArray:@[@{@"content":@"已退款 ",
                                                                                       @"color":[UIColor colorWithHexString:@"0x131413"],
                                                                                       @"font":[UIFont fontWithName:kSDPFMediumFont size:16]
                                                                                       },
                                                                                     @{@"content":[NSString stringWithFormat:@"￥%@",self.detailModel.refundedAmount],
                                                                                       @"color":[UIColor colorWithHexString:@"0xF8665A"],
                                                                                       @"font":[UIFont fontWithName:kSDPFMediumFont size:16]
                                                                                       }
                                                                                     ]];
        
    }
    if (self.detailModel.expressModel) {
        self.expressLabel.text = self.detailModel.expressModel.desc;
        self.timerLabel.text = [self.detailModel.expressModel.time convertDateStringWithTimeStr:@"yyyy-MM-dd hh:mm:ss"];
    }
    // 订单状态
    if (_detailModel.status.intValue == 31) {
        self.statusLabel.text = @"已发货";
    }else if (_detailModel.status.intValue == 3) {
        self.statusLabel.text = @"出库中";
    }else if (_detailModel.status.intValue  == 4) {
        self.statusLabel.text = @"交易完成";
    }else if (_detailModel.status.intValue  == 15) {
        self.statusLabel.text = @"已取消";
    }else {
        self.statusLabel.text = @"待付款";
    }
    

    NSMutableArray *tempArr = [NSMutableArray array];
    if ([self.detailModel.distribution isEqualToString:@"1"]) { // 送货上门
        self.nameLabel.text = _detailModel.transInfo.name;
        self.phoneLabel.text = _detailModel.transInfo.mobile;
        self.addressLabel.text = _detailModel.transInfo.addrDetail;

    }else { // 到店自提
        self.nameLabel.text = _detailModel.repoInfo.name;
        self.phoneLabel.text = _detailModel.repoInfo.phone;
        self.addressLabel.text = _detailModel.repoInfo.addrDetail;
        if (_detailModel.receiver.length > 0) {
            [tempArr addObject:@{@"title" : @"提货人", @"value" : _detailModel.receiver}];
        }
        [tempArr addObject:@{@"title" : @"电话", @"value" : _detailModel.receiverMobile}];
        [tempArr addObject:@{@"title" : @"预计自提时间", @"value" : _detailModel.pickTime}];
    }
    [tempArr addObject:@{@"title" : @"订单编号", @"value" : _detailModel.outTradeNo}];
    [tempArr addObject:@{@"title" : @"订单生成时间", @"value" : _detailModel.orderTime}];
    self.headerDataArr = [SDSettingModel mj_objectArrayWithKeyValuesArray:tempArr];

}
#pragma mark Action
- (void)pushToExpressView{
    SDLogisticsViewController *vc = [[SDLogisticsViewController alloc] init];
    vc.orderId = self.detailModel.orderId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
    valueLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
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

#pragma mark - lazy
- (UIImageView *)greenView {
    if (!_greenView) {
        _greenView = [[UIImageView alloc] init];
        _greenView.image = [UIImage cp_imageByCommonGreenWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    }
    return _greenView;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.shadowOffset = CGSizeMake(0,2);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 10;
        _shadowView.layer.shadowColor = [UIColor colorWithRGB:0x888686 alpha:0.24].CGColor;
    }
    return _shadowView;
}

- (YYLabel *)methodLabel {
    if (!_methodLabel) {
        _methodLabel = [[YYLabel alloc] init];
    }
    return _methodLabel;
}

- (UIImageView *)locaitonIv {
    if (!_locaitonIv) {
        _locaitonIv = [[UIImageView alloc] init];
        _locaitonIv.image = [UIImage imageNamed:@"mine_order_location"];
    }
    return _locaitonIv;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _statusLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
    return _statusLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithRGB:0x27272c];
        _nameLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor colorWithRGB:0x27272c];
        _phoneLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor colorWithRGB:0x27272c];
        _addressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}


- (SDLineView *)topSeparateLineIv {
    if (!_topSeparateLineIv) {
        _topSeparateLineIv = [[SDLineView alloc] initWithType:SDDashLineTypeHorizontal];
//        _topSeparateLineIv.image = [UIImage imageNamed:@"mine_order_separate_line"];
    }
    return _topSeparateLineIv;
}

- (NSArray *)headerDataArr {
    if (!_headerDataArr) {
        _headerDataArr = [NSArray array];
    }
    return _headerDataArr;
}

- (NSMutableArray *)generalViewArr {
    if (!_generalViewArr) {
        _generalViewArr = [NSMutableArray array];
    }
    return _generalViewArr;
}
- (UIView *)refundView{
    if (!_refundView) {
        _refundView = [[UIView alloc] init];
    }
    return _refundView;
}
- (SDLineView *)refundLine{
    if (!_refundLine) {
        _refundLine = [[SDLineView alloc] initWithType:SDDashLineTypeHorizontal];
//        _refundLine.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
    }
    return _refundLine;
}
- (UILabel *)refundLabel{
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _refundLabel;
}
- (UIView *)expressView{
    if (!_expressView) {
        _expressView = [[UIView alloc] init];
    }
    return _expressView;
}
- (UILabel *)expressLabel{
    if (!_expressLabel) {
        _expressLabel = [[UILabel alloc] init];
        _expressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _expressLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _expressLabel.numberOfLines = 2;
    }
    return _expressLabel;
}
- (UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        _timerLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
    }
    return _timerLabel;
}
- (SDLineView *)expressLineView{
    if (!_expressLineView) {
        _expressLineView = [[SDLineView alloc] initWithType:SDDashLineTypeHorizontal];
    }
    return _expressLineView;
}
- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_select_time"]];
    }
    return _arrowImageView;
}
@end
