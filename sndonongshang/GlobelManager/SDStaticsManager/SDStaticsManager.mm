//
//  SDStaticsManager.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDStaticsManager.h"
#import "SDHomeTableView.h"
#import <UMCommon/UMCommon.h>
#import "AES128Helper.h"
#import<WCDB/WCDB.h>
#import "SDStaticsCacheModel.h"
#import "AES128Helper.h"
#import "SDCoordinateModel.h"


static NSString *const kStaticsEventUrl = @"http://182.140.144.180:8081/putdata?type=23";
static NSString *const kStaticsPageUrl = @"http://182.140.144.180:8081/putdata?type=22";
static NSString *const kStaticsDevice = @"http://182.140.144.180:8081/putdata?type=21";

static NSString *const kStaticsDevHost = @"http://182.140.144.180:8081";
static NSString *const kStaticsRelHost = @"https://i.sndo.com";
//http://i.sndo.com/putdata?type=21  ----  9本 启动数据
//http://i.sndo.com/putdata?type=22  ----  9本 页面统计
//http://i.sndo.com/putdata?type=23  ----  9本 事件统计

static NSString *const kStaticsTable = @"kStaticsTable";

static NSString *const kStaticsTypeEvent = @"0";
static NSString *const kStaticsTypePage = @"1";

@interface SDStaticsManager ()
@property (nonatomic ,strong) NSMutableDictionary *configDic;
@property (nonatomic ,strong) WCTDatabase *database;
@property (nonatomic ,strong) NSMutableDictionary *pageBeginDic;
@property (nonatomic ,strong) NSArray *pageDataArray;
@property (nonatomic ,strong) NSArray *eventDataArray;
@property (nonatomic ,strong) NSArray *currentDBDataArray;
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation SDStaticsManager
+ (instancetype)instance{
    static SDStaticsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDStaticsManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initConfig];
        [self timer];
        
    }
    return self;
}
- (NSMutableDictionary *)pageBeginDic{
    if (!_pageBeginDic) {
        _pageBeginDic = [[NSMutableDictionary alloc] init];
    }
    return _pageBeginDic;
}
- (void)initConfig{
    //db 初始化
    [self creatDatabase];
    [self creatDataTableInDB];
//    [SDStaticsManager uploadData];
}
+ (void)umEvent:(NSString *)key{
//#ifdef DEBUG
//    return;    //关闭统计
//#endif
    if (!key.length) {
        return;
    }
    [MobClick event:key];
    [SDStaticsManager saveEventToDB:key attr:nil];
}
+(void)umEvent:(NSString *)key attr:(NSDictionary *)dic{
//#ifdef DEBUG
//    return;    //关闭统计
//#endif
    if (!key.length) {
        return;
    }
    [MobClick event:key attributes:dic];
    [SDStaticsManager saveEventToDB:key attr:dic];
}
+ (void)umBeginPage:(NSString *)page type:(NSString *)type{
//#ifdef DEBUG
//    return;    //关闭统计
//#endif
    NSString *keyPage = [SDStaticsManager handePageToPageKey:page type:type];
    if (!keyPage.length) {
        return;
    }
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    [SDStaticsManager handleBeginPage:keyPage];
}
+ (void)umEndPage:(NSString *)page type:(NSString *)type{
//#ifdef DEBUG
//    return;    //关闭统计
//#endif
    NSString *keyPage = [SDStaticsManager handePageToPageKey:page type:type];
    if (!keyPage.length) {
        return;
    }
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    [SDStaticsManager savePageDataToDB:[SDStaticsManager handlePageDataToJsonStr:keyPage]];
}
#pragma mark 数据处理
+ (NSString *)handlePageDataToJsonStr:(NSString *)key{
    NSMutableDictionary *dic = [SDStaticsManager instance].pageBeginDic;
    NSString *beginTime = [dic valueForKey:key];
    if (beginTime.length) {
        NSString *endTime = [SDStaticsManager getCurrentTimeStr];
        
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic setValue:[NSNumber numberWithDouble:beginTime.doubleValue] forKey:@"startTime"];
        [resultDic setValue:[NSNumber numberWithDouble:endTime.doubleValue] forKey:@"endTime"];
        [resultDic setValue:key forKey:@"pageId"];
        [resultDic setValue:[NSNumber numberWithInt:0] forKey:@"background"];
        
        NSString *jsonStr = [resultDic mj_JSONString];
        return jsonStr;
    }
    return nil;
}
+ (void)handleBeginPage:(NSString *)key{
    NSMutableDictionary *dic = [SDStaticsManager instance].pageBeginDic;
    [dic removeAllObjects];
    NSString *time = [SDStaticsManager getCurrentTimeStr];
    [dic setValue:time forKey:key];
}
+ (NSString *)handePageToPageKey:(NSString *)page type:(NSString *)type{
    NSString *str = nil;
    if ([page isEqualToString:@"SDHomeViewController"]) {
        str = kHome;
    }else if ([page isEqualToString:@"SDCartListViewController"]) {
        str = kShoppingCart;
    }else if ([page isEqualToString:@"SDMineViewController"]) {
        str = kUser;
    }else if ([page isEqualToString:@"SDLoginViewController"]) {
        str = kLogin;
    }else if ([page isEqualToString:@"SDSmsCodeViewController"]) {
        str = kLoginCode;
    }else if ([page isEqualToString:@"SDRegisterSmsCodeViewController"]) {
        str = kRegist;
    }else if ([page isEqualToString:@"SDChangePhoneViewController"]) {
        str = kBindPhone;
    }else if ([page isEqualToString:@"SDGoodsListViewController"]) {
        str = kGoodsList;
    }else if ([page isEqualToString:@"SDGoodDetailViewController"] || [page isEqualToString:@"SDDisCountViewController"] ||[page isEqualToString:@"SDSecondKillViewController"] ||[page isEqualToString:@"SDSystemDetailViewController"]) {
        str = kGoodsDetail;
    }else if ([page isEqualToString:@"SDCartOrderViewController"]) {
        str = kOrderCreate;
    }else if ([page isEqualToString:@"SDPayViewController"]) {
        str = kOrderPay;
    }else if ([page isEqualToString:@"SDPayResultViewController"] && type.intValue == 0) {
        str = kOrderPaySuccess;
    }else if ([page isEqualToString:@"SDPayResultViewController"] && type.intValue == 0) {
        str = kOrderPayFail;
    }else if ([page isEqualToString:@"SDMyAccountViewController"]) {
        str = kUserInfo;
    }else if ([page isEqualToString:@"SDSettingViewController"]) {
        str = kSetting;
    }else if ([page isEqualToString:@"SDMyOrderViewController"]) {
        str = kOrderList;
    }else if ([page isEqualToString:@"SDOrderDetailViewController"]) {
        str = kOrderDetail;
    }else if ([page isEqualToString:@"SDMyCouponsViewController"]) {
        str = kUserCoupon;
    }else if ([page isEqualToString:@"SDMyIncomeViewController"]) {
        str = kIncome;
    }else if ([page isEqualToString:@"SDSafeVerifyViewController"]) {
        str = kWithdrawCode;
    }else if ([page isEqualToString:@"SDWithdrawalViewController"]) {
        str = kWithdraw;
    }else if ([page isEqualToString:@"SDGrouperOrderMgrViewController"] && type.intValue == 1) {
        str = kOrderManager_tz;
    }else if ([page isEqualToString:@"SDGrouperOrderMgrViewController"] && type.intValue == 0) {
        str = kOrderManager_normal;
    }else if ([page isEqualToString:@"SDGrouperOrderDetailViewController"]) {
        str = kOrderManager_detail;
    }
//    else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }else if ([page isEqualToString:@"SDCartListViewController"]) {
//        str = kShoppingCart;
//    }
    
    return str;
}
+ (void)saveEventToDB:(NSString *)key attr:(NSDictionary *)dic{
    NSString *jsonStr = [SDStaticsManager jsonEventStrWith:key attr:dic];
    [SDStaticsManager saveEnentToDB:jsonStr];
}
+ (NSString *)jsonEventStrWith:(NSString *)key attr:(NSDictionary *)dic{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    if (key.length) {
        [resultDic setValue:key forKey:@"eventId"];
    }
    if ([dic count]) {
        [resultDic setValue:dic forKey:@"param"];
    }
    NSString *timeStr = [SDStaticsManager getCurrentTimeStr];
    if (timeStr.length) {
        [resultDic setValue:[NSNumber numberWithDouble:timeStr.doubleValue] forKey:@"clickTime"];
    }
    NSString *jsonStr = [resultDic mj_JSONString];
    return jsonStr;
}
+ (NSString *)getCurrentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSInteger timeInt = (NSInteger)(time * 1000);
    NSString *timeStr = [NSString stringWithFormat:@"%ld",timeInt];
    return timeStr;
}
+ (void)saveEnentToDB:(NSString *)json{
    if (!json) {
        return;
    }
    SDStaticsCacheModel *model = [[SDStaticsCacheModel alloc] init];
    model.json = json;
    model.type = kStaticsTypeEvent;
    [[SDStaticsManager instance] insertNomalModel:model];
}
+ (void)savePageDataToDB:(NSString *)json{
    if (!json) {
        return;
    }
    SDStaticsCacheModel *model = [[SDStaticsCacheModel alloc] init];
    model.json = json;
    model.type = kStaticsTypePage;
    [[SDStaticsManager instance] insertNomalModel:model];
}
#pragma wxDB
//获得存放数据库文件的沙盒地址
+ (NSString *)wcdbFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"jieben.db"];
    return dbFilePath;
}

//1.创建数据库的操作
- (BOOL)creatDatabase
{
    _database = [[WCTDatabase alloc] initWithPath:[SDStaticsManager wcdbFilePath]];
    if (![_database isTableExists:@"jiubenDB"]) {
        BOOL result = [_database createTableAndIndexesOfName:@"jiubenDB" withClass:SDStaticsCacheModel.class];
        return result;
    }
    return YES;
}
//创建表单
- (BOOL )creatDataTableInDB{
    //测试数据库是否能够打开
    if ([_database canOpen]) {
        // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
        // 先判断表是不是已经存在
        if ([_database isOpened]) {
            if ([_database isTableExists:kStaticsTable]) {
                SNDOLOG(@"表已经存在");
                return NO;
            }else{
                BOOL result =  [_database createTableAndIndexesOfName:kStaticsTable withClass:SDStaticsCacheModel.class];
                SNDOLOG(@"创建表");
                return result;
            }
        }
    }
    return NO;
}
//插入数据
- (BOOL )insertNomalModel:(SDStaticsCacheModel *)model{
    if (model == nil) {
        return NO;
    }
    BOOL result = [_database insertObject:model into:kStaticsTable];
    return result;
}
//查找所有数据
- (NSArray<SDStaticsCacheModel *> *)getAllNomalModels
{
    return [_database getAllObjectsOfClass:SDStaticsCacheModel.class fromTable:kStaticsTable];
}
//删所有数据
- (BOOL)deleteAllNomalModels
{
    BOOL result = [_database deleteAllObjectsFromTable:kStaticsTable];
    return result;
}
- (BOOL )deleteModelsWithType:(NSString *)type{
    BOOL result = [_database deleteObjectsFromTable:kStaticsTable where:SDStaticsCacheModel.type == type];
    return result;
}
//更新数据
- (BOOL )updateNomalModel:(SDStaticsCacheModel *)model onProperty:(NSArray *)array{
    if (model == nil) {
        return NO;
    }
    BOOL result = [_database updateAllRowsInTable:kStaticsTable onProperties:{SDStaticsCacheModel.type,SDStaticsCacheModel.json} withObject:model];
    return result;
}
#pragma mark 数据上报
+ (void)uploadData{
#ifdef DEBUG
//    return;    //关闭统计
#endif
    [SDStaticsManager handelDataWithDB];
    NSString *hostUrl = nil;
    switch ([SDNetConfig sharedInstance].type) {
        case SeverType_Dev:
        {
            hostUrl = kStaticsDevHost;
        }
            break;
        case SeverType_Test:
        {
            hostUrl = kStaticsDevHost;
        }
            break;
        case SeverType_Release:
        {
            hostUrl = kStaticsRelHost;
        }
            break;
        default:
            break;
    }
    if (!hostUrl.length) {
        return;
    }
    [SDStaticsManager postDataWithUrl:[hostUrl stringByAppendingString:@"/putdata?type=21"] body:nil type:SDStaticsTypeLaunch];
    [SDStaticsManager postDataWithUrl:[hostUrl stringByAppendingString:@"/putdata?type=22"] body:[SDStaticsManager instance].pageDataArray type:SDStaticsTypePage];
    [SDStaticsManager postDataWithUrl:[hostUrl stringByAppendingString:@"/putdata?type=23"] body:[SDStaticsManager instance].eventDataArray type:SDStaticsTypeEvent];
}
+ (void)uploadPageData{
    
}
+ (void)uploadEventData{
    
}
+ (void)uploadDeciveData{
    [SDStaticsManager postDataWithUrl:kStaticsDevice body:nil type:SDStaticsTypeLaunch];
}

#pragma mark 请求
+ (void)postDataWithUrl:(NSString *)urlStr body:(NSArray *)bodyArray type:(SDStaticsType )type{
    if (type == SDStaticsTypePage || type == SDStaticsTypeEvent) {
        if (!bodyArray.count) {
            return;
        }
    }
    //post方法
    //1.创建会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url=[NSURL URLWithString:urlStr];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod=@"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //5.设置请求体
    NSString *bodyStr = [SDStaticsManager getBodyStrWithType:type body:bodyArray];
    NSString *encodeStr = [AES128Helper DESEncryptWithText:bodyStr];
    request.HTTPBody=[encodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        //8.解析数据
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (!error && httpResponse.statusCode == 200) {
            if (type == SDStaticsTypePage) {
                [[SDStaticsManager instance] deleteModelsWithType:kStaticsTypePage];
            }else if (type == SDStaticsTypeEvent){
                [[SDStaticsManager instance] deleteModelsWithType:kStaticsTypeEvent];
            }
        }
//        NSLog(@"%@",dict);
    }];
    
    //7.执行任务
    [dataTask resume];
}
+ (void)handelDataWithDB{
    NSArray *dataArray = [[SDStaticsManager instance] getAllNomalModels];
    NSMutableArray *event = [[NSMutableArray alloc] init];
    NSMutableArray *page = [[NSMutableArray alloc] init];
    for (SDStaticsCacheModel *mode in dataArray) {
        if (mode.type.intValue == SDStaticsTypeEvent) {
            [event addObject:[mode.json mj_JSONObject]];
        }else if (mode.type.intValue == SDStaticsTypePage){
            [page addObject:[mode.json mj_JSONObject]];
        }
    }
    [SDStaticsManager instance].currentDBDataArray = dataArray;
    [SDStaticsManager instance].eventDataArray = event;
    [SDStaticsManager instance].pageDataArray = page;
}
+ (NSString *)getBodyStrWithType:(SDStaticsType )type body:(NSArray *)dataArray{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInteger:2] forKey:@"platform"];
    [dic setValue:[NSObject getUDID] forKey:@"deviceId"];
    [dic setValue:[SDUserModel sharedInstance].userId forKey:@"uid"];
    if (type == SDStaticsTypeLaunch) {
        [dic setValue:[NSObject getShortVersion] forKey:@"version"];
//        NSString *lat = [NSString stringWithFormat:@"%f",[SDCoordinateModel sharedInstance].latitude];
//        NSString *log = [NSString stringWithFormat:@"%f",[SDCoordinateModel sharedInstance].longitude];
        [dic setValue:[NSNumber numberWithDouble:[SDCoordinateModel sharedInstance].latitude] forKey:@"latitude"];
        [dic setValue:[NSNumber numberWithDouble:[SDCoordinateModel sharedInstance].longitude] forKey:@"longitude"];
        [dic setValue:[NSObject getISP] forKey:@"operator"];
//        [dic setValue:[NSObject getNetWorkStates] forKey:@"network"];
        [dic setValue:[NSObject getCurrentDeviceModel] forKey:@"model"];
        [dic setValue:[NSString stringWithFormat:@"%d X %d",(int)SCREEN_WIDTH,(int)SCREEN_HEIGHT] forKey:@"resolution"];
        NSString *os = [NSObject getOS];
        if ([os length] > 1) {
            [dic setValue:[NSString stringWithFormat:@"iOS %@",os] forKey:@"os"];
        }
    }else if (type == SDStaticsTypePage){
        if ([dataArray count]) {
            [dic setObject:dataArray forKey:@"pages"];
        }
    }else if (type == SDStaticsTypeEvent){
        if ([dataArray count]) {
            [dic setObject:dataArray forKey:@"infos"];
        }
    }
    NSString *jsonStr = [dic mj_JSONString];
    return jsonStr;
}

#pragma mark 定时器上传每5分钟一次
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer sd_timerWithTimeInterval:300 repeats:YES block:^{
            [SDStaticsManager uploadData];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    }
    return _timer;
}
- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
}
@end
