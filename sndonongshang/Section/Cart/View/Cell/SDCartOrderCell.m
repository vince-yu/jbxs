//
//  SDCartOrderCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOrderCell.h"
#import "SDCartDataManager.h"
#import "SDCustomPickerView.h"
#import "SDCartCouponsPopView.h"

@interface SDCartOrderCell ()
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseCouponBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIImageView *moreCouponImage;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seletTimeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodViewTop;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderMoreImage;
@property (weak, nonatomic) IBOutlet UIButton *oderMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;

@end

@implementation SDCartOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor  = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    self.seletTimeImage.hidden = YES;
    self.timeLabel.hidden = YES;
    self.lineView.hidden = YES;
    self.timeRight.constant = 36;
    self.goodViewTop.constant = 20;
    self.titleLabel.hidden = YES;
    [self.goodsView bringSubviewToFront:self.orderMoreBtn];
    self.chooseTimeBtn.hidden = YES;
}
- (void)setOrderModel:(SDCartOderModel *)orderModel{
    _orderModel = orderModel;
    [self initGoodsView:_orderModel.goodsInfo];
    self.totalLabel.text = [NSString stringWithFormat:@"￥%@",_orderModel.totalPrice.length ? [_orderModel.totalPrice priceStr] : @"0"];
    self.sendPriceLabel.text = [NSString stringWithFormat:@"￥%@",_orderModel.transPrice.length ? [_orderModel.transPrice priceStr]: @"-"];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",(long)[SDCartDataManager getAllPreOderGoodsCount]];
    NSInteger vcount = [SDCartDataManager enbleVoucher];
    if (!vcount) {
        SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
        NSString *addressId = [SDCartDataManager sharedInstance].prepayModel.userAddrId;
        NSString *repoId = [SDCartDataManager sharedInstance].prepayModel.repoId;
        if (((type == SDCartOrderTypeDelivery ||type == SDCartOrderTypeDeliveryOnly || type == SDCartOrderTypeSelfTakeOnly) && !addressId.length)
            || (type == SDCartOrderTypeSelfTake && !repoId.length)) {
            self.couponPriceLabel.text = @"选择地址后使用优惠券";
        }else{
            self.couponPriceLabel.text = @"暂无可用";
        }
        self.moreCouponImage.hidden = YES;
        self.couponPriceLabel.textColor = [UIColor colorWithHexString:@"0x999897"];
        self.couponPriceLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        self.couponBtn.enabled = NO;
    }else{
        self.moreCouponImage.hidden = NO;
        self.couponBtn.enabled = YES;
        if (self.orderModel.reducePrice.floatValue == 0) {
            self.couponPriceLabel.textColor = [UIColor colorWithHexString:@"0x999897"];
            self.couponPriceLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
            self.couponPriceLabel.text = [NSString stringWithFormat:@"有%ld张可使用优惠券",vcount];
        }else{
            self.couponPriceLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
            self.couponPriceLabel.font = [UIFont fontWithName:kSDPFBoldFont size:13];
            self.couponPriceLabel.text = _orderModel.reducePrice.length ? [NSString stringWithFormat:@"优惠%@元",[_orderModel.reducePrice priceStr]]  : @"0";
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initGoodsView:(NSArray *)goodsArray{
    for (UIView *view in self.goodsView.subviews) {
        if (![view isEqual:self.totalCountLabel] && ![view isEqual:self.oderMoreBtn] && ![view isEqual:self.orderMoreImage]) {
            [view removeFromSuperview];
        }
    }
    CGFloat offset = 10.0;
    NSInteger items = 4;
    if (SCREEN_WIDTH < 414) {
        items = 3;
    }
    CGFloat itemWith = (SCREEN_WIDTH - 50 - 30 - 65) / items;
    for (int i = 0 ; i < goodsArray.count ; i ++) {
        if (i >= items) {
            break;
        }
        SDGoodModel *good = [goodsArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:good.miniPic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
        [self.goodsView addSubview:imageView];
        imageView.backgroundColor = [UIColor purpleColor];
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        CGFloat tureWith = itemWith;
        if (itemWith > 58) {
            tureWith = 58;
        }
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * (itemWith + offset));
            make.width.height.mas_equalTo(tureWith);
            make.centerY.equalTo(self.goodsView.mas_centerY);
        }];
        if (goodsArray.count == 1 && i == 0) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:kSDPFMediumFont size:12];
            label.numberOfLines = 2;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.textColor = [UIColor colorWithHexString:@"0x333333"];
            [self.goodsView addSubview:label];
            label.text = good.name;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.goodsView);
                make.left.equalTo(imageView.mas_right).offset(10);
                make.right.equalTo(self.orderMoreBtn.mas_left).offset(-10);
            }];
        }
    }
}
- (IBAction)chooseCouponAction:(id)sender {
}
- (IBAction)chooseTimeAction:(id)sender {
    return;
    if ([SDCartDataManager sharedInstance].prepayModel.type != SDCartOrderTypeDelivery || !self.orderModel.deliveryTime.count) {
        return;
    }
    SDCustomPickerView *pickerView = [[SDCustomPickerView alloc]init];
    NSArray *timeArray = [self timeItems];
    NSString *defaultTime = [self convertDateStringWithTimeStr:@"yyyy-MM-dd hh:mm" timeStr:[SDCartDataManager sharedInstance].prepayModel.deliveryTime];
    [pickerView setItems:timeArray title:@"" defaultStr:defaultTime];
    SD_WeakSelf;
    pickerView.selectedIndex = ^(NSInteger index){
        SD_StrongSelf;
        [SDCartDataManager sharedInstance].prepayModel.deliveryTime = [NSString stringWithFormat:@"%@",[self.orderModel.deliveryTime objectAtIndex:index]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiCartPrePayReload object:nil];
    };
    [pickerView show];
}
- (NSArray *)timeItems{
    NSMutableArray *array = [NSMutableArray array];
    for (id time in self.orderModel.deliveryTime) {
//        NSString *str = [[NSString stringWithFormat:@"time"] convertDateStringWithTimeStr:@"yyyy-MM-dd hh:mm:ss"];
        NSString *str = [self convertDateStringWithTimeStr:@"yyyy-MM-dd hh:mm" timeStr:time];
        [array addObject:str];
    }
    return array;
}
- (NSString *)convertDateStringWithTimeStr:(NSString *)formatterStr timeStr:(NSString *)time{
    NSTimeInterval interval = time.floatValue / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
- (IBAction)showOrderList:(id)sender {
    [SDStaticsManager umEvent:kpurchase_goods];
    [SDCartDataManager pushToOrderListView];
}
- (IBAction)showCouponList:(id)sender {
    [SDStaticsManager umEvent:kpurchase_coupon];
    [SDCartCouponsPopView popViewWithOrderModel:self.orderModel confirmBlock:^(SDCouponsModel * _Nonnull couponModel, SDCouponsModel * _Nonnull freightModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshOrderTableView object:nil];
    }];
    
}
@end
