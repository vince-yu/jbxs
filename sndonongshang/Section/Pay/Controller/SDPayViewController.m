//
//  SDPayViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDPayViewController.h"
#import "SDPayMethodCell.h"
#import "SDPayResultViewController.h"
#import "SDPayRequest.h"
#import "SDPayManager.h"
#import "SDCheckOrderStatusRequest.h"
#import "SDCartOrderViewController.h"

@interface SDPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIButton *submitBtn;
@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic ,assign) NSInteger selectRow;
@end

@implementation SDPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDefaultData];
    [self initSubViews];
    [self AddObserver];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSubViews{
    self.navigationItem.title = @"选择支付方式";
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF7F7F7"];
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.submitBtn];
    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.submitBtn.mas_top);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo( - 20 - kBottomSafeHeight);
        make.height.mas_equalTo(45);
    }];
}

/** 初始化默认数据 */
- (void)setupDefaultData {
    // 默认微信支付
    self.selectRow = 1;
    NSString *submitStr = [NSString stringWithFormat:@"微信支付￥%@", [self.orderModel.amount priceStr]];
    [self.submitBtn setTitle:submitStr forState:UIControlStateNormal];
    
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[SDCartOrderViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}

- (void)AddObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResult:) name:KNotifiWechatPayResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResult:) name:KNotifiAlipayResult object:nil];
}

#pragma mark action
- (void)submitAction{
    [self goPay];
}

- (void)weChatPayResult:(NSNotification *)notifi {
    if (self.navigationController.topViewController != self) {
        SNDOLOG(@"微信 不是正在显示的页面");
        return;
    }
    int errCode = [notifi.userInfo[@"errCode"] intValue];
    SDPayResultType type = SDPayResultTypeFailed;
    if (errCode == 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        type = SDPayResultTypeSuccess;
    }else{
        [SDStaticsManager umEvent:kpay_wx_fail];
    }
    [self goPayResult:type];
}

//    9000    订单支付成功
//    8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//    4000    订单支付失败
//    5000    重复请求
//    6001    用户中途取消
//    6002    网络连接出错
//    6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//    其它    其它支付错误
- (void)alipayResult:(NSNotification *)notifi {
    if (self.navigationController.topViewController != self) {
        SNDOLOG(@"支付宝 不是正在显示的页面");
        return;
    }
    SNDOLOG(@"alipayResult %@", notifi.userInfo);
    int resultStatus = [notifi.userInfo[@"resultStatus"] intValue];
    SDPayResultType type = SDPayResultTypeFailed;
    if (resultStatus == 9000) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        type = SDPayResultTypeSuccess;
    }else if (resultStatus == 8000 || resultStatus == 6004) {
        [self checkOrderStatus];
        return;
    }else if (resultStatus == 4000){
        [SDStaticsManager umEvent:kpay_zfb_fail];
    }else if (resultStatus == 6001){
        [SDStaticsManager umEvent:kpay_zfb_cancel];
    }
    [self goPayResult:type];
}

- (void)goPayResult:(SDPayResultType)type {
    SDPayResultViewController *vc = [[SDPayResultViewController alloc] initWithType:type];
    vc.orderModel = self.orderModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark init
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
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UINib *nib1 = [UINib nibWithNibName:@"SDPayMethodCell" bundle: [NSBundle mainBundle]];
        [_contentTableView registerNib:nib1 forCellReuseIdentifier:[SDPayMethodCell cellIdentifier]];
    }
    return _contentTableView;
}
#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDPayMethodCell *cell = nil;

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
    
    
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectRow) {
        return;
    }
    if (indexPath.row) {
        [SDStaticsManager umEvent:kpay_wx];
    }else{
        [SDStaticsManager umEvent:kpay_zfb];
    }
    self.selectRow = indexPath.row;
    NSString *payMethod = self.selectRow == 0 ? @"支付宝支付" : @"微信支付";
    NSString *submitStr = [NSString stringWithFormat:@"%@￥%@", payMethod, [self.orderModel.amount priceStr]];
    [self.submitBtn setTitle:submitStr forState:UIControlStateNormal];
    [self.contentTableView reloadData];
}

#pragma mark - network
/** 发起支付 */
- (void)goPay {
    if (!self.orderModel) return;
    SDPayRequest *request = [[SDPayRequest alloc] init];
    request.orderId = self.orderModel.orderId;
    request.payMethod = self.selectRow == 0 ? SDPayMethodAliPay : SDPayMethodWechat;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDPayRequest * _Nonnull request) {
        if (request.payMethod == SDPayMethodAliPay) {
            [[SDPayManager sharedInstance] alipayPayWithOrderStr:request.alipayOrderInfo];
        }else if (request.payMethod == SDPayMethodWechat) {
            [[SDPayManager sharedInstance] wechatPayWithModel:request.wechatPayModel];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
}

- (void)checkOrderStatus {
    if (self.navigationController.topViewController != self) {
        return;
    }
     if (!self.orderModel) return;
    SDCheckOrderStatusRequest *request = [[SDCheckOrderStatusRequest alloc] init];
    request.orderId = self.orderModel.orderId;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCheckOrderStatusRequest * _Nonnull request) {
        SDPayResultType type = SDPayResultTypeFailed;
        if (request.isPayed) {
             SNDOLOG(@"支付成功");
            type = SDPayResultTypeSuccess;
            [self goPayResult:type];
        }else {
            SNDOLOG(@"未支付");
            [SDToastView HUDWithString:@"未支付"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

        SNDOLOG(@"支付失败");
    }];
}

@end
