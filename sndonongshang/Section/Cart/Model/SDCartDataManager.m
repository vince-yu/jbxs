//
//  SDCartDataManager.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartDataManager.h"
#import "SDCartOrderListView.h"
#import "SDCartListRequest.h"
#import "SDCartDeleteRequest.h"
#import "SDCartUpdateRequest.h"
#import "SDCartSGOderRequest.h"
#import "SDCartRepoListRequest.h"
#import "SDUserModel.h"
#import "SDGoodModel.h"
#import "SDGetAddrListReqeust.h"
#import "SDCartOderModel.h"
#import "SDCartCalculateRequest.h"
#import "SDCoordinateModel.h"
#import "SDCouponsModel.h"


static SDCartDataManager *cartManager = nil;

@implementation SDCartDataManager
+ (instancetype)sharedInstance {
    if (!cartManager) {
        cartManager = [[SDCartDataManager alloc] init];
    }
    return cartManager;
}
- (void)dealloc{
    
}
+ (void)deallocManager{
    cartManager = nil;
}
+ (void)pushToOrderListView{
    SDCartOrderListView *listView = [[SDCartOrderListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:SDCartOrderListViewTypeNomal];
    [listView show];
}
+ (void)pushToOrderExpressView{
    SDCartOrderListView *listView = [[SDCartOrderListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:SDCartOrderListViewTypeDelete];
    [listView show];
}
#pragma mark 购物车接口
//获取购物车列表
+ (void)refreshCartListCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock hideHud:(BOOL )hide{
    if (![SDUserModel sharedInstance].isLogin) {
        [[SDCartDataManager sharedInstance] unArchiveCartListArray];
//        [SDCartDataManager getCartAllGoodsPriceCompleteBlock:^(id  _Nonnull model) {
            if (block) {
                block(@"");
            }
//        } failedBlock:^{
//            if (block) {
//                block(@"");
//            }
//        }];
        
        return;
    }
    SDCartListRequest *request = [[SDCartListRequest alloc] init];
    request.nodissMissHud = hide;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartListRequest * _Nonnull request) {
//        [[SDCartDataManager sharedInstance] reloadListArrayWith:request.cartModel.goods];
//        [SDCartDataManager getCartAllGoodsPriceCompleteBlock:^(id  _Nonnull model) {
//            if (block) {
//
//                block(@"");
//            }
//        } failedBlock:^{
//            if (block) {
////                 [[SDCartDataManager sharedInstance] reloadListArrayWith:request.cartModel.goods];
//                block(@"");
//            }
//        }];
        if (block) {
            [[SDCartDataManager sharedInstance] reloadListArrayWith:request.cartModel.goods];
        
            block(@"");
        }
    } failure:^(__kindof SDCartListRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
//删除购物车中某个商品
+ (void)deleteCartGood:(SDGoodModel *)good completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    if (![SDUserModel sharedInstance].isLogin) {
        [[SDCartDataManager sharedInstance] deleteGoodFromCartListArray:good.goodId];
        if (block) {
            block(@"");
        }
        return;
    }
    SDCartDeleteRequest *request = [[SDCartDeleteRequest alloc] init];
    request.goodId = good.dataId;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartDeleteRequest * _Nonnull request) {
        [[SDCartDataManager sharedInstance] deleteGoodFromCartListArray:good.goodId];
        if (block) {
            block(@"");
        }
    } failure:^(__kindof SDCartDeleteRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
//购物车某商品数量设置为某个数量(暂时没有使用)
+ (void)updateCartGood:(SDGoodModel *)good completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    if (![SDUserModel sharedInstance].isLogin) {
        [[SDCartDataManager sharedInstance] updateGoodFromCartListArray:good];
        if (block) {
            block(@"");
        }
        return;
    }
    SDCartUpdateRequest *request = [[SDCartUpdateRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartDeleteRequest * _Nonnull request) {
        [[SDCartDataManager sharedInstance] updateGoodFromCartListArray:good];
        [[SDCartDataManager sharedInstance] archiveCartListArray];
        if (block) {
            block(@"");
        }
    } failure:^(__kindof SDCartDeleteRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
//购物车某商品数量加1
+ (void)addCartGood:(SDGoodModel *)good needSelectGood:(BOOL )select completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    if ([SDCartDataManager checkGoodIsMaxCount:good]) {
        [SDToastView HUDWithString:@"超过最大购买数量，请分多次购买!"];
        return;
    }
    SDGoodModel *existGood = [SDGoodModel mj_objectWithKeyValues:[good mj_keyValues]];
    existGood.num = @"1";
    if (![SDUserModel sharedInstance].isLogin) {
        existGood.status = @"1";
        [[SDCartDataManager sharedInstance] addGoodToCartListArray:existGood select:select];
        if (block) {
            block(@"");
        }
        return;
    }
    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormGoodsArray:[NSArray arrayWithObject:existGood] updateServer:NO];
    [SDCartDataManager cartListUpdate:jsonStr exsitGood:existGood completeBlock:^(id  _Nonnull model) {
        [[SDCartDataManager sharedInstance] addGoodToCartListArray:existGood select:select];
        if (block) {
            block(@"");
        }
    } failedBlock:^(id model){
        if ([model isKindOfClass:[SDBSRequest class]]) {
            SDBSRequest *bsre = (SDBSRequest *)model;
            if (bsre.code == 201) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshGoodDetailVC object:good.goodId];
            }
            if (failedBlock) {
                failedBlock(model);
            }
        }
    }];
}
//购物车某商品数量减1
+ (void)reduceCartGood:(SDGoodModel *)good completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDGoodModel *existGood = [SDGoodModel mj_objectWithKeyValues:[good mj_keyValues]];
    existGood.num = @"-1";
    if (![SDUserModel sharedInstance].isLogin) {
        [[SDCartDataManager sharedInstance] reduceGoodFromCartListArray:existGood];
        if (block) {
            block(@"");
        }
        return;
    }
    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormGoodsArray:[NSArray arrayWithObject:existGood] updateServer:NO];
    [SDCartDataManager cartListUpdate:jsonStr exsitGood:existGood completeBlock:^(id  _Nonnull model) {
        [[SDCartDataManager sharedInstance] reduceGoodFromCartListArray:existGood];
        if (block) {
            block(@"");
        }
    } failedBlock:^(id model){
        
    }];
}
#pragma mark 购物车数量变化接口
+ (void)cartListUpdate:(NSString *)jsonStr exsitGood:(SDGoodModel *)existGood completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartUpdateRequest *request = [[SDCartUpdateRequest alloc] init];
//    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormGoodsArray:[NSArray arrayWithObject:existGood] updateServer:NO];
    request.goodsInfo = jsonStr;
//    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartDeleteRequest * _Nonnull request) {
//        [[SDCartDataManager sharedInstance] reduceGoodFromCartListArray:existGood];
        
        if (block) {
            block(@"");
        }
//        [[SDCartDataManager sharedInstance] archiveCartListArray];
    } failure:^(__kindof SDCartDeleteRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(request);
        }
    }];
}
#pragma mark 同步本地购物车到服务器
//本地购物车同步到服务器
+ (void)synchronizationCartListCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartUpdateRequest *updateRequest = [[SDCartUpdateRequest alloc] init];
    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormGoodsArray:[SDCartDataManager sharedInstance].cartListArray updateServer:YES];
    updateRequest.goodsInfo = jsonStr;
    SDCartListRequest *listRequest = [[SDCartListRequest alloc] init];
    YTKBatchRequest *batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:updateRequest,listRequest, nil]];
    [SDToastView show];
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        NSArray *requestArray = batch.requestArray;
//        SDCartUpdateRequest *updateRequest = (SDCartUpdateRequest *)requestArray[0];
        SDCartListRequest *listRequest = (SDCartListRequest *)requestArray[1];
        [[SDCartDataManager sharedInstance] reloadListArrayWith:listRequest.cartModel.goods];
        [[SDCartDataManager sharedInstance] archiveCartListArray];
        
        if (block) {
            block(@"");
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SDToastView HUDWithErrString:@"加载数据失败"];
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
#pragma mark 算价接口
+ (void)getCartAllGoodsPriceCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartCalculateRequest *request = [[SDCartCalculateRequest alloc] init];
    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormGoodsArray:[SDCartDataManager sharedInstance].cartListArray];
    request.goodsInfo = jsonStr;
    //    [SDToastView show];
    request.nodissMissHud = NO;
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        [[SDCartDataManager sharedInstance] cartGoodMoreDataToListData:request.model.more];
        if (block) {
            block(request.model);
        }
    } failure:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
//算价接口
+ (void)getCartSelectGoodsPriceCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartCalculateRequest *request = [[SDCartCalculateRequest alloc] init];
    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormSelectGoodsArray:[SDCartDataManager sharedInstance].cartListArray];
    request.goodsInfo = jsonStr;
//    [SDToastView show];
    request.nodissMissHud = YES;
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (block) {
            block(request.model);
        }
    } failure:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}

+ (void)getAddViewSelectGoodsPriceWith:(NSString *)goodsInfo completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartCalculateRequest *request = [[SDCartCalculateRequest alloc] init];
//    NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormSelectGoodsArray:[SDCartDataManager sharedInstance].cartListArray];
    request.goodsInfo = goodsInfo;
    request.nodissMissHud = YES;
//    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (block) {
            block(request.model);
        }
    } failure:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
//        [SDToastView HUDWithErrString:request.msg];
    }];
}
+ (void)getCartOrderViewPriceWith:(NSArray *)goodArray  completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartCalculateRequest *request = [[SDCartCalculateRequest alloc] init];
        NSString *jsonStr = [[SDCartDataManager sharedInstance] jsonStrFormGoodsArray:goodArray];
    request.goodsInfo = jsonStr;
    request.nodissMissHud = YES;
    //    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (block) {
            block(request.model);
        }
    } failure:^(__kindof SDCartCalculateRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
        //        [SDToastView HUDWithErrString:request.msg];
    }];
}
- (void)updateCartlistArrayWithCalculateArray{
    NSDictionary *dic = [SDCartDataManager arrayToHashDic:self.cartCalculateArray hashKey:@"goodsId"];
    for (SDGoodModel *goodModel in self.cartListArray) {
        NSString *goodId = goodModel.goodId;
        SDCartCalculateMoreModel *more = [dic objectForKey:goodId];
        if (more) {
            more.spec = goodModel.spec;
            goodModel.moreModel = more;
        }else{
            goodModel.moreModel = nil;
        }
    }
}
- (void)setCartCalculateArray:(NSArray *)cartCalculateArray{
    _cartCalculateArray = cartCalculateArray;
    [self updateCartlistArrayWithCalculateArray];
}
#pragma mark 购物车数据处理
+ (BOOL )checkGoodIsMaxCount:(SDGoodModel *)model{
    
    BOOL check = [SDCartDataManager getGoodNumFromCartListArray:model] >= 99 ? YES : NO;
    return check;
}
+ (NSInteger )getGoodNumFromCartListArray:(SDGoodModel *)model{
    NSInteger count = 0;
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].cartListArray) {
        if ([model.goodId isEqualToString:good.goodId]) {
            count = good.num.integerValue;
            break;
        }
    }
    return count;
}
- (void)archiveCartListArray{
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    
    stringPath = [stringPath stringByAppendingPathComponent:@"cartList.txt"];            // 成功
    
    BOOL result = [NSKeyedArchiver archiveRootObject:self.cartListArray toFile:stringPath];
    if (result) {
        SNDOLOG(@"cart list 归档成功");
    }else{
        SNDOLOG(@"cart list 归档失败");
    }
}
+ (void)clearCartListCache{
    [[SDCartDataManager sharedInstance].cartListArray removeAllObjects];
    [[SDCartDataManager sharedInstance] archiveCartListArray];
}
- (void)unArchiveCartListArray{
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    stringPath = [stringPath stringByAppendingPathComponent:@"cartList.txt"];            // 成功
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:stringPath];
    [self reloadListArrayWith:array];
}
- (NSString *)jsonStrFormSelectGoodsArray:(NSArray *)goodsArray{
    
    NSArray *array = [self cartValuationArray:goodsArray];
    return [array mj_JSONString];
    
}
- (NSString *)jsonStrFormGoodsArray:(NSArray *)goodsArray{
    
    NSArray *array = [self cartAllValuationArray:goodsArray];
    return [array mj_JSONString];
    
}
- (NSArray *)cartValuationArray:(NSArray *)goodsArray{
    NSMutableArray *array = [NSMutableArray array];
    for (SDGoodModel *good in goodsArray) {
        if (good.selected.boolValue) {
            SDCartCalculateRequestModel *updateModel = [self getCalculateRequestModel:good];
            [array addObject:[updateModel mj_keyValues]];
        }
        
    }
    return array;
}
- (NSArray *)cartAllValuationArray:(NSArray *)goodsArray{
    NSMutableArray *array = [NSMutableArray array];
    for (SDGoodModel *good in goodsArray) {
//        if (good.selected.boolValue) {
            SDCartCalculateRequestModel *updateModel = [self getCalculateRequestModel:good];
            [array addObject:[updateModel mj_keyValues]];
//        }
        
    }
    return array;
}
- (SDCartCalculateRequestModel *)getCalculateRequestModel:(SDGoodModel *)good{
    SDCartCalculateRequestModel *updateModel = [[SDCartCalculateRequestModel alloc] init];
    updateModel.goodId = good.goodId;
    updateModel.type = good.type;
    updateModel.targetNum = good.num;
    return updateModel;
}
- (NSString *)jsonStrFormGoodsArray:(NSArray *)goodsArray updateServer:(BOOL )update{
    NSMutableArray *array = [NSMutableArray array];
    for (SDGoodModel *good in goodsArray) {
        SDCartUpdateModel *updateModel = [[SDCartUpdateModel alloc] init];
        updateModel.goodsId = good.goodId;
        updateModel.type = good.type;
        if (update) {
            updateModel.targetNum = good.num;
            updateModel.num = @"0";
        }else{
            updateModel.targetNum = @"0";
            updateModel.num = good.num;
        }
        [array addObject:[updateModel mj_keyValues]];
    }
    
    return [array mj_JSONString];
}
- (NSMutableArray *)cartListArray{
    if (!_cartListArray) {
        _cartListArray = [[NSMutableArray alloc] init];
        [self unArchiveCartListArray];
    }
    return _cartListArray;
}
- (void)reloadListArrayWith:(NSArray *)array{
    NSDictionary *hashDic = [self cartListArrayToHashDic];
    for (SDGoodModel *model in array) {
        NSString *goodId = model.goodId;
        SDGoodModel *oldModel = [hashDic objectForKey:goodId];
        if (oldModel.selected.boolValue && !model.soldOut) {
            model.selected = [NSNumber numberWithBool:YES];
//            model.moreModel = oldModel.moreModel;
        }
        if (oldModel.moreModel) {
            model.moreModel = oldModel.moreModel;
        }else{
            model.moreModel = nil;
        }
    }
    [self.cartListArray removeAllObjects];
    [self.cartListArray addObjectsFromArray:array];
    [self archiveCartListArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiCartGoodSelected object:[self getTotalGoodPrice]];
}
- (void)cartGoodMoreDataToListData:(NSArray *)array{
    NSMutableDictionary *hashDic = [SDCartDataManager arrayToHashDic:array hashKey:@"goodsId"];
    for (SDGoodModel *model in self.cartListArray) {
        NSString *goodId = model.goodId;
        SDCartCalculateMoreModel *moreModel = [hashDic objectForKey:goodId];
        if (moreModel) {
//            oldModel.selected = [NSNumber numberWithBool:YES];
            moreModel.spec = model.spec;
            model.moreModel = moreModel;
        }else{
            model.moreModel = nil;
        }
    }
}
- (void)addGoodToCartListArray:(SDGoodModel *)good select:(BOOL )select{
    NSMutableDictionary *dic = [self cartListArrayToHashDic];
    SDGoodModel *existGood = [dic objectForKey:good.goodId];
    if (existGood) {
        NSInteger num = existGood.num.integerValue + good.num.integerValue;
        existGood.num = [NSString stringWithFormat:@"%ld",num];
        if (existGood.selected.boolValue == YES || select == YES) {
            existGood.selected = [NSNumber numberWithBool:YES];
        }else{
            
        }
        
    }else{
        if (existGood.selected.boolValue == YES || select == YES) {
            good.selected = [NSNumber numberWithBool:YES];
        }
        
        [self.cartListArray addObject:good];
    }
    [self archiveCartListArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiCartGoodSelected object:[self getTotalGoodPrice]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartGoodCount object:nil];
}
- (void)updateGoodFromCartListArray:(SDGoodModel *)good{
    NSMutableDictionary *dic = [self cartListArrayToHashDic];
    SDGoodModel *existGood = [dic objectForKey:good.goodId];
    if (existGood) {
        NSInteger num = good.num.integerValue;
        existGood.num = [NSString stringWithFormat:@"%ld",num];
    }else{
        [self.cartListArray addObject:good];
    }
    [self archiveCartListArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiCartGoodSelected object:[self getTotalGoodPrice]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartGoodCount object:nil];
}
- (void)reduceGoodFromCartListArray:(SDGoodModel *)good{
    NSMutableDictionary *dic = [self cartListArrayToHashDic];
    SDGoodModel *existGood = [dic objectForKey:good.goodId];
    if (existGood) {
        NSInteger num = existGood.num.integerValue + good.num.integerValue;
        if (num > 1) {
            existGood.num = [NSString stringWithFormat:@"%ld",num];
        }else{
            existGood.num = [NSString stringWithFormat:@"%d",1];
        }
        
    }else{
        
    }
    [self archiveCartListArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiCartGoodSelected object:[self getTotalGoodPrice]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartGoodCount object:nil];
}
- (void)deleteGoodFromCartListArray:(NSString *)goodId{
    NSMutableDictionary *dic = [self cartListArrayToHashDic];
    SDGoodModel *existGood = [dic objectForKey:goodId];
    if (existGood) {
        [self.cartListArray removeObject:existGood];
    }
    [self archiveCartListArray];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiCartGoodSelected object:[self getTotalGoodPrice]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshCartGoodCount object:nil];
}
- (NSMutableDictionary *)cartListArrayToHashDic{
    if (!self.cartListArray.count) {
        return nil;
    }
    NSMutableDictionary *dic = [SDCartDataManager arrayToHashDic:self.cartListArray hashKey:@"goodId"];
    return dic;
}
+ (NSMutableDictionary *)arrayToHashDic:(NSArray *)array hashKey:(NSString *)key{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (SDGoodModel *good in array) {
        if ([good valueForKey:key]) {
            [dic setObject:good forKey:[good valueForKey:key]];
        }
        
    }
    return dic;
}
- (void)updateCartGoodSeleted:(NSArray *)goods seleted:(BOOL)selectd{
    for (SDGoodModel *good in goods) {
        if (good.status.integerValue == SDCartListCellTypeNomal && !good.soldOut) {
            good.selected = [NSNumber numberWithBool:selectd];
        }
        
    }
    [self archiveCartListArray];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiCartGoodSelected object:[self getTotalGoodPrice]];
}
- (NSString *)getTotalGoodPrice{
    CGFloat total = 0;
    for (SDGoodModel *good in self.cartListArray) {
        if (good.selected.boolValue) {
            CGFloat price = good.priceActive.length ? good.priceActive.floatValue : good.price.floatValue;
            total = total + good.num.integerValue * price;
        }
    }
    return [NSString stringWithFormat:@"%.2f",total];
}
+ (NSArray *)getSelectGoodArray{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *cartList = [SDCartDataManager sharedInstance].cartListArray;
    for (SDGoodModel *good in cartList) {
        if (good.selected.boolValue) {
            SDCartOderRequestGoodModel *goodModel = [[SDCartOderRequestGoodModel alloc] init];
            goodModel.goodId = good.goodId;
            goodModel.num = good.num;
            goodModel.type = good.type;
            [array addObject:goodModel];
        }
    }
    return array;
}
+ (NSInteger )getAllCartGoodsCount{
    NSInteger total = 0;
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].cartListArray) {
//        if (good.selected.boolValue) {
            total = total + good.num.integerValue;
//        }
    }
//    return 100;
    return total;
}
+ (NSInteger )getAllPreOderGoodsCount{
    NSInteger total = 0;
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].preOrderModel.goodsInfo) {
        //        if (good.selected.boolValue) {
        total = total + good.num.integerValue;
        //        }
    }
    return total;
}
+ (NSInteger )getCartSelectGoodsCount{
    NSInteger total = 0;
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].cartListArray) {
        if (good.selected.boolValue) {
            total = total + good.num.integerValue;
        }
    }
    return total;
}
+ (BOOL )cartListGoodsAllSelected{
    if (![SDCartDataManager cartListGetNomalGoodCount]) {
        return NO;
    }
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].cartListArray){
        if (good.status.integerValue == SDCartListCellTypeNomal && (!good.selected.boolValue && !good.soldOut)) {
            return NO;
        }
    }
    return YES;
}
+ (NSInteger )cartListGetNomalGoodCount{
    NSInteger count = 0;
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].cartListArray){
        if (good.status.integerValue != SDGoodTypeGroup) {
            count = count + good.num.integerValue;
        }
    }
    return count;
}
+ (NSArray *)cartListAllNomalGood{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SDGoodModel *good in [SDCartDataManager sharedInstance].cartListArray) {
        if (good.status.integerValue == SDCartListCellTypeNomal) {
            [array addObject:good];
        }
    }
    return array;
}
#pragma mark 购物车中订单相关接口
//订单页面售完或下架的商品
- (NSArray *)remoeSoldOutGood:(NSArray *)soldOutArray{
    NSDictionary *dic = [SDCartDataManager arrayToHashDic:self.prepayModel.goods hashKey:@"goodId"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.prepayModel.goods];
    for (NSString *gooId in soldOutArray) {
        id model = [dic objectForKey:gooId];
        if (model) {
            [array removeObject:model];
        }
    }
    return array;
}
//订单页面不能送货的商品
- (NSArray *)removeExpressGood{
    NSDictionary *dic = [SDCartDataManager arrayToHashDic:self.orderExpressGoods hashKey:@"goodId"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.prepayModel.goods];
    for (NSInteger i = array.count - 1 ; i >= 0 ; i--) {
        SDGoodModel *good = [array objectAtIndex:i];
        SDGoodModel *tempGood = [dic objectForKey:good.goodId];
        if (tempGood && !tempGood.express.boolValue) {
            [array removeObject:good];
        }
    }
    return array;
}
- (NSInteger )orderExpressGoodCount{
    NSInteger count = 0;
    for (SDGoodModel *goods in self.preOrderModel.goodsInfo) {
        if (![goods.express boolValue]) {
            count = count + goods.num.integerValue;
        }
    }
    return count;
}
- (NSArray *)orderExpressGoods{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (SDGoodModel *goods in self.preOrderModel.goodsInfo) {
        if (![goods.express boolValue]) {
            [tmpArray addObject:goods];
        }
    }
    return tmpArray;
}
- (BOOL )checkOrderExpress{
    BOOL result = NO;
    for (SDGoodModel *goods in self.preOrderModel.goodsInfo) {
        if (![goods.express boolValue]) {
            result = YES;
            return result;
        }
    }
    return result;
}
- (void)setSelectRepoModel:(SDCartRepoListModel *)selectRepoModel{
    if (selectRepoModel == nil) {
        _selectRepoModel = nil;
        _prepayModel.repoId = nil;
        return;
    }
    _selectRepoModel = selectRepoModel;
    _prepayModel.repoId = _selectRepoModel.repoId;
}
- (void)setSelectAddressModel:(SDAddressModel *)selectAddressModel{
    _selectAddressModel = selectAddressModel;
    _prepayModel.userAddrId = _selectAddressModel ? _selectAddressModel.addrId : nil;
}
- (SDAddressModel *)getDefaultAddress{
    SDAddressModel *defaultAddress = nil;
    for (SDAddressModel *address in self.addressListArray) {
        if (address.is_default) {
            defaultAddress = address;
            break;
        }
    }
    if (!defaultAddress && self.addressListArray.count) {
        defaultAddress = self.addressListArray.firstObject;
    }
    return defaultAddress;
}
+ (void)cartToOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartRepoListRequest *repo = [[SDCartRepoListRequest alloc] init];
    SDGetAddrListReqeust *listRequest = [[SDGetAddrListReqeust alloc] init];
    YTKBatchRequest *batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:repo,listRequest, nil]];
    [SDToastView show];
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        NSArray *requestArray = batch.requestArray;
        
        SDCartRepoListRequest *repo = (SDCartRepoListRequest *)requestArray[0];
        SDGetAddrListReqeust *listRequest = (SDGetAddrListReqeust *)requestArray[1];
        [SDCartDataManager sharedInstance].repoListArray = repo.dataArray;
//        [SDCartDataManager sharedInstance].repoListArray = nil;//无前置仓测试
        [SDCartDataManager sharedInstance].addressListArray = listRequest.addrList;
        SDAddressModel *addreeModel = [[SDCartDataManager sharedInstance] getDefaultAddress];
        [SDCartDataManager sharedInstance].selectAddressModel = addreeModel;
        [SDCartDataManager sharedInstance].selectRepoModel = repo.dataArray.firstObject;
        
        model.userAddrId = addreeModel.addrId;
        if (![SDCartDataManager sharedInstance].repoListArray.count) {
            model.type = SDCartOrderTypeDeliveryOnly;
        }else if(![SDCartDataManager checkLocationRight]){
            [SDCartDataManager sharedInstance].selectRepoModel = nil;
        }else{
            model.type = SDCartOrderTypeDelivery;
        }
        
        [SDCartDataManager prepayNomalOrderWithOrderRequestModel:model isCartTO:YES completeBlock:^(SDCartOderModel *resposeModel){
            //1.3版本去掉alart
//            if (resposeModel.alert.count) {
//                [SDToastView HUDWithWarnString:resposeModel.alert.firstObject];
//            }
            
            if (block) {
                block(resposeModel);
            }
        } failedBlock:^(id  _Nonnull model) {
            if (failedBlock) {
                failedBlock(model);
            }
        }];
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SDToastView HUDWithErrString:@"加载数据失败"];
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
+ (void)systemGroupCartToOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartRepoListRequest *repo = [[SDCartRepoListRequest alloc] init];
    SDGetAddrListReqeust *listRequest = [[SDGetAddrListReqeust alloc] init];
    YTKBatchRequest *batch = [[YTKBatchRequest alloc] initWithRequestArray:[NSArray arrayWithObjects:repo,listRequest, nil]];
    [SDToastView show];
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        NSArray *requestArray = batch.requestArray;
        
        SDCartRepoListRequest *repo = (SDCartRepoListRequest *)requestArray[0];
        SDGetAddrListReqeust *listRequest = (SDGetAddrListReqeust *)requestArray[1];
        [SDCartDataManager sharedInstance].repoListArray = repo.dataArray;
        [SDCartDataManager sharedInstance].addressListArray = listRequest.addrList;
        SDAddressModel *addreeModel = [[SDCartDataManager sharedInstance] getDefaultAddress];
        [SDCartDataManager sharedInstance].selectAddressModel = addreeModel;
        model.userAddrId = addreeModel.addrId;
        model.type = SDCartOrderTypeSelfTakeOnly;
        [SDCartDataManager systemGroupOderWithOrderRequestModel:model completeBlock:block failedBlock:failedBlock];
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SDToastView HUDWithErrString:@"加载数据失败"];
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
+ (void)systemGroupOderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartSGOderRequest *request = [[SDCartSGOderRequest alloc] init];
    //test
//    model.goodId = @"5c529e9393869e5b1a09467c";
    //end
    request.requestModel = model;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartSGOderRequest * _Nonnull request) {
        [SDCartDataManager sharedInstance].preOrderModel = request.orderModel;
        if ([SDCartDataManager sharedInstance].prepayModel.deliveryTime.length) {
            [SDCartDataManager sharedInstance].prepayModel.deliveryTime = [NSString stringWithFormat:@"%@",request.orderModel.deliveryTime.firstObject];
        }
        if (block) {
            block(request.orderModel);
        }
    } failure:^(__kindof SDCartSGOderRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
//        [SDToastView HUDWithErrString:request.msg];
    }];
}
// 预下单接口 & 正式下单
+ (void)oderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartOderRequest *request = [[SDCartOderRequest alloc] init];
    //test
//    SDGoodModel *good = model.goods.firstObject;
//    good.goodId = @"5c529e9393869e5b1a09467c";
    //end
    request.requestModel = model;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartOderRequest * _Nonnull request) {
        [SDCartDataManager sharedInstance].preOrderModel = request.orderModel;
        if (![SDCartDataManager sharedInstance].prepayModel.deliveryTime.length) {
            [SDCartDataManager sharedInstance].prepayModel.deliveryTime = [NSString stringWithFormat:@"%@",request.orderModel.deliveryTime.firstObject];
        }
        if (block) {
            block(request.orderModel);
        }
    } failure:^(__kindof SDCartOderRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(request);
        }
    }];
}
+ (void)prepaySystemGroupOrderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    [SDCartDataManager systemGroupOderWithOrderRequestModel:model completeBlock:block failedBlock:failedBlock];
}
+ (void)prepayNomalOrderWithOrderRequestModel:(SDCartOderRequestModel *)model isCartTO:(BOOL )cartTo completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    
    [SDCartDataManager oderWithOrderRequestModel:model completeBlock:^(SDCartOderModel *model){
        
        if (block) {
            block(model);
        }
    } failedBlock:failedBlock];
}
+ (void)nomalSystemGroupOrderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    [SDCartDataManager systemGroupOderWithOrderRequestModel:model completeBlock:block failedBlock:failedBlock];
}

/** 正式下单 */
+ (void)nomalOrderWithOrderRequestModel:(SDCartOderRequestModel *)model completeBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    [SDCartDataManager oderWithOrderRequestModel:model completeBlock:block failedBlock:failedBlock];
}
//前置仓接口
+ (void)cartOrderRepoListArrayCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
    SDCartRepoListRequest *request = [[SDCartRepoListRequest alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCartRepoListRequest * _Nonnull request) {
        if (block) {
            [SDCartDataManager sharedInstance].repoListArray = request.dataArray;
            block(request.dataArray);
        }
    } failure:^(__kindof SDCartRepoListRequest * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
//地址接口
+ (void)cartOrderGetAddressListArrayCompleteBlock:(CartSuccessBlock )block failedBlock:(nonnull CartFailedBlock)failedBlock{
     SDGetAddrListReqeust *request = [[SDGetAddrListReqeust alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDGetAddrListReqeust * _Nonnull request) {
        if (block) {
            [SDCartDataManager sharedInstance].addressListArray = request.addrList;
            [SDCartDataManager sharedInstance].selectAddressModel = [[SDCartDataManager sharedInstance] getDefaultAddress];
            block(request.addrList);
        }
    } failure:^(__kindof SDGetAddrListReqeust * _Nonnull request) {
        if (failedBlock) {
            failedBlock(@"");
        }
    }];
}
+(BOOL)checkLocationRight{
    if ([SDCoordinateModel sharedInstance].longitude == 0 && [SDCoordinateModel sharedInstance].latitude == 0) {
        return NO;
    }
    return YES;
}
+ (NSString *)getLocationStr{
    if ([SDCartDataManager checkLocationRight]) {
        double lat = [SDCoordinateModel sharedInstance].latitude;
        double log = [SDCoordinateModel sharedInstance].longitude;
        
        return [NSString stringWithFormat:@"%f,%f",log,lat];
    }
    return nil;
}
//验证支付数据规则
+ (BOOL )checkPrePayData{
    SDCartOderRequestModel *model = [SDCartDataManager sharedInstance].prepayModel;
    BOOL status = YES;
    if (model.type == SDCartOrderTypeSelfTake) {
        if (!model.mobile.length) {
            status = NO;
        }
        if (!model.repoId.length || ![model.mobile isPhoneNumber]) {
            status = NO;
        }
        if ([model.receiver hasIllegalCharacter] && model.receiver.length) {
            status = NO;
        }
    }else{
        if (!model.userAddrId.length) {
            status = NO;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiOderRepayCheck object:[NSNumber numberWithBool:status]];
    return status;
}
+ (void)saveSelfTakePersonAndMobile{
    SDCartOderRequestModel *model = [SDCartDataManager sharedInstance].prepayModel;
    if (model.type == SDCartOrderTypeSelfTake) {
        if (model.mobile) {
            [[NSUserDefaults standardUserDefaults] setObject:model.mobile forKey:kOderSelfTakePhone];
        }
        if (model.receiver) {
            [[NSUserDefaults standardUserDefaults] setObject:model.receiver forKey:kOderSelfTakePerson];
        }
    }
}
+ (NSInteger )enbleVoucher{
    NSInteger i = 0;
    for (SDCouponsModel *model in [SDCartDataManager sharedInstance].preOrderModel.voucher) {
        if (model.usable) {
            i ++;
        }
    }
    return i;
}
#pragma 201错误码处理（详情，加入购物车，订单接口）
//订单页面的处理
+ (void)handlePayOrderRequestFailed:(id )model viewController:(UIViewController *)vc refreshTable:(SDCartOrderTableView *)listTableView{
    SDCartDataManager *dataMgr = [SDCartDataManager sharedInstance];
    if ([model isKindOfClass:[SDBSRequest class]]) {
        SDBSRequest *bsre = (SDBSRequest *)model;
        if (bsre.code == 201) {
            SDCartOderFailedModel *faileModel = [SDCartOderFailedModel mj_objectWithKeyValues:bsre.ret];
            if (faileModel.localCode.integerValue  == 201002 && faileModel.deliveryPrice.length) {
                [SDToastView HUDWithErrString:@"有商品价格发生变化，需要重新结算"];
                [vc.navigationController popViewControllerAnimated:YES];
                
            }else if (faileModel.remove.count && faileModel.localCode.integerValue == 450003){ //商品下架或售罄
                if (faileModel.remove.count == dataMgr.prepayModel.goods.count) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    if (faileModel.remove.count == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshGoodDetailVC object:faileModel.remove.firstObject];
                    }
                }else{
                    dataMgr.prepayModel.isPrepay = @"1";
                    dataMgr.prepayModel.prepayHash = @"";
                    dataMgr.prepayModel.goods = [dataMgr remoeSoldOutGood:faileModel.remove];
                    [listTableView refreshActionWithNoFailedFreshBlock];
                }
                
                if (faileModel.subCode.integerValue == 0) {
                    [SDToastView HUDWithErrString:@"有商品今日已抢完，需要重新结算!"];
                }else{
                    [SDToastView HUDWithErrString:@"有商品已下架，需要重新结算!"];
                }
                
            }
            return;
        }
    }
    dataMgr.prepayModel.isPrepay = @"1";
    dataMgr.prepayModel.prepayHash = @"";
}
+ (void)handlePayOrderRequestFailed:(id )model viewController:(UIViewController *)vc refreshBlock:(void(^)(void))block{
    SDCartDataManager *dataMgr = [SDCartDataManager sharedInstance];
    if ([model isKindOfClass:[SDBSRequest class]]) {
        SDBSRequest *bsre = (SDBSRequest *)model;
        if (bsre.code == 201) {
            SDCartOderFailedModel *faileModel = [SDCartOderFailedModel mj_objectWithKeyValues:bsre.ret];
            if (faileModel.localCode.integerValue  == 201002 && faileModel.deliveryPrice.length) {
                [SDToastView HUDWithErrString:@"有商品价格发生变化，需要重新结算"];
                [vc.navigationController popViewControllerAnimated:YES];
                
            }else if (faileModel.remove.count && faileModel.localCode.integerValue == 450003){ //商品下架或售罄
                if (faileModel.remove.count == dataMgr.prepayModel.goods.count) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    if (faileModel.remove.count == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshGoodDetailVC object:faileModel.remove.firstObject];
                    }
                }else{
                    dataMgr.prepayModel.isPrepay = @"1";
                    dataMgr.prepayModel.prepayHash = @"";
                    dataMgr.prepayModel.goods = [dataMgr remoeSoldOutGood:faileModel.remove];
                    if (block) {
                        block();
                    }
                }
                
                if (faileModel.subCode.integerValue == 0) {
                    [SDToastView HUDWithErrString:@"有商品今日已抢完，需要重新结算!"];
                }else{
                    [SDToastView HUDWithErrString:@"有商品已下架，需要重新结算!"];
                }
                
            }
            return;
        }
    }
    dataMgr.prepayModel.isPrepay = @"1";
    dataMgr.prepayModel.prepayHash = @"";
}
//错误code201再调起code201002专属
+ (void)handlePayOrderRequestFailedRepeat:(id )model viewController:(UIViewController *)vc refreshBlock:(void(^)(void))block{
    SDCartDataManager *dataMgr = [SDCartDataManager sharedInstance];
    if ([model isKindOfClass:[SDBSRequest class]]) {
        SDBSRequest *bsre = (SDBSRequest *)model;
        if (bsre.code == 201) {
            SDCartOderFailedModel *faileModel = [SDCartOderFailedModel mj_objectWithKeyValues:bsre.ret];
            if (faileModel.localCode.integerValue  == 201002 && faileModel.deliveryPrice.length) {
//                [SDToastView HUDWithErrString:@"有商品价格发生变化，需要重新结算"];
                [vc.navigationController popViewControllerAnimated:YES];
                
            }else if (faileModel.remove.count && faileModel.localCode.integerValue == 450003){ //商品下架或售罄
                if (faileModel.remove.count == dataMgr.prepayModel.goods.count) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    if (faileModel.remove.count == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshGoodDetailVC object:faileModel.remove.firstObject];
                    }
                }else{
                    dataMgr.prepayModel.isPrepay = @"1";
                    dataMgr.prepayModel.prepayHash = @"";
                    dataMgr.prepayModel.goods = [dataMgr remoeSoldOutGood:faileModel.remove];
                    if (block) {
                        block();
                    }
                }
                
                if (faileModel.subCode.integerValue == 0) {
                    [SDToastView HUDWithErrString:@"有商品今日已抢完，需要重新结算!"];
                }else{
                    [SDToastView HUDWithErrString:@"有商品已下架，需要重新结算!"];
                }
                
            }
            return;
        }
    }
    dataMgr.prepayModel.isPrepay = @"1";
    dataMgr.prepayModel.prepayHash = @"";
}
+ (void)handlePayOrderRequestFailedRepeat:(id )model viewController:(UIViewController *)vc refreshTable:(SDCartOrderTableView *)listTableView{
    SDCartDataManager *dataMgr = [SDCartDataManager sharedInstance];
    if ([model isKindOfClass:[SDBSRequest class]]) {
        SDBSRequest *bsre = (SDBSRequest *)model;
        if (bsre.code == 201) {
            SDCartOderFailedModel *faileModel = [SDCartOderFailedModel mj_objectWithKeyValues:bsre.ret];
            if (faileModel.localCode.integerValue  == 201002 && faileModel.deliveryPrice.length) {
//                [SDToastView HUDWithErrString:@"有商品价格发生变化，需要重新结算"];
                [vc.navigationController popViewControllerAnimated:YES];
                
            }else if (faileModel.remove.count && faileModel.localCode.integerValue == 450003){ //商品下架或售罄
                if (faileModel.remove.count == dataMgr.prepayModel.goods.count) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    if (faileModel.remove.count == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiRefreshGoodDetailVC object:faileModel.remove.firstObject];
                    }
                }else{
                    dataMgr.prepayModel.isPrepay = @"1";
                    dataMgr.prepayModel.prepayHash = @"";
                    dataMgr.prepayModel.goods = [dataMgr remoeSoldOutGood:faileModel.remove];
                    [listTableView refreshActionWithNoFailedFreshBlock];
                }
                
                if (faileModel.subCode.integerValue == 0) {
                    [SDToastView HUDWithErrString:@"有商品今日已抢完，需要重新结算!"];
                }else{
                    [SDToastView HUDWithErrString:@"有商品已下架，需要重新结算!"];
                }
                
            }
            return;
        }
    }
    dataMgr.prepayModel.isPrepay = @"1";
    dataMgr.prepayModel.prepayHash = @"";
}
//详情页处理与购物车
+ (void)handelGoodDetailRequestFailed:(id )model listTableView:(SDBaseTableView *)listTableView{
    if ([model isKindOfClass:[SDBSRequest class]]) {
        SDBSRequest *bsre = (SDBSRequest *)model;
        if (bsre.code == 201) {
            SDCartOderFailedModel *faileModel = [SDCartOderFailedModel mj_objectWithKeyValues:bsre.ret];
            if (faileModel.localCode.integerValue == 450003){ //商品下架或售罄
                if (faileModel.subCode.integerValue == 0) {
                    [SDToastView HUDWithErrString:@"该商品今日已抢完!"];
                }else{
                    [SDToastView HUDWithErrString:@"该商品已下架!"];
                }
                
            }
            [listTableView refreshAction];
        }
    }
}
+ (void)handelAddCartRequestFailed:(id )model{
    if ([model isKindOfClass:[SDBSRequest class]]) {
        SDBSRequest *bsre = (SDBSRequest *)model;
        if (bsre.code == 201) {
            SDCartOderFailedModel *faileModel = [SDCartOderFailedModel mj_objectWithKeyValues:bsre.ret];
            if (faileModel.localCode.integerValue == 450003){ //商品下架或售罄
                if (faileModel.subCode.integerValue == 0) {
                    [SDToastView HUDWithErrString:@"该商品今日已抢完!"];
                }else{
                    [SDToastView HUDWithErrString:@"该商品已下架!"];
                }
                
            }
            
        }
    }
}
@end
