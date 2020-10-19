//
//  SDCouponsModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SDCouponsDisplayTypeNone, // 普通展示 右侧无控件
    SDCouponsDisplayTypeRadioBox, // 右侧是单选框
    SDCouponsDisplayTypeUseButton // 右侧是去使用按钮
} SDCouponsDisplayType;

@interface SDCouponsModel : NSObject

@property (nonatomic, copy) NSString *couponsId;
/** 券类型[1:满减券 2:现金券(无门槛券) 3:折扣券 4:运费抵扣券] 自定义5：拉新券*/
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *day;
/** 优惠金额 元 */
@property (nonatomic, copy) NSString *amount;
/** 张数 */
@property (nonatomic, assign) int num;
/** 满减券 至少满足的金额 元 type=2 */
@property (nonatomic, copy) NSString *least;
/** 开始时间 */
@property (nonatomic, copy) NSString *startTime;
/** 过期时间 */
@property (nonatomic, copy) NSString *expireTime;
/** 用于显示的有效期 */
@property (nonatomic, copy) NSString *rangeTime;
/** 折扣 type=3 */
@property (nonatomic, copy) NSString *discount;
/** 用法 */
@property (nonatomic, copy) NSString *usage;
/** 短描述 */
@property (nonatomic, copy) NSString *title;
/** 是否被使用 */
@property (nonatomic, assign, getter=isUsed) BOOL used;
/** 是否可用 */
@property (nonatomic, assign) BOOL usable;
/** 是否获得 */
@property (nonatomic, assign) BOOL notObtain;

//"type":1,                //类型：Number  必有字段  备注：券类型[1:满减券 2:现金券(无门槛券) 3:折扣券 4:运费抵扣券]
//"day":7,                //类型：Number  必有字段  备注：无
//"amount":7,                //类型：Number  可有字段  备注：优惠金额 元
//"num":1,                //类型：Number  必有字段  备注：张数
//"least":10,                //类型：Number  可有字段  备注：满减券 至少满足的金额 元 type=2
//"start_time":1551169819000,                //类型：Number  必有字段  备注：无
//"expire_time":1551169819000,                //类型：Number  必有字段  备注：无
//"range_time":"2019.01.01-2019.01.07",                //类型：String  必有字段  备注：无
//"discount":"0-98",                //类型：String  可有字段  备注：折扣 type=3
//"usage":"mock"                //类型：String  必有字段  备注：用法

/* -------------- 额外属性 --------------------- */
@property (nonatomic, assign) SDCouponsDisplayType displayType;
/** 是否互斥 页面置灰 显示底部页面  */
@property (nonatomic, assign, getter=isMutex) BOOL mutex;


@end

NS_ASSUME_NONNULL_END
