//
//  SDAmoyMyEquityViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAmoyMyEquityViewController.h"
#import "SDMyEquityCell.h"

@interface SDAmoyMyEquityViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) int amoyLevel;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) YYLabel *levelLabel;
/** 我的下线 */
@property (nonatomic, strong) YYLabel *offineLabel;
/** 佣金比例 */
@property (nonatomic, strong) YYLabel *proportionLabel;
/** 总佣金收入 */
@property (nonatomic, strong) YYLabel *incomeLabel;

@end

@implementation SDAmoyMyEquityViewController

static NSString * const CellID = @"SDMyEquityCell";
static CGFloat const bottomH = 50;
static CGFloat const headerViewH = 176 +  55;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initTableView];
    [self initBottomView];
}

- (void)initNav {
    self.navigationItem.title = @"我的权益";
}

- (void)initTableView {
    CGRect frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - bottomH - kTabBarHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableHeaderView = [self setupHeaderView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [tableView registerClass:[SDMyEquityCell class] forCellReuseIdentifier:CellID];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)initBottomView {
    YYLabel *bottomLabel = [[YYLabel alloc] init];
    bottomLabel.text = @"发展新会员";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomH);
        make.bottom.mas_equalTo(0);
    }];
    bottomLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"tap text range:...");
    };
}

- (UIView *)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.height = headerViewH;
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, headerViewH);
    UIImageView *backgroundIv = [[UIImageView alloc] init];
    backgroundIv.image = [UIImage cp_imageByCommonGreenWithFrame:frame];
    [headerView addSubview:backgroundIv];
    [backgroundIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headerView);
    }];
    
    [headerView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
    }];
    
    int count = self.amoyLevel == 2 ? 3 : 2;
    CGFloat labelW = (SCREEN_WIDTH - 15 * 2 - (count - 1) * 1) / count;
    
    if (self.amoyLevel == 2) {
        [headerView addSubview:self.offineLabel];
        [self.offineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.levelLabel.mas_bottom).mas_equalTo(2);
            make.height.mas_equalTo(70);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(labelW);
        }];
    }
    int proportionIndex = self.amoyLevel == 2 ? 1 : 0;
    int incomeIndex = self.amoyLevel == 2 ? 2 : 1;
    [headerView addSubview:self.proportionLabel];
    [self.proportionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.levelLabel.mas_bottom).mas_equalTo(2);
        make.height.mas_equalTo(70);
        make.left.mas_equalTo(@(proportionIndex * labelW + 15));
        make.width.mas_equalTo(labelW);
    }];
   
    [headerView addSubview:self.incomeLabel];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.levelLabel.mas_bottom).mas_equalTo(2);
        make.height.mas_equalTo(70);
        make.left.mas_equalTo(@(incomeIndex * labelW + 15));
        make.width.mas_equalTo(labelW);
    }];
    
    [self setupHeaderBottomView:headerView];
    
    return headerView;
}

- (void)setupHeaderBottomView:(UIView *)headerView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(56);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"我的下线";
    tipsLabel.textColor = [UIColor colorWithRGB:0x131413];
    tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    [bottomView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.left.mas_equalTo(10);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRGB:0xEBEBED];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDMyEquityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

#pragma mark - lazy
- (YYLabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[YYLabel alloc] init];
        _levelLabel.numberOfLines = 2;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"淘客等级\nV1"];
        text.yy_font = [UIFont fontWithName:kSDPFRegularFont size:15];
        text.yy_color = [UIColor whiteColor];
        text.yy_lineSpacing = 10;
        text.yy_alignment = NSTextAlignmentCenter;
        [text yy_setFont:[UIFont systemFontOfSize:30] range:NSMakeRange(5, 2)];
        _levelLabel.attributedText = text;
    }
    return _levelLabel;
}

- (YYLabel *)offineLabel {
    if (!_offineLabel) {
        _offineLabel = [[YYLabel alloc] init];
        _offineLabel.numberOfLines = 2;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"26\n我的下线"];
        text.yy_font = [UIFont fontWithName:kSDPFBoldFont size:14];
        text.yy_color = [UIColor whiteColor];
        text.yy_lineSpacing = 5;
        text.yy_alignment = NSTextAlignmentCenter;
        [text yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:11] range:NSMakeRange(3, 4)];
        _proportionLabel.attributedText = text;
    }
    return _offineLabel;
}

- (YYLabel *)proportionLabel {
    if (!_proportionLabel) {
        _proportionLabel = [[YYLabel alloc] init];
        _proportionLabel.numberOfLines  = 2;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"4%\n佣金比例"];
        text.yy_font = [UIFont fontWithName:kSDPFBoldFont size:14];
        text.yy_color = [UIColor whiteColor];
        text.yy_lineSpacing = 5;
        text.yy_alignment = NSTextAlignmentCenter;
        [text yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:11] range:NSMakeRange(3, 4)];
        _proportionLabel.attributedText = text;
    }
    return _proportionLabel;
}

- (YYLabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[YYLabel alloc] init];
        _incomeLabel.numberOfLines = 2;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"￥352.26%\n总佣金收入"];
        text.yy_font = [UIFont fontWithName:kSDPFBoldFont size:14];
        text.yy_color = [UIColor whiteColor];
        text.yy_lineSpacing = 5;
        text.yy_alignment = NSTextAlignmentCenter;
        [text yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:11] range:NSMakeRange(9, 5)];
        _incomeLabel.attributedText = text;
    }
    return _incomeLabel;
}

@end
