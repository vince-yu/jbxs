//
//  SDGoodModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCartCalculateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodModel : NSObject
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *tabId;
@property (nonatomic ,copy) NSString *miniPic;
@property (nonatomic ,copy) NSString *sold;
@property (nonatomic ,strong) NSArray *tags;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSString *priceActive;
/** 1:普通商品 2:拼团商品 3:折扣商品 4:秒杀商品 */
@property (nonatomic ,copy) NSString *type; 
@property (nonatomic ,copy) NSString *groupId;
@property (nonatomic ,copy) NSString *endTime;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic, copy) NSString *beyond;
@property (nonatomic ,copy) NSString *status; //
@property (nonatomic ,strong) NSNumber *selected;
@property (nonatomic ,copy) NSString *dataId;
@property (nonatomic ,copy) NSString *spec;
@property (nonatomic, copy) NSString *subhead;
@property (nonatomic ,copy) NSString *startTime;
@property (nonatomic ,copy) NSString *totalInventory;
@property (nonatomic ,copy) NSString *discount;
@property (nonatomic ,copy) NSString *rebateRate;
@property (nonatomic ,copy) NSString *currentTime;
@property (nonatomic ,copy) NSString *limitPerUser;

/** 超限标识 [user:超用户限购 goods:超商品限购] */
@property (nonatomic, copy) NSString *limiting;
//是否支持快递 1支持 0不支持
@property (nonatomic ,copy) NSString *express;
//秒杀商品 算价model
@property (nonatomic ,strong) SDCartCalculateMoreModel *moreModel;

//售罄标识 [1:售罄 0:未售罄]
@property (nonatomic, assign) BOOL soldOut;
///** ------------ 额外属性 --------------- */
//@property (nonatomic, copy) NSAttributedString *showPrice;
//@property (nonatomic, copy) NSAttributedString *showPriceActive;
/** 计算cell高度 */
@property (nonatomic, assign) CGFloat contentH;



@end

NS_ASSUME_NONNULL_END
