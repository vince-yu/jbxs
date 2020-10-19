//
//  SDHomeDataManager.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeDataManager.h"
#import "SDHomeBannerRequest.h"
#import "SDHomeFloorRequest.h"
#import "SDHomeCategroyRequest.h"
#import "SDGoodListTabRequest.h"
#import "SDGoodListRequest.h"
#import "SDJumpManager.h"
#import "SDGoodDetailRequest.h"
#import "SDHomeBannerModel.h"
#import "SDGoodDetailViewController.h"
#import "SDSystemDetailViewController.h"
#import "SDTabBarViewController.h"
#import "SDDisCountViewController.h"
#import "SDSecondKillViewController.h"
#import "SDGoodCouponRequest.h"
#import "SDHomeCouponsRequest.h"
#import "SDHomePopView.h"
#import "SDGoodActivityRequest.h"
#import "SDGoodActivitySetRequest.h"
#import "SDGoodCouponsPopView.h"
#import "SDGetUserRequest.h"
#import "CYLTabBarController.h"
#import "SDQRRequest.h"
#import "SDVersionCheckRequest.h"

static SDHomeDataManager *homeManager = nil;

@interface SDHomeDataManager ()
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger time;
@end

@implementation SDHomeDataManager
@synthesize currentTime = _currentTime;

+ (instancetype)sharedInstance {
    if (!homeManager) {
        homeManager = [[SDHomeDataManager alloc] init];
    }
    return homeManager;
}
- (void)dealloc{
    [self.timer invalidate];
}
+ (void)deallocManager{
    homeManager = nil;
}
+ (void)configHome:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock{
    SDHomeBannerRequest *bannerRequest = [[SDHomeBannerRequest alloc] init];
    SDHomeFloorRequest *floorRequest = [[SDHomeFloorRequest alloc] init];
    SDHomeCategroyRequest *categroyRequest = [[SDHomeCategroyRequest alloc] init];
    YTKBatchRequest *batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:bannerRequest,floorRequest,categroyRequest, nil]];
    [SDToastView show];
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        NSArray *requestArray = batch.requestArray;
        SDHomeBannerRequest *bannerRequest = (SDHomeBannerRequest *)requestArray[0];
        SDHomeFloorRequest *floorRequest = (SDHomeFloorRequest *)requestArray[1];
        SDHomeCategroyRequest *categroyRequest = (SDHomeCategroyRequest *)requestArray[2];
        
        [SDHomeDataManager sharedInstance].bannerArray = bannerRequest.dataArray;
        [SDHomeDataManager sharedInstance].categoryArray = categroyRequest.dataArray;
        [SDHomeDataManager sharedInstance].floorArray = floorRequest.dataArray;
        
        if (block) {
            block(@"");
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SDToastView HUDWithErrString:@"加载数据失败"];
        if (failedBlock) {
            failedBlock(batchRequest);
        }
    }];
}
+ (void )configListTable:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock{
    SDGoodListTabRequest *tabRequest = [[SDGoodListTabRequest alloc] init];
    [tabRequest startWithCompletionBlockWithSuccess:^(__kindof SDGoodListTabRequest * _Nonnull request) {
        if (block) {
            block(request.dataArray);
        }
        
    } failure:^(__kindof SDGoodListTabRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(request);
        }
    }];
}
+ (void )refreshGoodListWithId:(NSString *)tabId limit:(NSString *)limit page:(NSString *)page completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock{
    SDGoodListRequest *tabRequest = [[SDGoodListRequest alloc] init];
    tabRequest.limit = limit;
    tabRequest.page = page;
    tabRequest.tabId = tabId;
    [SDToastView show];
    [tabRequest startWithCompletionBlockWithSuccess:^(__kindof SDGoodListRequest * _Nonnull request) {
        if (block) {
            block(request.listModel.data);
        }
    } failure:^(__kindof SDGoodListRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(request);
        }
    }];
}
+ (void)clickBannerTojump:(NSInteger )index{
    SDHomeBannerModel *model = [[SDHomeDataManager sharedInstance].bannerArray objectAtIndex:index];
    [SDStaticsManager umEvent:kbanner attr:@{@"_id":model.idField}];
    [SDJumpManager jumpUrl:model.url push:YES parentsController:[SDHomeDataManager sharedInstance].home animation:YES];
}
+ (void)refreshGoodDetailWithGoodModel:(SDGoodModel *)goodModel hiddenToast:(BOOL)hidden completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock{
    
    
    SDGoodDetailRequest *request = [[SDGoodDetailRequest alloc] init];
    request.type = goodModel.type;
    request.groupId = goodModel.groupId;
    request.goodId = goodModel.goodId;
    if (!hidden) {
        [SDToastView show];
    }
    SDGoodCouponRequest *couponRequest = [[SDGoodCouponRequest alloc] init];
    if ([SDUserModel sharedInstance].isLogin) {
        couponRequest.type = @"0";
    }else{
        couponRequest.type = @"1";
    }
    
    SDGoodActivityRequest *acRe = [[SDGoodActivityRequest alloc] init];
    acRe.type = goodModel.type;
    acRe.goodId = goodModel.goodId;
    
    SDGoodActivityRequest *acRe1 = [[SDGoodActivityRequest alloc] init];
    acRe1.type = goodModel.type;
    acRe1.goodId = goodModel.goodId;
    acRe1.goodsremind = YES;
    
    YTKBatchRequest *batch = nil;
    if ([SDUserModel sharedInstance].isLogin) {
        batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:request,couponRequest,acRe,acRe1, nil]];
    }else{
        batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:request, nil]];
    }
    
    
    if (!hidden) {
        [SDToastView show];
    }
    //检测是否已过审
    [self checkVerifyStatus];
    
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        NSArray *requestArray = batch.requestArray;
        SDGoodDetailRequest *request = (SDGoodDetailRequest *)requestArray[0];
        if ([SDUserModel sharedInstance].isLogin) {
            SDGoodCouponRequest *couponRequest = (SDGoodCouponRequest *)[requestArray objectAtIndex:1];
            SDGoodActivityRequest *acRe = (SDGoodActivityRequest *)[requestArray objectAtIndex:2];
            SDGoodActivityRequest *acRe1 = (SDGoodActivityRequest *)[requestArray objectAtIndex:3];
            request.detailModel.couponArray = couponRequest.couponsArr;
            request.detailModel.remind = [NSString stringWithFormat:@"%@",acRe.status];
            request.detailModel.goodsremind = [NSString stringWithFormat:@"%@",acRe1.status];
        }else{
            SDGoodActivityRequest *acRe1 = (SDGoodActivityRequest *)[requestArray objectAtIndex:3];
            request.detailModel.goodsremind = [NSString stringWithFormat:@"%@",acRe1.status];
        }
//        [SDHomeDataManager sharedInstance].detailModel = request.detailModel;
//        if (request.code == 201) {
//            if (failedBlock) {
//                failedBlock(batchRequest);
//            }
//        }else{
        request.detailModel.code = request.code;
            if (block) {
                block(request.detailModel);
            }
//        }
        
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SDToastView HUDWithErrString:@"加载数据失败"];
        if (failedBlock) {
            failedBlock(batchRequest);
        }
    }];
    
    
}
+ (void)checkVerifyStatus{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"KAppVerify"] boolValue]) {
        return;
    }
    SDVersionCheckRequest *checkRe = [[SDVersionCheckRequest alloc] init];
    [checkRe startWithCompletionBlockWithSuccess:^(__kindof SDVersionCheckRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
+ (void)refreshGroupGoodDetailWithGoodModel:(SDGoodModel *)goodModel completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock {
    SDGoodDetailRequest *request = [[SDGoodDetailRequest alloc] init];
    request.type = goodModel.type;
    request.groupId = goodModel.groupId;
    request.goodId = goodModel.goodId;

    SDGoodCouponRequest *couponRequest = [[SDGoodCouponRequest alloc] init];
    couponRequest.type = @"0";
    SDGoodActivityRequest *acRe = [[SDGoodActivityRequest alloc] init];
    acRe.type = goodModel.type;
    acRe.goodId = goodModel.goodId;
    YTKBatchRequest *batch = nil;
    if ([SDUserModel sharedInstance].isLogin) {
        batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:request,couponRequest,acRe, nil]];
    }else{
        batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:request, nil]];
    }
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        NSArray *requestArray = batch.requestArray;
        SDGoodDetailRequest *request = (SDGoodDetailRequest *)requestArray[0];
        if ([SDUserModel sharedInstance].isLogin) {
            SDGoodCouponRequest *couponRequest = (SDGoodCouponRequest *)requestArray[1];
            SDGoodActivityRequest *acRe = (SDGoodActivityRequest *)requestArray[2];
            request.detailModel.couponArray = couponRequest.couponsArr;
            request.detailModel.remind = [NSString stringWithFormat:@"%@",acRe.status];
        }
        
        
        
        if (block) {
            block(request.detailModel);
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SDToastView HUDWithErrString:@"加载数据失败"];
        if (failedBlock) {
            failedBlock(batchRequest);
        }
    }];
}

+ (void)getGoodDetailAllCouponsData {
    SDGoodCouponRequest *couponRequest = [[SDGoodCouponRequest alloc] init];
    couponRequest.type = @"1";
    [SDToastView show];
    [couponRequest startWithCompletionBlockWithSuccess:^(__kindof SDGoodCouponRequest * _Nonnull request) {
        if (request.couponsArr.count > 0) {
            [SDGoodCouponsPopView popViewWithCoupons:request.couponsArr];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

+ (void)recommedGoodToGoodDetail:(SDGoodModel *)goodModel{
    CYLTabBarController *tab = (CYLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    if (goodModel.type.integerValue == SDGoodTypeNamoal) {
        SDGoodDetailViewController *detailVC = [[SDGoodDetailViewController alloc] init];
        detailVC.goodModel = goodModel;
        [nav pushViewController:detailVC animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeGroup){
        SDSystemDetailViewController *vc = [[SDSystemDetailViewController alloc] init];
        vc.goodModel = goodModel;
        [nav pushViewController:vc animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeSecondkill){
        SDSecondKillViewController *vc = [[SDSecondKillViewController alloc] init];
        vc.goodModel = goodModel;
        [nav pushViewController:vc animated:YES];
    }else if (goodModel.type.integerValue == SDGoodTypeDiscount){
        SDDisCountViewController *vc = [[SDDisCountViewController alloc] init];
        vc.goodModel = goodModel;
        [nav pushViewController:vc animated:YES];
    }
    [SDHomeDataManager deleteRemmodVC];
}
+ (void)deleteRemmodVC{
    CYLTabBarController *tab = (CYLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    if (nav.viewControllers.count < 5) {
        return;
    }
    NSInteger count = 0;
    for (NSInteger i = nav.viewControllers.count - 1; i >= 0 ; i --) {
        UIViewController *vc = [nav.viewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[SDDetailViewController class]]) {
            count ++;
            if (count == 4) {
                break;
            }
        }else{
            count = 0;
        }
    }
    if (count >= 4) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:nav.viewControllers];
        [array removeObjectAtIndex:array.count - 4];
        nav.viewControllers = array;
    }
    
}

+ (void)getHomeCouponsDataWithCompleteBlock:(ConfigCompleteBlock )block {
    SDHomeCouponsRequest *request = [[SDHomeCouponsRequest alloc] init];
    request.all = @"1";
    [request startWithCompletionBlockWithSuccess:^(__kindof SDHomeCouponsRequest * _Nonnull request) {
        if (![request.alertStr isEqualToString:@"已经发放"] && request.couponsArr.count > 0) {
            [SDHomeDataManager sharedInstance].couponsArray = request.couponsArr;
            if (block) {
                block(request.alert);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}
+ (void)remindWith:(NSString *)goodId type:(NSString *)type status:(NSString *)status goodRemind:(BOOL )goodRemind completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock{
    SDGoodActivitySetRequest *request = [[SDGoodActivitySetRequest alloc] init];
    request.goodId = goodId;
    request.type = type;
    request.status = status;
    if (goodRemind) {
        request.goodsremind = YES;
    }
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (block) {
            block(@"");
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(request);
        }
    }];
}
+ (BOOL )checkBeginWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    if (!startTime.length && !endTime.length) {
        return NO;
    }
    BOOL isBegin = NO;
    NSInteger start = startTime.length ? [startTime groupTime] : 0;
    if (start > 0) {
        isBegin = NO;
        
    }else{
        isBegin = YES;
        
    }
    return isBegin;
}

+ (void)getUserInfo {
    SDGetUserRequest *request = [[SDGetUserRequest alloc] init];
    request.nodissMissHud = YES;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
+ (void)getWXQR:(ConfigCompleteBlock )block ailedBlock:(nonnull FailedBlock)failedBlock{
    /*
     @"Content-Type": @"application/json",
     @"headMode": @"",
     @"User-Agent": @"iOS",
     @"Device-Type": @"5",
     @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
     @"appVersion": [UIApplication sharedApplication].appVersion
     */
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *str = [[SDUserModel sharedInstance].userId md5String];
//    NSString *savePath = [cachePath stringByAppendingString:str];
//    NSData *dataImage = [NSData dataWithContentsOfFile:savePath];
//    UIImage *image = [UIImage imageWithData:dataImage];
//    if (image) {
//        block(image);
//        return;
//    }
    NSMutableString *urlStr = [[NSMutableString alloc] initWithFormat:@"%@share/GetQR.png?witdh=95",[SDNetConfig sharedInstance].baseUrl];
    SDGoodDetailModel *model = [SDHomeDataManager sharedInstance].detailModel;
    if (model.goodId.length) {
        [urlStr appendFormat:@"&goods_id=%@",model.goodId];
    }
    if (model.type) {
        [urlStr appendFormat:@"&goods_type=%@",model.type];
    }
    if ([SDUserModel sharedInstance].isLogin) {
        [urlStr appendFormat:@"&user_id=%@",[SDUserModel sharedInstance].userId];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[[NSUserDefaults standardUserDefaults] stringForKey:KToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"application/json"];
    [request setValue:@"" forHTTPHeaderField:@"headMode"];
    [request setValue:@"5" forHTTPHeaderField:@"Device-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[UIApplication sharedApplication].appVersion forHTTPHeaderField:@"appVersion"];
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            //location 是下载后的临时保存路径，需要将它移动到需要保存的位置
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            if (block) {
                block(image);
            }
//            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//            NSString *str = [[SDUserModel sharedInstance].userId md5String];
//            NSString *savePath = [cachePath stringByAppendingString:str];
//            NSLog(@"%@",savePath);
////            NSURL *url = [NSURL fileURLWithPath:savePath];
//            BOOL result = [data writeToFile:savePath atomically:YES];
        }else{
            NSLog(@"error is :%@",error.localizedDescription);
        }
    }];
    [task resume];

            
    
//    SDQRRequest *request = [[SDQRRequest alloc] init];
//    request.width = 95;
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filepath = [path stringByAppendingPathComponent:@"QR.png"];
//    request.resumableDownloadPath = filepath;
//    request.resumableDownloadProgressBlock = ^(NSProgress * _Nonnull progress) {
//      
//        
//    };
//    [request startWithCompletionBlockWithSuccess:^(__kindof SDQRRequest * _Nonnull request) {
//        if (block) {
//            block(request.QRImage);
//        }
//    } failure:^(__kindof SDQRRequest * _Nonnull request) {
//        if (failedBlock) {
//            failedBlock();
//        }
//    }];
}
#pragma mark 记录服务器当前时间
//- (NSTimer *)timer{
//    if (!_timer) {
//        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        
//    }
//    return _timer;
//}
//- (void)refreshTime{
////    SNDOLOG(@"current time is....%ld",_time);
//    _time ++;
//}
//- (void)setCurrentTime:(NSString *)currentTime{
//    if (_currentTime.length || [_timer isValid] || self.time > 0 || !currentTime.length) {
//        return;
//    }
//    _currentTime = currentTime;
//    self.time = _currentTime.integerValue / 1000;
//    [self.timer fire];
////    [self.timer fire];
//}
//- (void)restartTimer:(NSString *)time{
//    [self destoryTimer];
//    [self setCurrentTime:time];
//}
//- (void)destoryTimer{
//    [_timer invalidate];
//    _timer = nil;
//    _currentTime = nil;
//    _time = -1;
//}
//- (NSString *)currentTime{
//    return [NSString stringWithFormat:@"%ld",self.time];
//}
//- (void)setTime:(NSInteger)time{
//    _time = time;
//}
@end
