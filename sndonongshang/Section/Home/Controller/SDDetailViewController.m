//
//  SDDetailViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDetailViewController.h"
#import "SDLoginViewController.h"
#import "SDCartOderRequest.h"
#import "SDCartDataManager.h"
#import "SDCartOrderViewController.h"
#import "SDShareManager.h"
#import "SDHomeDataManager.h"
#import "SDCartCalculateRequest.h"

@interface SDDetailViewController ()
@property (nonatomic ,strong) UIView *shareTipView;
@property (nonatomic ,strong) UIImageView *tipImageView;
@property (nonatomic ,strong) UILabel *tipLabel;
@property (nonatomic ,strong) UIImageView *shareImageView;
@property (nonatomic, strong) SDCartCalculateModel *moreModel;
@end

@implementation SDDetailViewController
@synthesize shareBtn = _shareBtn;
@synthesize barView = _barView;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barView.hidden = YES;
    if ([SDAppManager sharedInstance].status) {
        self.navigationItem.rightBarButtonItem = self.shareBtn;
    }
    [self goodPricecalculate];
//    BOOL share = [[[NSUserDefaults standardUserDefaults] objectForKey:kGoodDetailShowShareTip] boolValue];
////    share = 0;
//    if (!share && [SDAppManager sharedInstance].status) {
//        [self showShareTipsView];
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGoodDetailShowShareTip];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuceess) name:KNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appVerifySuccess) name:kNotifiAPPVerifySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWithGoodId:) name:kNotifiRefreshGoodDetailVC object:nil];
}

- (void)dealloc
{
    [SDHomeDataManager sharedInstance].detailModel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiAPPVerifySuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshGoodDetailVC object:nil];
}
- (void)appVerifySuccess{
    self.navigationItem.rightBarButtonItem = self.shareBtn;
}
- (void)refreshWithGoodId:(NSNotification *)note{
    NSString *goodId = [note object];
    if ([goodId isEqualToString:self.goodModel.goodId]) {
        [self.tableView refreshActionWithHiddenToast:NO];
    }
}
- (void)loginSuceess{
    [self.tableView refreshAction];
}
- (void)goodPricecalculate{
    SD_WeakSelf
    self.tableView.CartCalculateBlock = ^(SDGoodDetailModel * _Nonnull detailModel) {
        SD_StrongSelf;
        if (!detailModel || detailModel.status.integerValue != SDCartListCellTypeNomal || [detailModel.goodId isEmpty]) {
            return;
        }
        NSMutableArray *array = [[NSMutableArray alloc] init];
        SDCartCalculateRequestModel *updateModel = [[SDCartCalculateRequestModel alloc] init];
        updateModel.goodId = detailModel.goodId;
        updateModel.type = detailModel.type;
        updateModel.targetNum = @"1";
        [array addObject:[updateModel mj_keyValues]];
        SD_WeakSelf
        [SDCartDataManager getAddViewSelectGoodsPriceWith:[array mj_JSONString] completeBlock:^(id  _Nonnull model) {
            if (![model isKindOfClass:[SDCartCalculateModel class]]) {
                return;
            }
            SD_StrongSelf;
            self.moreModel = model;
//            [self updateDetailModelData:model];
            
        } failedBlock:^(id model){
           
        }];
    };
}

/** 更新活动价和原价 */
- (void)updateDetailModelData:(SDCartCalculateModel *)moreModel {
    SDGoodDetailModel *detailModel = self.tableView.detailModel;
    if (!detailModel || moreModel.more.count == 0) {
        return;
    }
    SDCartCalculateMoreModel *calculateModel = moreModel.more.firstObject;
    if (![detailModel.goodId isEqualToString:calculateModel.goodsId]) {
        return;
    }
    if (detailModel.price != calculateModel.price || detailModel.priceActive != calculateModel.priceActive) {
        [self.tableView refreshActionWithHiddenToast:YES];
    }
}

#pragma mark 第一次分享蒙层
- (void)showShareTipsView{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.shareTipView];
    [self.shareTipView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(window);
    }];
    self.shareTipView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.shareTipView.alpha = 1.0;
    }completion:^(BOOL finished) {
        self.shareTipView.alpha = 1.0;
    }];
   
}
- (UIView *)shareTipView{
    if (!_shareTipView) {
        _shareTipView = [[UIView alloc] init];
        _shareTipView.backgroundColor = [UIColor clearColor];
        _shareTipView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissShareTipsView)];
        [_shareTipView addGestureRecognizer:tap];
        
        [_shareTipView addSubview:self.tipImageView];
        [_tipImageView addSubview:self.tipLabel];
        
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40 + self.tipLabel.width);
            make.height.mas_equalTo(20 + self.tipLabel.height);
            make.top.mas_equalTo(kTopHeight);
            make.right.mas_equalTo(-30);
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.tipLabel.width);
            make.height.mas_equalTo(self.tipLabel.height);
            make.centerX.equalTo(self.tipImageView.mas_centerX);
            make.centerY.equalTo(self.tipImageView.mas_centerY).offset(1);
        }];
    }
    return _shareTipView;
}
- (UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"good_detail_shareTipBg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3.5, 20, 0, 30) resizingMode:UIImageResizingModeStretch];
        _tipImageView.image = image;
    }
    return _tipImageView;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"点击分享，开始赚钱";
        _tipLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        [_tipLabel sizeToFit];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}
- (void)dissmissShareTipsView{
    [UIView animateWithDuration:0.5 animations:^{
        self.shareTipView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.shareTipView removeFromSuperview];
        self.shareTipView.alpha = 1;
    }];
    
}
- (UIBarButtonItem *)shareBtn{
    if (!_shareBtn) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0, 0, 43, 41);
        UIImage *image = [[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [rightButton setImage:image forState:UIControlStateNormal];
        //        rightButton.autoresizesSubviews = YES;
        //        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //        rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _shareBtn;
}
- (void)shareAction{
    [SDStaticsManager umEvent:kdetail_share attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type}];
//    if (![SDUserModel sharedInstance].isLogin) {
//        [SDLoginViewController present];
//        return;
//    }
    SDGoodDetailModel *detailModel = self.tableView.detailModel;
    [SDHomeDataManager sharedInstance].detailModel = detailModel;
    SDGoodShareInfo *share = detailModel.shareInfo[@"wx"];
    if (!share) {
        return;
    }
    if (!self.shareImageView) {
        self.shareImageView = [[UIImageView alloc] init];
    }
    UIImageView *thumbImageView = [[UIImageView alloc] init];
    [thumbImageView sd_setImageWithURL:[NSURL URLWithString:self.goodModel.miniPic]];
    UIImage *thumbImage = thumbImageView.image;
    if (!thumbImage) {
        thumbImage = [UIImage imageNamed:@"mine_logo"];
    }
    SD_WeakSelf;
    [SDToastView show];
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:share.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//        [SDToastView dismiss];
//        SD_StrongSelf;
//        [SDShareManager shareWebPageWithUMUIToPlatformType:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine title:share.title descr:share.content thumbImage:thumbImage hdImage:data webpageUrl:share.url programId:share.miniProgmId programPath:share.miniProgmPath viewDescr:[NSString getShareStr:detailModel.brokerage rate:detailModel.rebateRate] withShareResultBlock:^(id data, NSError *error) {
//
//        }type:SDShareTypeGoodDetailView goodModel:self.goodModel];
//    }];
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:share.img] placeholderImage:[UIImage imageNamed:@"list"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [SDToastView dismiss];
        SD_StrongSelf;
        [SDShareManager shareWebPageWithUMUIToPlatformType:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine title:share.title descr:share.content thumbImage:thumbImage hdImage:image webpageUrl:share.url programId:share.miniProgmId programPath:share.miniProgmPath viewDescr:[NSString getShareStr:detailModel.brokerage rate:detailModel.rebateRate] withShareResultBlock:^(id data, NSError *error) {
            
        }type:SDShareTypeGoodDetailView goodModel:self.goodModel];
    }];
    
}
#pragma mark 立即购买与立即参团弹窗
- (void)showBuyView{
    [SDStaticsManager umEvent:kdetail_buy attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type}];
    if (![SDUserModel sharedInstance].isLogin) {
        [SDLoginViewController present];
        return;
    }
    _buyView = [[[NSBundle mainBundle] loadNibNamed:@"SDSystemAddView" owner:nil options:nil] objectAtIndex:0];
    if (self.moreModel) {
        _buyView.moreModel = self.moreModel;
    }
    _buyView.detailModel = self.tableView.detailModel;
    [self.view addSubview:_buyView];
//    [_buyView showAnimation];
    SD_WeakSelf;
    _buyView.pushToOderBlock = ^(NSUInteger num) {
        SD_StrongSelf;
        [self prePayAction:num];
    };
    
    _buyView.updateDetailModelBlock = ^(SDCartCalculateModel * _Nonnull moreModel) {
        SD_StrongSelf;
        if (!moreModel) {
            return;
        }
        [self updateDetailModelData:moreModel];
    };
    [_buyView getGoodCalculateData];
    [_buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
}
- (void)prePayAction:(NSInteger )num{
   [self nomalPrePayAction:num];
}
- (void)nomalPrePayAction:(NSUInteger )num{
    [SDStaticsManager umEvent:kdetail_goods_num attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type,@"num":[NSString stringWithFormat:@"%lu",(unsigned long)num]}];
    if ([SDUserModel sharedInstance].isLogin) {
        SDCartOderRequestModel *payModel = [[SDCartOderRequestModel alloc] init];
        SDGoodModel *good = [SDGoodModel mj_objectWithKeyValues:[self.goodModel mj_keyValues]];
        good.num = [NSString stringWithFormat:@"%lu",(unsigned long)num];
        payModel.goods = [NSArray arrayWithObject:good];
        payModel.isPrepay = @"1";
        [SDCartDataManager sharedInstance].prepayModel = payModel;
        SD_WeakSelf;
        [SDCartDataManager cartToOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel completeBlock: ^(id model){
            SD_StrongSelf;
            SDCartOrderViewController *vc = [[SDCartOrderViewController alloc] init];
            vc.orderModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        } failedBlock:^(id model){
            SD_StrongSelf;
            [SDCartDataManager handelGoodDetailRequestFailed:model listTableView:self.tableView];
        }];
    }else{
        [SDLoginViewController present];
    }
}
- (void)groupPrePayAction:(NSUInteger )num{
    [SDStaticsManager umEvent:kdetail_goods_num attr:@{@"_id":self.goodModel.goodId,@"name":self.goodModel.name,@"type":self.goodModel.type,@"num":[NSString stringWithFormat:@"%lu",(unsigned long)num]}];
    if ([SDUserModel sharedInstance].isLogin) {
        SDCartOderRequestModel *payModel = [[SDCartOderRequestModel alloc] init];
        payModel.goodId = self.tableView.detailModel.goodId;
        payModel.groupId = self.tableView.detailModel.groupId;
        payModel.isPrepay = @"1";
        payModel.type = SDCartOrderTypeSelfTakeOnly;
        payModel.num = [NSString stringWithFormat:@"%lu",(unsigned long)num];
        [SDCartDataManager sharedInstance].prepayModel = payModel;
        SD_WeakSelf;
        [SDCartDataManager systemGroupCartToOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel completeBlock: ^(id model){
            SD_StrongSelf;
            SDCartOrderViewController *vc = [[SDCartOrderViewController alloc] init];
            vc.orderModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        } failedBlock:^(id model){
        }];
    }else{
        [SDLoginViewController present];
    }
}
#pragma mark 添加购物车事件
- (void)addGoodToCart{
//    [SDToastView show];
    [SDCartDataManager addCartGood:self.goodModel needSelectGood:YES completeBlock:^(id  _Nonnull model) {
        [SDToastView HUDWithString:@"添加购物车成功！"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartListTableView object:nil];
    } failedBlock:^(id model){
        if ([model isKindOfClass:[SDBSRequest class]]) {
//            SDBSRequest *bsre = (SDBSRequest *)model;
//            if (bsre.code == 201) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshGoodDetailVC object:self.tableView.detailModel.goodId];
//            }
        }
        
    }];
}
#pragma mark 回到购物车事件
- (void)pushToCartVCAction{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
#pragma 底部导航栏
- (void)remindAction{
    if (![SDUserModel sharedInstance].isLogin) {
        [SDLoginViewController present];
        return;
    }
    SD_WeakSelf;
    NSString *staus = [NSString stringWithFormat:@"%d",!self.isRemind.boolValue];
    if (self.tableView.detailModel.sold.boolValue) {
        staus = [NSString stringWithFormat:@"%d",!self.tableView.detailModel.soldOut];
    }
    [SDHomeDataManager  remindWith:self.tableView.detailModel.goodId type:self.tableView.detailModel.type  status:[NSString stringWithFormat:@"%d",!self.isRemind.boolValue] goodRemind:self.tableView.detailModel.sold.boolValue completeBlock:^(id  _Nonnull mdoel) {
        SD_StrongSelf;
        [SDToastView HUDWithSuccessString:@"操作成功！"];
        [self updateBarView:[NSString stringWithFormat:@"%d",!self.isRemind.boolValue] begin:self.isBegin.boolValue];
    } failedBlock:^(id model){
        [SDToastView HUDWithSuccessString:@"操作失败！"];
//        self
    }];
}
- (void)updateBarView:(NSString *)status begin:(BOOL )isBegin{
    self.isBegin = [NSString stringWithFormat:@"%d",isBegin];
    self.isRemind = status;
    
    if (self.tableView.detailModel.soldOut) {
        if (self.tableView.detailModel.type.integerValue == SDGoodTypeGroup) {
            self.barView.type = SDGoodBarStyleArrivalReminder;
        }else{
            self.barView.type = SDGoodBarStyleArrivalReminder;
        }
        if (!status.boolValue) {
            [self.barView setRemindStr:@"到货提醒"];
            self.tableView.detailModel.goodsremind = @"0";
        }else{
            self.tableView.detailModel.goodsremind = @"1";
            [self.barView setRemindStr:@"取消提醒"];
        }
        return;
    };
    
    if (self.tableView.detailModel.type.integerValue == SDGoodTypeNamoal || self.tableView.detailModel.type.integerValue == SDGoodTypeDiscount) {
        self.barView.type = SDGoodBarStyleBuyAndCart;
        return;
    }
    
    if (isBegin) {
        if (self.tableView.detailModel.type.integerValue == SDGoodTypeSecondkill) {
            self.barView.type = SDGoodBarStyleSeconedKill;
        }else{
            self.barView.type = SDGoodBarStyleGroupBuy;
        }
        
    }else{
        if (self.tableView.detailModel.type.integerValue == SDGoodTypeSecondkill) {
            self.barView.type = SDGoodBarStyleRemind;
        }else{
            self.barView.type = SDGoodBarStyleGroupBuyRemind;
        }
//        self.barView.type = SDGoodBarStyleRemind;
        if (status.boolValue) {
            [self.barView setRemindStr:@"取消提醒"];
        }else{
            [self.barView setRemindStr:@"提醒我"];
        }
    }
}
@end
