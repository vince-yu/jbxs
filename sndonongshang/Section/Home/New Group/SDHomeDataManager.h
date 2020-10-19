//
//  SDHomeDataManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDHomeViewController.h"
#import "SDGoodModel.h"
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ConfigCompleteBlock)(id mdoel);
typedef void(^FailedBlock)(id model);

@interface SDHomeDataManager : NSObject
@property (nonatomic ,strong) NSArray *bannerArray;
@property (nonatomic ,strong) NSArray *floorArray;
@property (nonatomic ,strong) NSArray *categoryArray;
@property (nonatomic ,strong) NSArray *couponsArray;
@property (nonatomic ,copy) NSString *currentTime;

@property (nonatomic ,weak) SDHomeViewController *home;
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;

+ (instancetype)sharedInstance;
+ (void)clickBannerTojump:(NSInteger )index;
+ (void)configHome:(ConfigCompleteBlock )block failedBlock:(FailedBlock )failedBlock;
+ (void )configListTable:(ConfigCompleteBlock )block failedBlock:(FailedBlock )failedBlock;
+ (void )refreshGoodListWithId:(NSString *)tabId limit:(NSString *)limit page:(NSString *)page completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock;
+ (void)refreshGoodDetailWithGoodModel:(SDGoodModel *)goodModel hiddenToast:(BOOL)hidden completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock;
/** 刷新拼团商品详情数据 */
+ (void)refreshGroupGoodDetailWithGoodModel:(SDGoodModel *)goodModel completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock;
+ (void)recommedGoodToGoodDetail:(SDGoodModel *)goodMdoel;
+ (void)getHomeCouponsDataWithCompleteBlock:(ConfigCompleteBlock )block;
+ (BOOL )checkBeginWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (void)remindWith:(NSString *)goodId type:(NSString *)type status:(NSString *)status goodRemind:(BOOL )goodRemind completeBlock:(ConfigCompleteBlock )block failedBlock:(nonnull FailedBlock)failedBlock;
/** 获取商品详情页优惠券 */
+ (void)getGoodDetailAllCouponsData;
/** 获取用户信息 */
+ (void)getUserInfo;
//定时器
- (void)restartTimer:(NSString *)time;
//获取分享朋友圈小程序的二维码
+ (void)getWXQR:(ConfigCompleteBlock )block ailedBlock:(nonnull FailedBlock)failedBlock;
//审核状态检查
+ (void)checkVerifyStatus;
@end
NS_ASSUME_NONNULL_END
