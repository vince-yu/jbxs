//
//  SDGoodDetailModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SDGoodShareInfo : NSObject
@property (nonatomic ,copy) NSString *begin;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *end;
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic ,copy) NSString *miniProgmId;
@property (nonatomic ,copy) NSString *miniProgmPath;
@property (nonatomic ,copy) NSString *picUrl;
@end

@interface SDGoodDetailModel : NSObject
@property (nonatomic ,copy) NSString *goodId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSString *priceActive;
@property (nonatomic ,copy) NSString *spec;
@property (nonatomic ,strong) NSArray *tags;
@property (nonatomic ,copy) NSString *sold;
@property (nonatomic ,strong) NSDictionary *attr;
@property (nonatomic ,strong) NSArray *banner;
@property (nonatomic ,strong) NSArray *rule;
@property (nonatomic ,strong) NSArray *detail;
@property (nonatomic ,strong) NSArray *priceLadder;
@property (nonatomic ,copy) NSString *rate;
@property (nonatomic ,copy) NSString *endTime;
@property (nonatomic ,strong) NSDictionary *shareInfo;
@property (nonatomic ,copy) NSString *subName;
@property (nonatomic ,strong) NSArray *recommend;
@property (nonatomic ,copy) NSString *discount;
@property (nonatomic ,copy) NSString *limitPerUser;
@property (nonatomic ,strong) NSArray *couponArray;
@property (nonatomic ,copy) NSString *rebateRate;
@property (nonatomic ,copy) NSString *startTime;
@property (nonatomic ,copy) NSString *totalInventory;
//活动开始提醒
@property (nonatomic ,copy) NSString *remind;
//到货开始提醒
@property (nonatomic ,copy) NSString *goodsremind;
@property (nonatomic ,copy) NSString *currentTime;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *brokerage;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *miniPic;
@property (nonatomic ,copy) NSString *groupId;
@property (nonatomic ,copy) NSString *obtainVoucherMsg;
//是否已售完
@property (nonatomic ,assign) BOOL soldOut;
//赋值属性，小程序二维码
@property (nonatomic ,strong) UIImage *miniQRImage;
//额外属性(由于商品详情列表是组合接口,201是判定为正常返回，下架商品为201，status为nil)
@property (nonatomic ,assign) NSInteger code;
@end

NS_ASSUME_NONNULL_END
