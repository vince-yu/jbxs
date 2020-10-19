//
//  SDHomeViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeViewController.h"
#import "SDHomeTableView.h"
#import "SDSearchViewController.h"
#import "SDGoodDetailViewController.h"
#import "SDGoodsListViewController.h"
#import "SDHomeSearchView.h"
#import "SDSystemDetailViewController.h"
#import "LocationManager.h"
#import "SDHomeDataManager.h"
#import "SDCartDataManager.h"
#import "SDHomePopView.h"
#import "SDSecondKillViewController.h"
#import "SDDisCountViewController.h"
#import "SDCoordinateModel.h"

@interface SDHomeViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIView *homeHeadeView;
@property (nonatomic ,strong) SDHomeSearchView *searView;
@property (nonatomic ,strong) SDHomeTableView *contentTableView;
@property (nonatomic ,strong) UITextField *searchText;
@property (nonatomic, strong) LocationManager *locationMgr;
/** 是否从新人优惠券弹窗跳转到登录页面 */
@property (nonatomic, assign) BOOL popViewJumpLogin;


@end

@implementation SDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self beginLocation];
    [self getUserInfo];
    [self initSubViews];

    [self.contentTableView refreshAction];
    [SDHomeDataManager sharedInstance].home = self;
    [self updateCartBage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBageCount) name:kNotifiRefreshCartGoodCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginoutSuccess) name:kNotifiLogoutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuceess:) name:KNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roleChange) name:kNotifiChangeRoler object:nil];
    [self getHomeCouponsData];
}
- (void)roleChange{
     [self.contentTableView refreshAction];
}
- (void)loginoutSuccess{
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:kAppLogined] boolValue];
    if (!hasLogin) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kAppLogined];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [SDCartDataManager clearCartListCache];
    [self updateBageCount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartListTableView object:nil];
    [self.contentTableView reloadData];
}
- (void)loginSuceess:(NSNotification *)note{
    if (self.popViewJumpLogin && [note.object boolValue]) {
        [SDToastView showHUDWithView:self.view withTitle:@"新人优惠券已经发放到你的优惠券中"];
    }
    [SDCartDataManager synchronizationCartListCompleteBlock:^(id  _Nonnull model) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartListTableView object:nil];
    } failedBlock:^(id model){
    }];
    [self.contentTableView refreshAction];
}

- (void)getHomeCouponsData {
    BOOL isShowPopView = [[NSUserDefaults standardUserDefaults] boolForKey:KHomePopViewShow];
    if (isShowPopView) {
        return;
    }
    SD_WeakSelf
    [SDHomeDataManager getHomeCouponsDataWithCompleteBlock:^(NSString *alertStr) {
        if ( [SDHomeDataManager sharedInstance].couponsArray.count > 0) {
            [SDStaticsManager umEvent:kfresher_dialog];
            [SDHomePopView popViewWithCoupons:[SDHomeDataManager sharedInstance].couponsArray block:^{
                SD_StrongSelf
                self.popViewJumpLogin = YES;
            }];
        }
    }];

}

- (void)updateCartBage{
    SD_WeakSelf;
    [SDCartDataManager refreshCartListCompleteBlock:^(id  _Nonnull model) {
        SD_StrongSelf;
        
        [self updateBageCount];
        
        
    } failedBlock:^(id model){
        
    }hideHud:YES];
}
- (void)updateBageCount{
    NSInteger count = [SDCartDataManager getAllCartGoodsCount];
    if (count) {
        if (count > 99) {
            self.tabBarController.viewControllers[1].tabBarItem .badgeValue = [NSString stringWithFormat:@"%d+",99];
        }else{
            self.tabBarController.viewControllers[1].tabBarItem .badgeValue = [NSString stringWithFormat:@"%ld",count];
        }
        
        
    }else{
        self.tabBarController.viewControllers[1].tabBarItem.badgeValue = nil;
    }
}
- (void)beginLocation {
    self.locationMgr = [LocationManager locationAndCompletionBlock:^(CLLocation * _Nonnull location, AMapLocationReGeocode * _Nonnull regeocode, NSError * _Nonnull error) {
        SNDOLOG(@"定位经纬度 %@", [NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
        [SDCoordinateModel sharedInstance].coordinate = location.coordinate;
    }];
    [self.locationMgr locAction];
}

- (void)getUserInfo {
    if ([[SDUserModel sharedInstance] isLogin]) {
        [SDHomeDataManager getUserInfo];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiRefreshCartGoodCount object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiLogoutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifiChangeRoler object:nil];
}
- (void)initSubViews{
    
    self.navigationItem.title = @"九本鲜生";
    
    //一期取消商品搜索功能
    
//    [self.view addSubview:self.homeHeadeView];
    [self.view addSubview:self.contentTableView];
//    [self.homeHeadeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(@0);
//        make.height.mas_equalTo(108 + SDLiuHanTopHeight);
//    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.top.mas_equalTo(kTopHeight);
    }];
    
//    [self.homeHeadeView addSubview:self.searView];
//
//
//    [self.searView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.homeHeadeView.mas_bottom).offset(-7);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.height.mas_equalTo(30);
//    }];
    
}
#pragma mark init views
- (UIView *)homeHeadeView{
    if (!_homeHeadeView) {
        _homeHeadeView = [[UIView alloc] init];
    }
    return _homeHeadeView;
}
- (SDHomeSearchView *)searView{
    if (!_searView) {
        _searView = [[[NSBundle mainBundle] loadNibNamed:@"SDHomeSearchView" owner:nil options:nil] objectAtIndex:0];
        _searView.textFied.delegate = self;
        _searView.layer.cornerRadius = 15;
    }
    return _searView;
}
- (SDHomeTableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[SDHomeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_contentTableView addMJRefresh];
        SD_WeakSelf;
        _contentTableView.goodDetailBlock = ^(SDGoodModel *model){
            SD_StrongSelf;
            [self pushToGoodDetailVC:model];
        };
        _contentTableView.goodsListBlock = ^(NSString *str){
            SD_StrongSelf;
            [self pushToGoodsListVC:str];
        };
    }
    return _contentTableView;
}
#pragma mark Actions
- (void)pushToGoodDetailVC:(SDGoodModel *)goodModel{
//    goodModel.type = @"3";
    if (goodModel.type.integerValue == SDGoodTypeNamoal) {
        SDGoodDetailViewController *detailVC = [[SDGoodDetailViewController alloc] init];
        detailVC.goodModel = goodModel;
        [self.navigationController pushViewController:detailVC animated:YES];
//        SDDisCountViewController *vc = [[SDDisCountViewController alloc] init];
//        vc.goodModel = goodModel;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeSecondkill){
        SDSecondKillViewController *vc = [[SDSecondKillViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeDiscount){
        SDDisCountViewController *vc = [[SDDisCountViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SDSystemDetailViewController *vc = [[SDSystemDetailViewController alloc] init];
        vc.goodModel = goodModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
    
}
- (void)pushToGoodsListVC:(NSString *)tabId{
    SDGoodsListViewController *listVC = [[SDGoodsListViewController alloc] init];
    listVC.tabId = tabId;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}
- (BOOL )textFieldShouldBeginEditing:(UITextField *)textField{
    SDSearchViewController *searchView = [[SDSearchViewController alloc] init];
    searchView.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchView.searchHistoryStyle = PYHotSearchStyleARCBorderTag;
    [self.navigationController pushViewController:searchView animated:YES];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)fd_prefersNavigationBarHidden {
    return NO;
}
@end
