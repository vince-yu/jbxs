//
//  SDPromoteDataView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPromoteDataView.h"
#import "SDBrokerageDataManager.h"
#import "SDJumpManager.h"

@interface SDPromoteDataView ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *tipsLabel;
/** 预计总收入 */
@property (nonatomic, strong) UILabel *totalIncomeLabel;

@property (nonatomic, strong) UIView *horizontalLineView;
@property (nonatomic, strong) UIView *verticalLineView;
/** 拉新 */
@property (nonatomic, strong) UIView *pullNewView;
/** 拉新 label */
@property (nonatomic, strong) YYLabel *pullNewLabel;
/** 佣金 */
@property (nonatomic, strong) UIView *commissionView;
/** 佣金 label */
@property (nonatomic, strong) YYLabel *commissioLabel;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *labelArr;

/** 新增好友数**/
@property (nonatomic ,strong) UIView *friendView;
@property (nonatomic ,strong) UIView *bottomLineView;
@property (nonatomic ,strong) UILabel *friendTitleLabel;
@property (nonatomic ,strong) UILabel *friendLabel;
@end

@implementation SDPromoteDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
        [self initSubView];
    }
    return  self;
}

- (void)initSubView {
    [self addSubview:self.segmentControl];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.totalIncomeLabel];
    [self.contentView addSubview:self.horizontalLineView];
    self.pullNewView = [self setupDetailView:@"拉新"];
    self.commissionView = [self setupDetailView:@"佣金"];
    [self.contentView addSubview:self.pullNewView];
    [self.contentView addSubview:self.commissionView];
    
    [self.contentView addSubview:self.friendView];
    [self.friendView addSubview:self.bottomLineView];
    [self.friendView addSubview:self.friendTitleLabel];
    [self.friendView addSubview:self.friendLabel];

    for (int i = 0; i < self.titleArr.count; i++) {
        YYLabel *label = [[YYLabel alloc] init];
        label.numberOfLines = 2;
        NSString *string = [NSString stringWithFormat:@"3265\n%@", self.titleArr[i]];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        text.yy_color = [UIColor colorWithHexString:kSDSecondaryTextColor];
        text.yy_font = [UIFont fontWithName:kSDPFMediumFont size:11];
        text.yy_alignment = NSTextAlignmentCenter;
        text.yy_lineSpacing = 5;
        [text yy_setColor:[UIColor colorWithHexString:kSDGreenTextColor] range:NSMakeRange(0, 4)];
        [text yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:14] range:NSMakeRange(0, 4)];
        label.attributedText = text;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.shadowColor = [UIColor colorWithRGB:0x075011 alpha:0.07].CGColor;
        label.layer.shadowOffset = CGSizeMake(0,3);
        label.layer.shadowOpacity = 1;
        label.layer.shadowRadius = 9;
        label.layer.cornerRadius = 4;
        label.tag = i;
        [self addSubview:label];
        [self.labelArr addObject:label];
    }
    [self.contentView addSubview:self.verticalLineView];

}

- (UIView *)setupDetailView:(NSString *)name {
    UIView *detailView = [[UIView alloc] init];
    
    YYLabel *amountLabel = [[YYLabel alloc] init];
    if ([name isEqualToString:@"拉新"]) {
        self.pullNewLabel = amountLabel;
    }else {
        self.commissioLabel = amountLabel;
    }
    [detailView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(detailView);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = name;
    nameLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
    [detailView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(amountLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(12);
        make.centerX.mas_equalTo(detailView);
    }];
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setTitle:@"增加收入" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    addButton.layer.masksToBounds = YES;
    addButton.layer.cornerRadius = 25 * 0.5;
    addButton.layer.borderWidth = 0.5;
    addButton.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([name isEqualToString:@"拉新"]) {
        addButton.tag = 101;
    }else {
        addButton.tag = 102;
    }
    [detailView addSubview:addButton];
    [detailView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.centerX.mas_equalTo(detailView);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_equalTo(20);
    }];
    return detailView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(33);
        make.width.mas_equalTo(200);
    }];
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeGrouper || [SDUserModel sharedInstance].role == SDUserRolerTypeTaoke) {
        self.friendView.hidden = NO;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(192 + 55);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.segmentControl.mas_bottom).mas_equalTo(15);
        }];
        [self.friendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.left.right.equalTo(self.friendView);
            
        }];
        [self.friendTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(20);
        }];
        [self.friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(20);
        }];
    }else {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(192);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.segmentControl.mas_bottom).mas_equalTo(15);
        }];
        self.friendView.hidden = YES;
    }
    
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(0.5, 30));
        make.top.mas_equalTo(self.horizontalLineView.mas_bottom).mas_equalTo(30);
    }];
    
    [self.pullNewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.horizontalLineView.mas_bottom);
        make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    [self.commissionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.horizontalLineView.mas_bottom);
        make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
        make.left.mas_equalTo(SCREEN_WIDTH * 0.5);
    }];
//    self.commissionView.hidden = NO;
//    self.verticalLineView.hidden = NO;
    
    
    
}

- (void)setUserData {
    SDBrokerageModel *model = [SDBrokerageDataManager sharedInstance].brokerageModel;
    if (self.segmentControl.selectedSegmentIndex == 0) {
        self.totalIncomeLabel.text = [NSString stringWithFormat:@"￥%@", [model.todayBrokerage priceStr]];
        self.pullNewLabel.attributedText = model.todayBrokerageInviteAttr;
        self.commissioLabel.attributedText = model.todayBrokerageGoodsAttr;
    }else {
        self.totalIncomeLabel.text = [NSString stringWithFormat:@"￥%@", [model.yesterdayBrokerage priceStr]];
        self.pullNewLabel.attributedText = model.yesterdayBrokerageInviteAttr;
        self.commissioLabel.attributedText = model.yesterdayBrokerageGoodsAttr;
    }
    self.friendLabel.text = model.todayFriends;
}

#pragma mark - action
- (void)selected:(UISegmentedControl*)control{
    if (control.selectedSegmentIndex) {
        [SDStaticsManager umEvent:kincome_tab_yesterday];
    }else{
        [SDStaticsManager umEvent:kincome_tab_today];
    }
    [self setUserData];
}

- (void)addBtnClick:(UIButton *)clickBtn {
    if (clickBtn.tag == 101) { // 拉新
        SDWebViewController *vc = [[SDWebViewController alloc] init];
        [vc ba_web_loadURLString:kH5NewUser];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        [SDStaticsManager umEvent:kincome_lx];
    }else {
        if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal) {
            [SDJumpManager jumpUrl:KUserBeGrouperUrl push:YES parentsController:self.viewController animation:YES];
            return;
        }
        [SDStaticsManager umEvent:kincome_increment];
        SD_WeakSelf
        [SDPopView showPopViewWithContent:@"确定去首页分享商品拿佣金吗？" noTap:NO confirmBlock:^{
            SD_StrongSelf;
            [self.viewController.navigationController.navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabVc.selectedIndex = 0;
        } cancelBlock:^{
            
        }];
    }
}

#pragma mark - lazy
- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"今日", @"昨日"]];
        _segmentControl.tintColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _segmentControl.selectedSegmentIndex = 0;
        NSDictionary *selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:kSDPFMediumFont size:14], NSForegroundColorAttributeName: [UIColor whiteColor]};
        NSDictionary *normalTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:kSDPFMediumFont size:14], NSForegroundColorAttributeName: [UIColor colorWithHexString:kSDGreenTextColor]};
        [_segmentControl setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
        [_segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"预计总收入";
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _tipsLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
    return _tipsLabel;
}

- (UILabel *)totalIncomeLabel {
    if (!_totalIncomeLabel) {
        _totalIncomeLabel = [[UILabel alloc] init];
        _totalIncomeLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _totalIncomeLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
    return _totalIncomeLabel;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"拉新", @"佣金"];
    }
    return _titleArr;
}

- (NSMutableArray *)labelArr {
    if (!_labelArr) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)horizontalLineView {
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] init];
        _horizontalLineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _horizontalLineView;
}

- (UIView *)verticalLineView {
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    }
    return _verticalLineView;
}
- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"0xEBEBED"];
    }
    return _bottomLineView;
}
- (UILabel *)friendTitleLabel{
    if (!_friendTitleLabel) {
        _friendTitleLabel = [[UILabel alloc] init];
        _friendTitleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
        _friendTitleLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _friendTitleLabel.text = @"新增好友数";
    }
    return _friendTitleLabel;
}
- (UILabel *)friendLabel{
    if (!_friendLabel) {
        _friendLabel = [[UILabel alloc] init];
        _friendLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
        _friendLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _friendLabel.text = @"0";
        _friendLabel.textAlignment = NSTextAlignmentRight;
    }
    return _friendLabel;
}
- (UIView *)friendView{
    if (!_friendView) {
        _friendView = [[UIView alloc] init];
        _friendView.backgroundColor = [UIColor clearColor];
    }
    return _friendView;
}
@end
