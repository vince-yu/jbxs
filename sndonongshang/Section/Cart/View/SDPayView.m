//
//  SDPayView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPayView.h"
#import "SDPayMethodCell.h"
#import "SDPaySureCell.h"


@interface SDPayView ()
@property (nonatomic ,strong) UIView *backGroudView;
@property (nonatomic ,strong) SDPayContentView *contentView;
@end

@implementation SDPayView

- (instancetype)initWithFrame:(CGRect)frame payAction:(SDPayBlock )block backAction:(nonnull SDBackPayBlock)backBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.payBlock = block;
        self.contentView.backBlock = backBlock;
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
        make.height.mas_equalTo(300);
        make.left.right.bottom.equalTo(self);
    }];
    
    
    
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(window);
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
        _backGroudView.alpha = 0.7;
    }
    return _backGroudView;
}
- (SDPayContentView *)contentView{
    if (!_contentView) {
        _contentView = [[SDPayContentView alloc] initWithFrame:CGRectZero type:SDPayTitleStyleMethod];
    }
    return _contentView;
}


@end
@interface SDPayTitleView  ()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic ,assign) SDPayTitleStyle type;
@end
@implementation SDPayTitleView
- (instancetype)initWithFrame:(CGRect)frame type:(SDPayTitleStyle )type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.backBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.left.mas_equalTo(23);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(49);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(20);
    }];
//    if (self.type == SDPayTitleStyleMethod) {
        self.backBtn.hidden = NO;
        self.closeBtn.hidden = YES;
//    }else{
//        self.backBtn.hidden = YES;
//        self.closeBtn.hidden = NO;
//    }
}
#pragma mark init
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    return _closeBtn;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
        _titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
        _titleLabel.text = @"选择支付方式";
    }
    return _titleLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xF1F1F1"];
    }
    return _lineView;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

@end
@interface SDPayContentView  () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) SDPayTitleView *titleView;
@property (nonatomic ,strong) UIButton *submitBtn;
@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic ,assign) SDPayTitleStyle type;
@property (nonatomic ,assign) NSInteger selectRow;
@end
@implementation SDPayContentView
- (instancetype)initWithFrame:(CGRect)frame type:(SDPayTitleStyle )type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initSubView];
        self.selectRow = -1;
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.titleView];
    [self addSubview:self.contentTableView];
    [self addSubview:self.submitBtn];
    [self.titleView.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_offset(57);
    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-22);
        make.height.mas_equalTo(45);
    }];
}
- (void)backAction{
    if (self.backBlock) {
        self.backBlock();
        if (self.superview) {
            [self.superview removeFromSuperview];
        }
    }
}
- (void)closeAction{
    
}
- (void)submitAction{
    if (self.payBlock) {
        self.payBlock();
    }
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.layer.cornerRadius = 22.5;
        [_submitBtn setBackgroundColor:[UIColor colorWithHexString:kSDGreenTextColor]];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
    }
    return _submitBtn;
}
- (SDPayTitleView *)titleView{
    if (!_titleView) {
        if (self.type == SDPayTitleStyleMethod) {
            _titleView = [[SDPayTitleView alloc] initWithFrame:CGRectZero type:SDPayTitleStyleMethod];
        }else{
            _titleView = [[SDPayTitleView alloc] initWithFrame:CGRectZero type:SDPayTitleStyleSurePay];
        }
        
        _titleView.backgroundColor = [UIColor colorWithHexString:@"0xF1F1F1"];
    }
    return _titleView;
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"SDPaySureCell" bundle: [NSBundle mainBundle]];
        [_contentTableView registerNib:nib forCellReuseIdentifier:[SDPaySureCell cellIdentifier]];
        UINib *nib1 = [UINib nibWithNibName:@"SDPayMethodCell" bundle: [NSBundle mainBundle]];
        [_contentTableView registerNib:nib1 forCellReuseIdentifier:[SDPayMethodCell cellIdentifier]];
    }
    return _contentTableView;
}
#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.type == SDPayTitleStyleMethod) {
        cell = [tableView dequeueReusableCellWithIdentifier:[SDPayMethodCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SDPayMethodCell *payCell = (SDPayMethodCell *)cell;
        if (indexPath.row == 0) {
            [payCell setTitile:@"支付宝支付" icon:@"cart_pay_alipay"];
        }else{
            [payCell setTitile:@"微信支付" icon:@"cart_pay_wxpay"];
        }
        if (self.selectRow == indexPath.row) {
            [payCell selectMethod:YES];
        }else{
            [payCell selectMethod:NO];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:[SDPaySureCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == SDPayTitleStyleMethod) {
        return 2;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectRow) {
        return;
    }
    self.selectRow = indexPath.row;
    [self.contentTableView reloadData];
}
@end

