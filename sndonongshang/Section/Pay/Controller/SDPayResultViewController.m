//
//  SDPayResultViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPayResultViewController.h"
#import "SDCartDataManager.h"
#import "SDOrderDetailViewController.h"
#import "SDPayViewController.h"

@interface SDPayResultViewController ()
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *resultLabel;
@property (nonatomic ,strong) UILabel *describeLabel;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,assign) SDPayResultType type;
@end

@implementation SDPayResultViewController
- (instancetype)initWithType:(SDPayResultType )type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
    [self delPayVC];
    [self reloadViewWith:self.type];
}

- (void)reloadViewWith:(SDPayResultType )type{
    switch (type) {
        case SDPayResultTypeSuccess:
        {
            self.imageView.image = [UIImage imageNamed:@"pay_successe"];
            self.resultLabel.text = @"订单支付成功";
            self.resultLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
            self.describeLabel.text = [NSString stringWithFormat:@"实付: ￥%@", [self.orderModel.amount priceStr]];;
            [self.leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"回到首页" forState:UIControlStateNormal];
        }
            break;
        case SDPayResultTypeFailed:
        {
            self.imageView.image = [UIImage imageNamed:@"pay_failed"];
            self.resultLabel.text = @"订单支付失败";
            self.resultLabel.textColor = [UIColor colorWithHexString:@"0xF8665A"];
            self.describeLabel.text = [NSString stringWithFormat:@"实付: ￥%@", [self.orderModel.amount priceStr]];
            [self.rightBtn setTitle:@"查看订单" forState:UIControlStateNormal];
            [self.leftBtn setTitle:@"重新支付" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)delPayVC {
    if (self.type == SDPayResultTypeSuccess) {
        [self delPayVCFromNav];
    }
}

/** 从导航控制器中删除支付页面 */
- (void)delPayVCFromNav {
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[SDPayViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}

- (void)initSubView{
    self.navigationItem.title = @"支付";
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:self.describeLabel];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(kTopHeight + 61);
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.imageView);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(14);
        make.centerX.equalTo(self.imageView);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(38);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(52);
        make.centerX.equalTo(self.view).multipliedBy(0.5);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(38);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(52);
        make.centerX.equalTo(self.view).multipliedBy(1.5);
    }];
    
}
#pragma mark init
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView  = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UILabel *)resultLabel{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = [UIFont fontWithName:kSDPFBoldFont size:19];
        _resultLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
    return _resultLabel;
}
- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.font = [UIFont fontWithName:kSDPFBoldFont size:15];
        _describeLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
    }
    return _describeLabel;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.layer.cornerRadius = 19;
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:16];
        _leftBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.layer.cornerRadius = 19;
        [_rightBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _rightBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        _rightBtn.layer.borderWidth = 1.0;
    }
    return _rightBtn;
}
#pragma mark action
- (void)leftAction{
    if (self.type == SDPayResultTypeSuccess) { // 查看订单
        [SDStaticsManager umEvent:kpay_result_detail];
        [self goOrderDetail];
    }else { // 重新支付
        [SDStaticsManager umEvent:kpay_result_reorder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)rightAction{
    if (self.type == SDPayResultTypeSuccess) { // 回到首页
        [SDStaticsManager umEvent:kpay_result_tohome];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else { // 查看订单
        [SDStaticsManager umEvent:kpay_result_detail];
        [self goOrderDetail];
    }
}

/** 跳转到订单详情 */
- (void)goOrderDetail {
    SDOrderDetailViewController *vc = [[SDOrderDetailViewController alloc] init];
    vc.orderId = self.orderModel.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
