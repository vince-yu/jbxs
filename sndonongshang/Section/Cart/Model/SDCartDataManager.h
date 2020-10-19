//
//  SDCartDataManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDGoodModel.h"
#import "SDCartOderRequest.h"
#import "SDAddressModel.h"
#import "SDCartRepoListModel.h"
#import "SDCartOrderTableView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartSuccessBlock)(id model);
typedef void(^CartFailedBlock)(id model);

@interface SDCartDataManager : NSObject
@property (nonatomic ,strong) NSMutableArray *cartListArray;
@property (nonatomic ,strong) NSArray *cartCalculateArray;

@property (nonatomic ,strong) SDCartOderRequestModel *prepayModel;
@property (nonatomic ,strong) SDCartOderModel *preOrderModel;

@property (nonatomic ,strong) NSArray *addressListArray;
@property (nonatomic ,strong) NSArray *repoListArray;

@property (nonatomic ,strong) SDAddressModel *selectAddressModel;
@property (nonatomic ,strong) SDCartRepoListModel *selectRepoModel;

+ (instancetype)sharedInstance;
+ (void)deallocManager;

+ (void)clearCartListCache;
+ (NSInteger )enbleVoucher;
+ (NSInteger )getAllCartGoodsCount;
+ (NSInteger )getCartSelectGoodsCount;
+ (NSInteger )getAllPreOderGoodsCount;

+ (BOOL )cartListGoodsAllSelected;
+ (void)pushToOrderListView;
+ (NSArray *)getSelectGoodArray;
+ (void)cartOrderGetAddressListArrayCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)updateCartGood:(SDGoodModel *)good completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)deleteCartGood:(SDGoodModel *)good completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)refreshCartListCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock hideHud:(BOOL )hide;
+ (void)synchronizationCartListCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)addCartGood:(SDGoodModel *)good needSelectGood:(BOOL )select completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)reduceCartGood:(SDGoodModel *)good completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
- (void)archiveCartListArray;
- (void)updateCartGoodSeleted:(NSArray *)goods seleted:(BOOL)selectd;

//算价接口
+ (void)getCartSelectGoodsPriceCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)getAddViewSelectGoodsPriceWith:(NSString *)goodsInfo completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)getCartAllGoodsPriceCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)getCartOrderViewPriceWith:(NSArray *)goodArray  completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
//下单
+ (void)cartToOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)prepayNomalOrderWithOrderRequestModel:(SDCartOderRequestModel *)model isCartTO:(BOOL )cartTo completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)nomalOrderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)cartOrderRepoListArrayCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;

// 团购下单
+ (void)systemGroupCartToOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)prepaySystemGroupOrderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;
+ (void)nomalSystemGroupOrderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock;

//经纬度处理
+(BOOL)checkLocationRight;
+ (NSString *)getLocationStr;

//验证支付数据规则
+ (BOOL )checkPrePayData;
//保存提货人信息
+ (void)saveSelfTakePersonAndMobile;
//检测订单中是否有不能快递的商品
- (BOOL )checkOrderExpress;
//订单页面不能送货的商品
- (NSArray *)orderExpressGoods;
- (NSInteger )orderExpressGoodCount;
- (NSArray *)removeExpressGood;
+ (void)pushToOrderExpressView;
- (NSArray *)remoeSoldOutGood:(NSArray *)soldOutArray;

//订单页面的处理
+ (void)handlePayOrderRequestFailed:(id )model viewController:(UIViewController *)vc refreshTable:(SDCartOrderTableView *)listTableView;
+ (void)handelGoodDetailRequestFailed:(id )model listTableView:(SDBaseTableView *)listTableView;
+ (void)handlePayOrderRequestFailedRepeat:(id )model viewController:(UIViewController *)vc refreshTable:(SDCartOrderTableView *)listTableView;
//hash表
+ (NSMutableDictionary *)arrayToHashDic:(NSArray *)array hashKey:(NSString *)key;
+ (void)handlePayOrderRequestFailed:(id )model viewController:(UIViewController *)vc refreshBlock:(void(^)(void))block;
+ (void)handlePayOrderRequestFailedRepeat:(id )model viewController:(UIViewController *)vc refreshBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
