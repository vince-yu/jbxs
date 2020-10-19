//
//  SDCartOrderListView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOrderListView.h"
#import "SDOderGoodCell.h"
#import "SDCartDataManager.h"
#import "SDLimitSecondKillOrderCell.h"

@interface  SDCartOrderListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIView *backGroudView;
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UITableView *listTableView;
@property (nonatomic ,strong) UIView *titleView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *totalLabel;
@property (nonatomic ,strong) UIButton *closeBtn;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIImageView *closeImageView;
@property (nonatomic ,strong) UIButton *deleteBtn;
@property (nonatomic ,strong) NSArray *dataArray;
@end

@implementation SDCartOrderListView
- (instancetype)initWithFrame:(CGRect)frame type:(SDCartOrderListViewType )type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        if (self.type == SDCartOrderListViewTypeDelete) {
            self.dataArray = [SDCartDataManager sharedInstance].orderExpressGoods;
        }else{
            self.dataArray = [SDCartDataManager sharedInstance].preOrderModel.goodsInfo;
        }
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    [self addSubview:self.backGroudView];
    
    [self.backGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.8);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.listTableView];
    [self.contentView addSubview:self.lineView];
    if (self.type == SDCartOrderListViewTypeDelete) {
        [self.contentView addSubview:self.deleteBtn];
        self.totalLabel.text = [NSString stringWithFormat:@"共%ld件",[SDCartDataManager sharedInstance].orderExpressGoodCount];
        self.titleLabel.text = @"以下商品不支持送货上门";
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(-kBottomSafeHeight);
        }];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.deleteBtn.mas_top);
        }];
    }else{
        self.totalLabel.text = [NSString stringWithFormat:@"共%ld件",[SDCartDataManager getAllPreOderGoodsCount]];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(57);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_offset(57);
    }];
    
    
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.totalLabel];
    [self.titleView addSubview:self.closeBtn];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(10);
        make.right.equalTo(self.closeBtn.mas_left).offset(-10);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(50);
        make.centerY.equalTo(self.titleLabel);
        make.right.mas_equalTo(0);
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.closeBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.titleLabel);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark init
- (UIView *)backGroudView{
    if (!_backGroudView) {
        _backGroudView = [[UIView alloc] init];
        _backGroudView.backgroundColor = [UIColor blackColor];
        _backGroudView.alpha = 0.3;
    }
    return _backGroudView;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"cart_orderlist_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.separatorInset = UIEdgeInsetsMake(0, 0.5, 0, 0);
        _listTableView.separatorColor = [UIColor colorWithHexString:@"0xededed"];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [UIView new];
        UINib *nib = [UINib nibWithNibName:@"SDOderGoodCell" bundle: [NSBundle mainBundle]];
        UINib *nib1 = [UINib nibWithNibName:@"SDLimitSecondKillOrderCell" bundle: [NSBundle mainBundle]];
        [_listTableView registerNib:nib forCellReuseIdentifier:[SDOderGoodCell cellIdentifier]];
        [_listTableView registerNib:nib1 forCellReuseIdentifier:[SDLimitSecondKillOrderCell cellIdentifier]];
    }
    return _listTableView;
}
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _titleLabel.text = @"商品清单";
        _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
    }
    return _titleLabel;
}
- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = [UIColor colorWithHexString:@"0x848487"];
        _totalLabel.text = @"共10件";
        _totalLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    }
    return _totalLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xF5F5F7"];
    }
    return _lineView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIImageView *)closeImageView{
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] init];
        _closeImageView.image = [UIImage imageNamed:@"cart_orderlist_close"];
    }
    return _closeImageView;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn addTarget:self action:@selector(delectGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [_deleteBtn setTitle:@"移除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}
#pragma mark Action
- (void)delectGoodsAction:(UIButton *)btn{
    NSArray *goodArray = [[SDCartDataManager sharedInstance] removeExpressGood];
    [SDCartDataManager getCartOrderViewPriceWith:goodArray  completeBlock:^(id  _Nonnull model) {
        SDCartCalculateModel *cmodel = (SDCartCalculateModel *)model;
        if (cmodel.type == SDValuationTypeNoDelivery) {
            [SDPopView showPopViewWithContent:[NSString stringWithFormat:@"移除商品后，不满足%@元起送价，需要回购物车重新结算!",cmodel.tips.deliveryPrice] noTap:YES confirmBlock:^{
                CYLTabBarController *tab = (CYLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                if (tab.selectedViewController) {
                    UINavigationController *nav = tab.selectedViewController;
                    [nav popToRootViewControllerAnimated:YES];
                }
            } cancelBlock:nil];
            [self removeFromSuperview];
        }else{
            [SDCartDataManager sharedInstance].prepayModel.goods = goodArray;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiCartPrePayReload object:nil];
            [self removeFromSuperview];
        }
    } failedBlock:^(id model){
        [SDToastView HUDWithString:@"移除商品失败"];
    }];
    
}
- (void)closeAction{
    SD_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        SD_StrongSelf
        self.alpha = 0;
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, self.contentView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)show{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(keyWindow);
    }];
    // 指定position属性（移动）
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.25; // 动画持续时间
    animation.repeatCount = 1; // 不重复
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT * 1.4)]; // 起始点
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT * 0.6)]; // 终了点
    [self.contentView.layer addAnimation:animation forKey:@"move-layer"];
}
#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataArray;
    SDGoodModel *model = [array objectAtIndex:indexPath.section];
    if (model.type.integerValue == SDGoodTypeSecondkill && model.beyond.integerValue > 0 && model.beyond.integerValue < model.num.integerValue) {
        SDLimitSecondKillOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDLimitSecondKillOrderCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }else{
        SDOderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDOderGoodCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
