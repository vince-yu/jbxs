//
//  SDGroupDetailHeaderView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGroupDetailHeaderView.h"
#import "SDSettingModel.h"
#import "SDOrderDetailModel.h"

@interface SDGroupDetailHeaderView ()

@property (nonatomic, strong) NSArray *headerDataArr;
@property (nonatomic, strong) UIImageView *greenView;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIView *shadowView;

/** 配送方式label */
@property (nonatomic, strong) YYLabel *methodLabel;
/** 地图icon */
@property (nonatomic, strong) UIImageView *locaitonIv;

/** 顶部分割线 有半圆 */
@property (nonatomic, strong) UIImageView *topSeparateLineIv;

/*  --------------------- 送货上门 ----------------  */
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
/*  --------------------- 到店自提 ----------------  */
@property (nonatomic, strong) UILabel *pickNameLabel;
@property (nonatomic, strong) UILabel *pickPhoneLabel;

@property (nonatomic, strong) NSMutableArray *generalViewArr;

@property (nonatomic, strong) UILabel *statusLabel;
//退款视图
@property (nonatomic ,strong) UIView *refundView;
@property (nonatomic ,strong) UILabel *refundLabel;
@property (nonatomic ,strong) UIView *refundLine;
@end

@implementation SDGroupDetailHeaderView

+ (instancetype)headerView:(SDOrderDetailModel *)detailModel rolerType:(SDUserRolerType)rolerType{
    return [[self alloc] initWithHeaderView:detailModel rolerType:rolerType];
}

- (instancetype)initWithHeaderView:(SDOrderDetailModel *)detailModel rolerType:(SDUserRolerType)rolerType{
    if (self = [super init]) {
        self.rolerType = rolerType;
        self.backgroundColor = [UIColor whiteColor];
        self.detailModel = detailModel;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.greenView];
    if (self.detailModel.status.integerValue == 15) {
        [self initRefundView];
    }
    [self.shadowView addSubview:self.contentView];
    [self addSubview:self.shadowView];
    
    [self.contentView addSubview:self.methodLabel];
    [self.contentView addSubview:self.locaitonIv];
    [self.contentView addSubview:self.statusLabel];

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.addressLabel];
    
    [self.contentView addSubview:self.pickNameLabel];
    [self.contentView addSubview:self.pickPhoneLabel];
    
    [self.contentView addSubview:self.topSeparateLineIv];
    
    
    NSMutableArray *tempArr = [NSMutableArray array];
   
    
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
    // 设置配送方式
    NSString *methodType = [self.detailModel.distribution isEqualToString:@"1"] ? @"送货上门" : @"到店自提";
    NSString *methodStr = [NSString stringWithFormat:@"配送方式：%@", methodType];
    NSMutableAttributedString *methodText = [[NSMutableAttributedString alloc] initWithString:methodStr];
    methodText.yy_font = [UIFont fontWithName:kSDPFRegularFont size:14];
    methodText.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
    [methodText yy_setColor:[UIColor colorWithHexString:kSDMainTextColor] range:NSMakeRange(0, 5)];
    self.methodLabel.attributedText = methodText;

    if (self.detailModel.distribution.integerValue == 1) {
        self.addressLabel.hidden = NO;
        self.nameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        
        self.pickNameLabel.hidden = YES;
        self.pickPhoneLabel.hidden = YES;
        
//        self.methodLabel.text = @"配送方式：送货上门";
        self.nameLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.transInfo.name.length ? self.detailModel.transInfo.name : @"--"];
        self.phoneLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.transInfo.mobile.length ? self.detailModel.transInfo.mobile : @"--"];
        self.addressLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.transInfo.addrDetail.length ? self.detailModel.transInfo.addrDetail : @"--"];
    }else{
        self.addressLabel.hidden = YES;
        self.nameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        
        self.pickNameLabel.hidden = NO;
        self.pickPhoneLabel.hidden = NO;
        
//        self.methodLabel.text = @"配送方式：到店自提";
        if (self.detailModel.receiver.length > 0) {
            self.pickNameLabel.hidden = NO;
            self.pickNameLabel.text = [NSString stringWithFormat:@"提货人：%@", self.detailModel.receiver];
        }else {
            self.pickNameLabel.hidden = YES;
        }
        self.pickPhoneLabel.text = [NSString stringWithFormat:@"电   话：%@",self.detailModel.receiverMobile.length ? self.detailModel.receiverMobile : @"--"];
        [tempArr addObject:@{@"title" : @"预计自提时间", @"value" : self.detailModel.pickTime.length ? self.detailModel.pickTime : @"--"}];
    }
    [tempArr addObject:@{@"title" : @"订单编号", @"value" : self.detailModel.outTradeNo.length ? self.detailModel.outTradeNo : @"--"}];
    [tempArr addObject:@{@"title" : @"订单生成时间", @"value" : self.detailModel.addTime.length ? [self.detailModel.addTime convertDateStringWithTimeStr:@"yyyy-MM-dd hh:mm"] : @"--"}];
    self.headerDataArr = [SDSettingModel mj_objectArrayWithKeyValuesArray:tempArr];
    for (int i = 0; i < self.headerDataArr.count ; i++) {
        SDSettingModel *dataModel = self.headerDataArr[i];
        UIView *generalView = [self generalViewWithData:dataModel valueColor:nil];
        [self.contentView addSubview:generalView];
        [self.generalViewArr addObject:generalView];
    }
    [self updateStatusLabelText:self.detailModel.status];
}
- (void)initRefundView{
    [self.contentView addSubview:self.refundView];
    [self.refundView addSubview:self.refundLabel];
    [self.refundView addSubview:self.refundLine];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(85);
    }];
    CGFloat separateLineIvTop = 115;
    if (self.detailModel.status.integerValue == 15) {
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
        separateLineIvTop = separateLineIvTop + 60;
    }else{
        [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(35);
            make.height.mas_equalTo(14);
        }];
    }
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
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
//        make.right.equalTo(self.statusLabel.mas_left);
//    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerY.equalTo(self.methodLabel);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(14);
    }];
    
    [self.locaitonIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.methodLabel);
        make.size.mas_equalTo(CGSizeMake(29 * 0.5, 32 * 0.5));
    }];
    
    
    if (self.detailModel.distribution.integerValue == 1) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locaitonIv);
            make.top.mas_equalTo(self.methodLabel.mas_bottom).mas_equalTo(15);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(self.phoneLabel.mas_left).mas_equalTo(-20).with.priorityHigh();
        }];
        
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
    }else {
        if (self.pickNameLabel.hidden) {
            [self.pickPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.locaitonIv);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(self.methodLabel.mas_bottom).mas_equalTo(22);
            }];
            separateLineIvTop = separateLineIvTop - 35;
        }else {
            [self.pickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.locaitonIv);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(self.methodLabel.mas_bottom).mas_equalTo(22);
            }];
            
            [self.pickPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.locaitonIv);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(self.pickNameLabel.mas_bottom).mas_equalTo(15);
            }];
        }
    }
    
    [self.topSeparateLineIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
//        make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
        make.top.mas_equalTo(separateLineIvTop);
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

//- (void)setDetailModel:(SDOrderDetailModel *)detailModel {
//    _detailModel = detailModel;
//    
//    // 设置配送方式
//    NSString *methodType = [_detailModel.distribution isEqualToString:@"1"] ? @"送货上门" : @"到店自提";
//    NSString *methodStr = [NSString stringWithFormat:@"配送方式：%@", methodType];
//    NSMutableAttributedString *methodText = [[NSMutableAttributedString alloc] initWithString:methodStr];
//    methodText.yy_font = [UIFont fontWithName:kSDPFRegularFont size:14];
//    methodText.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
//    [methodText yy_setColor:[UIColor colorWithHexString:kSDMainTextColor] range:NSMakeRange(0, 5)];
//    self.methodLabel.attributedText = methodText;
//
//    
//    NSMutableArray *tempArr = [NSMutableArray array];
//    if ([self.detailModel.distribution isEqualToString:@"1"]) { // 送货上门
//        self.nameLabel.text = _detailModel.transInfo.name;
//        self.phoneLabel.text = _detailModel.transInfo.mobile;
//        self.addressLabel.text = _detailModel.transInfo.addrDetail;
//        //        self.userAddressLabel.text = _detailModel.transInfo.addrDetail;
//        //        self.namePhoneLabel.text = [NSString stringWithFormat:@"%@ (%@) %@", _detailModel.transInfo.name, _detailModel.transInfo.sex, _detailModel.transInfo.mobile];
//        //        [tempArr addObject:@{@"title" : @"预计自提时间。", @"value" : _detailModel.delivery}];
//    }else { // 到店自提
//        self.nameLabel.text = _detailModel.repoInfo.name;
//        self.phoneLabel.text = _detailModel.repoInfo.phone;
//        self.addressLabel.text = _detailModel.repoInfo.addrDetail;
//        //        self.shopNameLabel.text = _detailModel.repoInfo.name;
//        //        self.shopPhoneLabel.text = _detailModel.repoInfo.phone;
//        //        self.shopAddressLabel.text = _detailModel.repoInfo.addrDetail;
//        //        [tempArr addObject:@{@"title" : @"提货日期", @"value" : _detailModel.pickDate}];
//        //        [tempArr addObject:@{@"title" : @"提货时间", @"value" : _detailModel.pickTime}];
//        //        NSString *delivery = [NSString stringWithFormat:@"%@ %@", _detailModel.pickDate, _detailModel.pickTime];
//        [tempArr addObject:@{@"title" : @"预计自提时间", @"value" : _detailModel.pickTime}];
//    }
//    [tempArr addObject:@{@"title" : @"订单编号", @"value" : _detailModel.outTradeNo}];
//    [tempArr addObject:@{@"title" : @"订单生成时间", @"value" : _detailModel.orderTime}];
//    self.headerDataArr = [SDSettingModel mj_objectArrayWithKeyValuesArray:tempArr];
//
//}

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
- (void)updateStatusLabelText:(NSString *)status{
    if (status.integerValue == 3) {
        if (self.rolerType == SDUserRolerTypeNormal) {
            self.statusLabel.text = @"待收货";
        }else{
            self.statusLabel.text = @"待发货";
        }
        
    }else if (status.integerValue == 4){
        self.statusLabel.text = @"交易完成";
    }else if (status.integerValue == 2){
        self.statusLabel.text = @"待付款";
    }else if (status.integerValue == 31){
        self.statusLabel.text = @"已发货";
    }else if (status.integerValue == 15){
        self.statusLabel.text = @"已取消";
    }else{
        
    }
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
        NSString *methodStr = [NSString stringWithFormat:@"配送方式：%@", @"到店自提"];
        NSMutableAttributedString *methodText = [[NSMutableAttributedString alloc] initWithString:methodStr];
        methodText.yy_font = [UIFont fontWithName:kSDPFRegularFont size:14];
        methodText.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
        [methodText yy_setColor:[UIColor colorWithHexString:kSDMainTextColor] range:NSMakeRange(0, 5)];
        _methodLabel.attributedText = methodText;
    }
    return _methodLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor =  [UIColor colorWithHexString:kSDGreenTextColor];
        _statusLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}
- (UIImageView *)locaitonIv {
    if (!_locaitonIv) {
        _locaitonIv = [[UIImageView alloc] init];
        _locaitonIv.image = [UIImage imageNamed:@"mine_order_location"];
    }
    return _locaitonIv;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor =  [UIColor colorWithHexString:kSDMainTextColor];
        _nameLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor =  [UIColor colorWithHexString:kSDMainTextColor];
        _phoneLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
        _addressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}

- (UILabel *)pickNameLabel {
    if (!_pickNameLabel) {
        _pickNameLabel = [[UILabel alloc] init];
        _pickNameLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
        _pickNameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    }
    return _pickNameLabel;
}

- (UILabel *)pickPhoneLabel {
    if (!_pickPhoneLabel) {
        _pickPhoneLabel = [[UILabel alloc] init];
        _pickPhoneLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
        _pickPhoneLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    }
    return _pickPhoneLabel;
}


- (UIImageView *)topSeparateLineIv {
    if (!_topSeparateLineIv) {
        _topSeparateLineIv = [[UIImageView alloc] init];
        _topSeparateLineIv.image = [UIImage imageNamed:@"mine_order_separate_line"];
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
- (UIView *)refundLine{
    if (!_refundLine) {
        _refundLine = [[UIView alloc] init];
        _refundLine.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
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
@end

