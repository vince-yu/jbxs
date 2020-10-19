//
//  SDMyOrderCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyOrderCell.h"
#import "SDMyOrderShopCell.h"
#import "SDPayViewController.h"

@interface SDMyOrderCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UIImageView *contentIv;
@property (nonatomic, weak) YYLabel *tipslabel;
@property (nonatomic, weak) YYLabel *timeLabel;
@property (nonatomic, weak) YYLabel *statusLabel;
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UIImageView *dotIv;
@property (nonatomic, weak) YYLabel *countLabel;
@property (nonatomic, weak) UILabel *shopNameLabel;
@property (nonatomic, weak) UIView *shopsView;
@property (nonatomic, strong) NSMutableArray *shopViewArr;

@property (nonatomic, weak) UILabel *priceTipsLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UIButton *payBtn;

@property (nonatomic, assign) CGFloat shopWH;
@property (nonatomic, assign) CGFloat shopMaxCount;

@end

@implementation SDMyOrderCell

static NSString * const cellID = @"SDMyOrderShopCell";
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
    CGSize size = CGSizeMake(SCREEN_WIDTH - 10 * 2, 260);
    UIImage *image = [UIImage cp_imageWithColor:[UIColor whiteColor] cornerRadius:5 size:size];
    contentIv.image = image;
    self.contentIv = contentIv;
    [self.contentView addSubview:contentIv];

    YYLabel *tipsLabel = [[YYLabel alloc] init];
    tipsLabel.text = @"下单时间";
    tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    if (iPhone5 || iPhone4) {
        tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    }
    tipsLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    tipsLabel.displaysAsynchronously = YES;
    self.tipslabel = tipsLabel;
    [contentIv addSubview:tipsLabel];
    
    YYLabel *timeLabel = [[YYLabel alloc] init];
    timeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    if (iPhone5 || iPhone4) {
        timeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    }
    timeLabel.textColor = [UIColor colorWithRGB:0xC2C4C7];
    timeLabel.displaysAsynchronously = YES;
    self.timeLabel = timeLabel;
    [contentIv addSubview:timeLabel];
    
    YYLabel *statusLabel = [[YYLabel alloc] init];
    statusLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
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
    
    UILabel *priceTipsLabel = [[UILabel alloc] init];
    priceTipsLabel.font = [UIFont fontWithName:kSDPFBoldFont size:14];
    priceTipsLabel.textColor = [UIColor colorWithRGB:0x131413];
    self.priceTipsLabel = priceTipsLabel;
    [contentIv addSubview:priceTipsLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
    priceLabel.textColor = [UIColor colorWithRGB:0x131413];
    self.priceLabel = priceLabel;
    [contentIv addSubview:priceLabel];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
    [payBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    payBtn.layer.cornerRadius = 15;
    payBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    payBtn.layer.borderWidth = 1;
    self.payBtn = payBtn;
    [contentIv addSubview:payBtn];
}

- (void)setModel:(SDOrderListModel *)model {
    _model = model;
    self.timeLabel.text = model.time;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", [model.amount priceStr]];
    self.countLabel.attributedText = _model.shopCountText;
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.priceTipsLabel.text = @"实付款：";
    if (model.status.intValue == 2) {
        self.priceTipsLabel.text = @"需付款：";
        self.statusLabel.text = @"等待买家付款";
    }else if (model.status.intValue == 31) {
        self.statusLabel.text = @"已发货";
    }else if (model.status.intValue == 3) {
        self.statusLabel.text = @"出库中";
    }else if (_model.status.intValue == 15) {
        self.priceTipsLabel.text = @"已退款：";
        self.statusLabel.text = @"已取消";
    }else{
        self.statusLabel.text = @"交易完成";
    }
    self.payBtn.hidden = [model.status intValue] == 2 ? NO : YES;
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
    self.shopNameLabel.hidden = _model.goodsInfo.count == 1 ? NO : YES;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.goodsInfo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SDMyOrderShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    SDGoodModel *goodModel = self.model.goodsInfo[indexPath.row];
    cell.goodModel = goodModel;
    return cell;
}

#pragma mark - action
- (void)goPay {
    [SDStaticsManager umEvent:korder_list_topay];
    if (!self.model) {
        return;
    }
    SDCartOderModel *orderModel = [[SDCartOderModel alloc] init];
    orderModel.amount = self.model.amount;
    orderModel.orderId = self.model.orderId;
    
    SDPayViewController *vc = [[SDPayViewController alloc] init];
    vc.orderModel = orderModel;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
   
    [self.tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.priceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipslabel);
        make.centerY.mas_equalTo(self.priceLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceTipsLabel.mas_right);
        make.bottom.mas_equalTo(self.contentIv.mas_bottom).mas_equalTo(-25);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-26);
    }];
    
}

- (NSMutableArray *)shopViewArr {
    if (!_shopViewArr) {
        _shopViewArr = [NSMutableArray array];
    }
    return _shopViewArr;
}

@end
