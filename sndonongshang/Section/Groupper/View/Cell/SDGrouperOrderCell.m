
//
//  SDGrouperOrderCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperOrderCell.h"
#import "SDGoodModel.h"
#import "SDSendGoodRequest.h"

@interface SDGrouperOrderCell ()

@property (nonatomic, weak) UIImageView *contentIv;
@property (nonatomic, weak) YYLabel *tipslabel;
@property (nonatomic, weak) YYLabel *orderNumLabel;
@property (nonatomic, weak) YYLabel *statusLabel;
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UIImageView *dotIv;
@property (nonatomic, weak) YYLabel *countLabel;
@property (nonatomic, weak) UILabel *shopNameLabel;
@property (nonatomic, weak) UIView *shopsView;
@property (nonatomic, strong) NSMutableArray *shopViewArr;

@property (nonatomic, strong) UIView *bottomLineView;

/** 收货人 */
@property (nonatomic, strong) UILabel *consigneeLabel;
/** 收货人 */
@property (nonatomic, strong) UILabel *mobileLabel;
/** 佣金 */
@property (nonatomic, strong) UILabel *brokerageLabel;
/**退款 **/
@property (nonatomic, strong) UILabel *refundLabel;

/** 发货按钮 */
@property (nonatomic, weak) UIButton *deliverBtn;

@property (nonatomic, assign) CGFloat shopWH;
@property (nonatomic, assign) CGFloat shopMaxCount;

@end

@implementation SDGrouperOrderCell

static CGFloat const ShopMarigin = 10;
static CGFloat const CountW = 45;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
        [self countShopWH];
        [self initSubView];
    }
    return self;
}

- (void)countShopWH {
    self.shopMaxCount = 4;
    if (iPhone4 || iPhone5) {
        self.shopMaxCount = 3;
    }
    CGFloat shopsW = SCREEN_WIDTH - 10 * 2 - 15 * 2 - 17 - 4 - CountW - 6;
    self.shopWH = (shopsW - ShopMarigin * (self.shopMaxCount - 1)) / self.shopMaxCount;
    NSLog(@"shopWH %f", self.shopWH);
}

- (void)initSubView {
    UIImageView *contentIv = [[UIImageView alloc] init];
    contentIv.userInteractionEnabled = YES;
    contentIv.clipsToBounds = YES;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 10 * 2, 252);
    UIImage *image = [UIImage cp_imageWithColor:[UIColor whiteColor] cornerRadius:10 size:size];
    contentIv.image = image;
    self.contentIv = contentIv;
    [self.contentView addSubview:contentIv];
    
    YYLabel *tipsLabel = [[YYLabel alloc] init];
    tipsLabel.text = @"订单编号";
    tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    if (iPhone5 || iPhone4) {
        tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    }
    tipsLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    tipsLabel.displaysAsynchronously = YES;
    self.tipslabel = tipsLabel;
    [contentIv addSubview:tipsLabel];
    
    YYLabel *orderNumLabel = [[YYLabel alloc] init];
    orderNumLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    if (iPhone5 || iPhone4) {
        orderNumLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    }
    orderNumLabel.textColor = [UIColor colorWithRGB:0xC2C4C7];
    orderNumLabel.displaysAsynchronously = YES;
    self.orderNumLabel = orderNumLabel;
    [contentIv addSubview:orderNumLabel];
    
    YYLabel *statusLabel = [[YYLabel alloc] init];
    statusLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
    if (iPhone5 || iPhone4) {
        statusLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
    }
    statusLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    statusLabel.displaysAsynchronously = YES;
    
    
    self.statusLabel = statusLabel;
    [contentIv addSubview:statusLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [contentIv addSubview:lineView];
    
    
    YYLabel *countLabel = [[YYLabel alloc] init];
    countLabel.font = [UIFont fontWithName:kSDPFRegularFont size:14];
    countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel = countLabel;
    [contentIv addSubview:countLabel];
    
    UIImageView *dotIv = [[UIImageView alloc] init];
    dotIv.image = [UIImage imageNamed:@"cart_order_more"];
    self.dotIv = dotIv;
    [contentIv addSubview:dotIv];
    
    UIView *shopsView = [[UIView alloc] init];
    [contentIv addSubview:shopsView];
    self.shopsView = shopsView;
    
    UILabel *shopNameLabel = [[UILabel alloc] init];
    shopNameLabel.numberOfLines = 2;
    shopNameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
    shopNameLabel.textColor = [UIColor colorWithRGB:0x333333];
    self.shopNameLabel = shopNameLabel;
    [contentIv addSubview:shopNameLabel];
    
    for (int i = 0; i < self.shopMaxCount; i++) {
        UIButton *shopBtn = [[UIButton alloc] init];
        shopBtn.userInteractionEnabled = NO;
        shopBtn.contentMode = UIViewContentModeScaleAspectFit;
        shopBtn.backgroundColor = [UIColor colorWithRGB:0xF5F5F5];
        shopBtn.layer.cornerRadius = 5;
        shopBtn.layer.masksToBounds = YES;
        [self.shopsView addSubview:shopBtn];
        [self.shopViewArr addObject:shopBtn];
    }
    
    [contentIv addSubview:self.bottomLineView];
    [contentIv addSubview:self.consigneeLabel];
    [contentIv addSubview:self.mobileLabel];
    [contentIv addSubview:self.brokerageLabel];
    [contentIv addSubview:self.refundLabel];
    
    UIButton *deliverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deliverBtn setTitle:@"发货" forState:UIControlStateNormal];
    deliverBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
    [deliverBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    [deliverBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    deliverBtn.layer.cornerRadius = 15;
    deliverBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    deliverBtn.layer.borderWidth = 1;
    self.deliverBtn = deliverBtn;
    [contentIv addSubview:deliverBtn];
}

- (void)setModel:(SDOrderListModel *)model {
    _model = model;
    self.orderNumLabel.text = model.outTradeNo;
//    self.deliverBtn.hidden = [model.status intValue] == 2 ? NO : YES;
    for (int i = 0; i < self.shopMaxCount; i++) {
        UIButton *shopBtn = self.shopViewArr[i];
        if (i >= _model.goodsInfo.count) {
            shopBtn.hidden = YES;
        }else {
            shopBtn.hidden = NO;
            SDGoodModel *goodModel = _model.goodsInfo[i];
            [shopBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:goodModel.miniPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
        }
        if (i == 0 && _model.goodsInfo.count > 0) {
            SDGoodModel *goodModel = _model.goodsInfo.firstObject;
            self.shopNameLabel.text = goodModel.name;
        }
    }
    self.deliverBtn.hidden = YES;
    if (_model.status.integerValue == 3) {
        if (self.rolerType == SDUserRolerTypeNormal) {
            self.statusLabel.text = @"待收货";
        }else{
            self.statusLabel.text = @"待发货";
            self.deliverBtn.hidden = NO;
        }
        
    }else if (_model.status.intValue == 4){
        self.statusLabel.text = @"交易完成";
    }else if (_model.status.intValue == 2){
        self.statusLabel.text = @"待付款";
    }else if (_model.status.intValue == 31){
        self.statusLabel.text = @"已发货";
    }else if (_model.status.intValue == 3) {
        self.statusLabel.text = @"出库中";
    }else if (_model.status.intValue == 15) {
        self.statusLabel.text = @"已取消";
    }
    self.shopNameLabel.hidden = _model.goodsInfo.count == 1 ? NO : YES;
    if (_model.distribution.integerValue == 1) {
        if ( _model.receiver.length > 0) {
            self.consigneeLabel.hidden = NO;
            self.consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@", _model.receiver.length ? _model.receiver : @"--"];
        }else {
            self.consigneeLabel.hidden = YES;
        }
        self.mobileLabel.text = [NSString stringWithFormat:@"电   话：%@", _model.transInfo.mobile.length ? _model.transInfo.mobile : @"--"];
        self.brokerageLabel.text = [NSString stringWithFormat:@"佣   金：￥%@", _model.brokerage.length ? [_model.brokerage priceStr] : @"--"];
        if (_model.status.integerValue == 15) {
            self.refundLabel.hidden = NO;
            self.refundLabel.text = [NSString stringWithFormat:@"已退款：￥%@", _model.refundedAmount.length ? [_model.refundedAmount priceStr] : @"--"];
        }else{
            self.refundLabel.hidden = YES;
        }
        
        
    }else{
        if ( _model.receiver.length > 0) {
            self.consigneeLabel.hidden = NO;
            self.consigneeLabel.text = [NSString stringWithFormat:@"提货人：%@", _model.receiver.length ? _model.receiver : @"--"];
        }else {
            self.consigneeLabel.hidden = YES;
        }
        self.mobileLabel.text = [NSString stringWithFormat:@"电   话：%@", _model.receiverMobile.length ? _model.receiverMobile : @"--"];
        self.brokerageLabel.text = [NSString stringWithFormat:@"佣   金：￥%@", _model.brokerage.length ? [_model.brokerage priceStr] : @"--"];
        if (_model.status.integerValue == 15) {
            self.refundLabel.hidden = NO;
            self.refundLabel.text = [NSString stringWithFormat:@"已退款：￥%@", _model.refundedAmount.length ? [_model.refundedAmount priceStr] : @"--"];
        }else{
            self.refundLabel.hidden = YES;
        }
    }
    self.countLabel.attributedText = _model.shopCountText;
    self.countLabel.textAlignment = NSTextAlignmentRight;
}

#pragma mark - action
- (void)goPay {
    [SDStaticsManager umEvent:kordermg_fh_dialog attr:@{@"_id":self.model.orderId}];
    SD_WeakSelf;
    [SDPopView showPopViewWithContent:@"确认该订单已经发货吗？" noTap:NO confirmBlock:^{
        SD_StrongSelf;
        [SDStaticsManager umEvent:kordermg_fh_ok attr:@{@"_id":self.model.orderId}];
        SDSendGoodRequest *send = [[SDSendGoodRequest alloc] init];
        send.orderId = self.model.orderId;
        SD_WeakSelf;
        [send startWithCompletionBlockWithSuccess:^(__kindof SDSendGoodRequest * _Nonnull request) {
            SD_StrongSelf;
            if (self.sendGoodBlock) {
                self.sendGoodBlock(self.model);
            }
            [SDToastView HUDWithSuccessString:@"成功发货!"];
        } failure:^(__kindof SDSendGoodRequest * _Nonnull request) {
//            [SDToastView HUDWithSuccessString:request.msg];
        }];
    } cancelBlock:^{
        SD_StrongSelf;
        [SDStaticsManager umEvent:kordermg_fh_cancel attr:@{@"_id":self.model.orderId}];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipslabel.mas_right).mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.tipslabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.tipslabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipslabel);
        make.right.mas_equalTo(self.statusLabel);
        make.top.mas_equalTo(self.tipslabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.dotIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 5));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.countLabel);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(58);
        make.top.mas_equalTo(self.lineView).mas_equalTo(20);
        make.width.mas_equalTo(CountW);
        make.right.mas_equalTo(self.dotIv.mas_left).mas_equalTo(-6);
    }];
    
    
    [self.shopsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.countLabel.mas_left).mas_equalTo(-6);
        make.height.mas_equalTo(self.shopWH);
        make.centerY.mas_equalTo(self.countLabel);
    }];
    
    for (int i = 0; i < self.shopMaxCount; i++) {
        UIButton *shopBtn = self.shopViewArr[i];
        CGFloat x = (self.shopWH + ShopMarigin) * i;
        [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(self.shopWH, self.shopWH));
        }];
        if (i == 0) {
            [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(shopBtn.mas_right).mas_equalTo(10);
                make.centerY.mas_equalTo(shopBtn);
                make.right.mas_equalTo(self.countLabel.mas_left).mas_equalTo(-6);
            }];
        }
    }
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.shopsView.mas_bottom).mas_equalTo(15);
    }];
    
    
    [self.consigneeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomLineView);
        make.right.mas_equalTo(self.deliverBtn.mas_left).mas_equalTo(-15);
        make.top.mas_equalTo(self.bottomLineView.mas_bottom).mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    CGFloat mobileTop = self.consigneeLabel.hidden == YES ? 15 : 29 + 15;
    [self.mobileLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomLineView);
        make.right.mas_equalTo(self.deliverBtn.mas_left).mas_equalTo(-15);
        make.top.mas_equalTo(self.bottomLineView.mas_bottom).mas_equalTo(mobileTop);
        make.height.mas_equalTo(14);
    }];
    
    [self.brokerageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomLineView);
        make.right.mas_equalTo(self.mobileLabel);
        make.top.mas_equalTo(self.mobileLabel.mas_bottom).mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomLineView);
        make.right.mas_equalTo(self.deliverBtn.mas_left).mas_equalTo(-15);
        make.top.mas_equalTo(self.brokerageLabel.mas_bottom).mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [self.deliverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-26);
    }];
    
}

#pragma mark - lazy
- (NSMutableArray *)shopViewArr {
    if (!_shopViewArr) {
        _shopViewArr = [NSMutableArray array];
    }
    return _shopViewArr;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _bottomLineView;
}

- (UILabel *)consigneeLabel {
    if (!_consigneeLabel) {
        _consigneeLabel = [[UILabel alloc] init];
        _consigneeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _consigneeLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    }
    return _consigneeLabel;
}

- (UILabel *)mobileLabel {
    if (!_mobileLabel) {
        _mobileLabel = [[UILabel alloc] init];
        _mobileLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _mobileLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    }
    return _mobileLabel;
}

- (UILabel *)brokerageLabel {
    if (!_brokerageLabel) {
        _brokerageLabel = [[UILabel alloc] init];
        _brokerageLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _brokerageLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    }
    return _brokerageLabel;
}
- (UILabel *)refundLabel {
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _refundLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    }
    return _refundLabel;
}
@end
