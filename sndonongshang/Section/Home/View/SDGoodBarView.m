//
//  SDGoodBarView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodBarView.h"
#import "SDCartDataManager.h"

@interface SDGoodBarView ()
@property (nonatomic ,strong) UIButton *cartBtn;
@property (nonatomic ,strong) UIImageView *cartImageView;
@property (nonatomic ,strong) UILabel *countLabel;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UILabel *cartLabel;
@property (nonatomic ,strong) UILabel *shareLabel;
//buy and cart
@property (nonatomic ,strong) UIView *cartView;
@property (nonatomic ,strong) UIView *buynowView;
@property (nonatomic ,strong) UIButton *buynowBtn;
@property (nonatomic ,strong) UIView *addCartView;
@property (nonatomic ,strong) UIButton *addCartBtn;
//group buy
@property (nonatomic ,strong) UIView *groupBuyView;
@property (nonatomic ,strong) UIButton *groupShareBtn;
@property (nonatomic ,strong) UIImageView *groupShareImageView;
//remind
@property (nonatomic ,strong) UIView *remindView;
@property (nonatomic ,strong) UIButton *remindBtn;
@property (nonatomic ,copy) NSString *isBegin;
@property (nonatomic ,copy) NSString *isRemind;
@property (nonatomic ,copy) NSString *isGoodRemind;
@end

@implementation SDGoodBarView
- (instancetype)initWithFrame:(CGRect)frame type:(SDGoodBarStyle )type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initSubViews];
        [self updateBageCount];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBageCount) name:kNotifiRefreshCartGoodCount object:nil];
    }
    return self;
}
- (void)updateBageCount{
    NSInteger count = [SDCartDataManager getAllCartGoodsCount];
//    count = 100;
    if (count <= 0) {
        self.countLabel.hidden = YES;
    }else{
        self.countLabel.hidden = NO;
        [self.countLabel layoutIfNeeded];
        if (count <= 99) {
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
            [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(16);
            }];
        }else{
            self.countLabel.text = @"99+";
            [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(25);
            }];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshCartGoodCount object:nil];
}
- (void)initSubViews{
    if (self.type == SDGoodBarStyleGroupBuy || self.type == SDGoodBarStyleGroupBuyRemind) {
        [self initCartAndShareView];
    }else if (self.type == SDGoodBarStyleArrivalReminder){
        
    }else{
        [self initCartView];
    }
    switch (self.type) {
        case SDGoodBarStyleBuyAndCart:
        {
            [self initBuyAndCartBar];
        }
            break;
        case SDGoodBarStyleCart:
        {
            [self initCartBar];
        }
            break;
        case SDGoodBarStyleSeconedKill:
        {
            [self initBuyAndCartBar];
        }
            break;
        case SDGoodBarStyleRemind:
        {
            [self initRemindBar];
        }
            break;
        case SDGoodBarStyleGroupBuy:
        {
            [self initGroupBuyBar];
        }
            break;
        case SDGoodBarStyleGroupBuyRemind:
        {
            [self initGroupBuyRemindBar];
        }
            break;
        case SDGoodBarStyleArrivalReminder:
        {
            [self initArrivalReminBar];
        }
            break;
        default:
            break;
    }
    
}
- (void)setRemindStr:(NSString *)remindStr{
    [self.remindBtn setTitle:remindStr forState:UIControlStateNormal];
}
- (void)setBuyStr:(NSString *)buyStr{
    [self.buynowBtn setTitle:buyStr forState:UIControlStateNormal];
}
- (void)setType:(SDGoodBarStyle)type{
    _type = type;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self initSubViews];
    [self updateBageCount];
}
- (void)initArrivalReminBar{
    [self addSubview:self.remindView];
    [self.remindView addSubview:self.remindBtn];
    
    [self.remindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self);
        //        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(55);
    }];
    [self.remindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.remindView);
        make.height.mas_equalTo(55);
        //        make.width.mas_equalTo(65);
    }];
}
- (void)initRemindBar{
    [self addSubview:self.remindView];
    [self.remindView addSubview:self.remindBtn];
    
    [self.remindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartView.mas_right);
        make.top.equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(55);
    }];
    [self.remindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.remindView);
        make.height.mas_equalTo(55);
    }];
}
- (void)initCartAndShareView{
    [self addSubview:self.cartView];
    [self addSubview:self.lineView];
    
    [self.cartView addSubview:self.cartBtn];
    [self.cartView addSubview:self.groupShareBtn];
    [self.cartBtn addSubview:self.cartImageView];
    [self.groupShareBtn addSubview:self.groupShareImageView];
    [self.cartBtn addSubview:self.cartLabel];
    [self.groupShareBtn addSubview:self.shareLabel];
    
    [self.cartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(55);
    }];
    [self.cartImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cartBtn);
        make.top.mas_equalTo(12);
        make.height.width.mas_equalTo(21);
    }];
    [self.groupShareImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.groupShareBtn);
        make.top.mas_equalTo(12);
        make.height.width.mas_equalTo(21);
    }];
    [self.cartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.cartView);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(65);
    }];
    [self.groupShareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cartView);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(65);
        make.left.equalTo(self.cartBtn.mas_right);
    }];
    
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(55);
        //        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(1);
    }];
    

    [self.cartLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cartBtn);
        make.top.equalTo(self.cartImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    [self.shareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.groupShareBtn);
        make.top.equalTo(self.groupShareImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    [self.cartBtn addSubview:self.countLabel];
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.centerX.equalTo(self.cartImageView.mas_right);
        make.centerY.equalTo(self.cartImageView.mas_top);
    }];
}
- (void)initCartView{
    [self addSubview:self.cartView];
    [self.cartView addSubview:self.cartBtn];
    [self.cartBtn addSubview:self.cartImageView];
    [self addSubview:self.lineView];
    [self.cartBtn addSubview:self.cartLabel];
    
    [self.cartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(80);
    }];
    [self.cartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.cartView);
        make.height.mas_equalTo(55);
    }];
    [self.cartImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cartBtn);
        make.top.mas_equalTo(12);
        make.height.width.mas_equalTo(21);
    }];
    
    [self.cartBtn addSubview:self.countLabel];
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.centerX.equalTo(self.cartImageView.mas_right);
        make.centerY.equalTo(self.cartImageView.mas_top);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(55);
        //        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(1);
    }];
    [self.cartLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cartBtn);
        make.top.equalTo(self.cartImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
}
- (void)initBuyAndCartBar{
   
    [self addSubview:self.buynowView];
    [self addSubview:self.addCartView];
    
    
    CGFloat itemWidth = (SCREEN_WIDTH - 80) / 2.0;
    
    [self.buynowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addCartView.mas_right);
        make.top.equalTo(self);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(55);
    }];
    [self.addCartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartView.mas_right);
        make.top.equalTo(self);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(55);
    }];
    
    
    
    [self.buynowView addSubview:self.buynowBtn];
    
    [self.buynowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.buynowView);
        make.height.mas_equalTo(55);
    }];
    
    [self.addCartView addSubview:self.addCartBtn];
    
    [self.addCartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.addCartView);
        make.height.mas_equalTo(55);
    }];
    
    
}
- (void)initCartBar{
    [self addSubview:self.addCartView];
    [self.addCartView addSubview:self.addCartBtn];
    
    [self.addCartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartView.mas_right);
        make.top.equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(55);
    }];
    [self.addCartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.addCartView);
        make.height.mas_equalTo(55);
    }];
    
    [self.addCartBtn addSubview:self.cartLabel];
    
    [self.cartLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addCartBtn);
        make.bottom.mas_equalTo(-9);
        make.height.mas_equalTo(10);
    }];
    
}
- (void)initGroupBuyRemindBar{
    [self addSubview:self.remindView];
    [self.remindView addSubview:self.remindBtn];
    
    [self.remindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.cartView.mas_right);
//        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(55);
    }];
    [self.remindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.remindView);
        make.height.mas_equalTo(55);
//        make.width.mas_equalTo(65);
    }];
}
- (void)initGroupBuyBar{
    
    CGFloat itemWidth = (SCREEN_WIDTH - 130) / 2.0;
    
    
    
    [self addSubview:self.addCartView];
    [self addSubview:self.buynowView];
    
    [self.addCartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.cartView.mas_right);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(55);
    }];
    [self.buynowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.addCartView.mas_right);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(55);
    }];
    
    
    [self.addCartView addSubview:self.addCartBtn];
    [self.buynowView addSubview:self.buynowBtn];
    [self.buynowBtn setTitle:@"立即参团" forState:UIControlStateNormal];
    [self.addCartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.addCartView);
        make.height.mas_equalTo(55);
//        make.width.mas_equalTo(65);
    }];
    
    [self.buynowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.buynowView);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(65);
    }];
}
#pragma lazy init
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xededed"];
    }
    return _lineView;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.layer.cornerRadius = 8;
        _countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _countLabel.layer.borderWidth = 1;
        self.countLabel.layer.masksToBounds = YES;
    }
    return _countLabel;
}
- (UILabel *)cartLabel{
    if (!_cartLabel) {
        _cartLabel = [[UILabel alloc] init];
        _cartLabel.textAlignment = NSTextAlignmentCenter;
        _cartLabel.textColor = [UIColor colorWithHexString:@"0x868687"];
        _cartLabel.text = @"购物车";
        _cartLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _cartLabel;
}
- (UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.textAlignment = NSTextAlignmentCenter;
        _shareLabel.textColor = [UIColor colorWithHexString:@"0x868687"];
        _shareLabel.text = @"邀请好友";
        _shareLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
    }
    return _shareLabel;
}
- (UIView *)cartView{
    if (!_cartView) {
        _cartView = [[UIView alloc] init];
    }
    return _cartView;
}
- (UIImageView *)cartImageView{
    if (!_cartImageView) {
        _cartImageView = [[UIImageView alloc] init];
        [_cartImageView setImage:[UIImage imageNamed:@"tabbar_car"]];
    }
    return _cartImageView;
}
- (UIView *)buynowView{
    if (!_buynowView) {
        _buynowView = [[UIView alloc] init];
        _buynowView.backgroundColor =[UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
    }
    return _buynowView;
}
- (UIButton *)buynowBtn{
    if (!_buynowBtn) {
        _buynowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.type == SDGoodBarStyleSeconedKill) {
            [_buynowBtn setTitle:@"立即秒杀" forState:UIControlStateNormal];
        }else{
            [_buynowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        }
        [_buynowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buynowBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
        [_buynowBtn addTarget:self action:@selector(pushOrderVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buynowBtn;
}
- (UIImageView *)groupShareImageView{
    if (!_groupShareImageView) {
        _groupShareImageView = [[UIImageView alloc] init];
        [_groupShareImageView setImage:[UIImage imageNamed:@"good_detail_barShare"]];
    }
    return _groupShareImageView;
}
- (UIButton *)remindBtn{
    if (!_remindBtn) {
        _remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remindBtn.titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        [_remindBtn setTitle:@"提醒我" forState:UIControlStateNormal];
        [_remindBtn addTarget:self action:@selector(remindAction) forControlEvents:UIControlEventTouchUpInside];
        [_remindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _remindBtn;
}
- (UIView *)remindView{
    if (!_remindView) {
        _remindView = [[UIView alloc] init];
        _remindView.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
    return _remindView;
}
- (UIView *)addCartView{
    if (!_addCartView) {
        _addCartView = [[UIView alloc] init];
        _addCartView.backgroundColor = [UIColor colorWithHexString:@"0x2E302E"];
    }
    return _addCartView;
}
- (UIButton *)addCartBtn{
    if (!_addCartBtn) {
        _addCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addCartBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
        [_addCartBtn addTarget:self action:@selector(addGoodToCart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCartBtn;
}
    
- (UIView *)groupBuyView{
    if (!_groupBuyView) {
        _groupBuyView = [[UIView alloc] init];
//        _groupBuyView.backgroundColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
//        _groupBuyView.layer.cornerRadius = 20;
    }
    return _groupBuyView;
}
- (UIButton *)groupShareBtn{
    if (!_groupShareBtn) {
        _groupShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_groupShareBtn setImage:[UIImage imageNamed:@"good_detail_barShare"] forState:UIControlStateNormal];
        [_groupShareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupShareBtn;
}
- (UIButton *)cartBtn{
    if (!_cartBtn) {
        _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cartBtn setImage:[UIImage imageNamed:@"tabbar_car"] forState:UIControlStateNormal];
        [_cartBtn addTarget:self action:@selector(pushToCartDetailVC) forControlEvents:UIControlEventTouchUpInside];
//        [_cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
//        _cartBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
//        [_cartBtn setTitleColor:[UIColor colorWithHexString:@"0x868687"] forState:UIControlStateNormal];
//        _cartBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        CGFloat imageWidth = _cartBtn.imageView.bounds.size.width;
//        CGFloat labelWidth = _cartBtn.titleLabel.bounds.size.width;
//        _cartBtn.titleEdgeInsets = UIEdgeInsetsMake(-imageWidth * 0.5, labelWidth * 0.5, imageWidth*0.5, -labelWidth * 0.5);
//        _cartBtn.imageEdgeInsets = UIEdgeInsetsMake(labelWidth * 0.5, -imageWidth * 0.5, -labelWidth * 0.5, imageWidth*0.5);
    }
    return _cartBtn;
}
- (void)updateBarView:(NSString *)status begin:(BOOL )isBegin{
    self.isBegin = [NSString stringWithFormat:@"%d",isBegin];
    self.isRemind = status;
    if (isBegin) {
        self.remindBtn.hidden = YES;
    }else{
        self.remindBtn.hidden = NO;
        if (status.boolValue) {
            [self.remindBtn setTitle:@"取消提醒" forState:UIControlStateNormal];
        }else{
            [self.remindBtn setTitle:@"提醒我" forState:UIControlStateNormal];
        }
    }
}
#pragma mark Function
- (void)pushToCartDetailVC{
    if (self.pushToCartVC) {
        self.pushToCartVC();
    }
}
- (void)addGoodToCart{
    if (self.addToCartBlock) {
        self.addToCartBlock();
    }
}
- (void)pushOrderVC{
    if (self.buyNowBlock) {
        self.buyNowBlock();
    }
}
- (void)remindAction{
    if (self.remindBlock) {
        self.remindBlock();
    }
}
- (void)shareAction{
    if (self.shareBlock) {
        self.shareBlock();
    }
}
@end
