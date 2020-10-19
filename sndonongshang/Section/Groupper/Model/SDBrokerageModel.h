//
//  SDBrokerageModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDBrokerageModel : NSObject
/** 可提现 总佣金 元 */
@property (nonatomic, copy) NSString *brokerage;
/** 今天总佣金 元 */
@property (nonatomic, copy) NSString *todayBrokerage;
/** 今天拉新佣金 元 */
@property (nonatomic, copy) NSString *todayBrokerageInvite;
/** 今天商品佣金 元 */
@property (nonatomic, copy) NSString *todayBrokerageGoods;
/** 昨日总佣金 元 */
@property (nonatomic, copy) NSString *yesterdayBrokerage;
/**昨日拉新佣金 元 */
@property (nonatomic, copy) NSString *yesterdayBrokerageInvite;
/** 昨日商品佣金 元 */
@property (nonatomic, copy) NSString *yesterdayBrokerageGoods;
/** 冻结佣金 元 */
@property (nonatomic, copy) NSString *freezeBrokerage;
/** 今日拉新人数 */
@property (nonatomic, copy) NSString *todayFriends;

/** 今日拉新人数 */
@property (nonatomic, copy) NSString *yesterdayFriends;

/** 额外属性 */
@property (nonatomic, copy) NSMutableAttributedString *todayBrokerageInviteAttr;
@property (nonatomic, copy) NSMutableAttributedString *todayBrokerageGoodsAttr;
@property (nonatomic, copy) NSMutableAttributedString *yesterdayBrokerageInviteAttr;
@property (nonatomic, copy) NSMutableAttributedString *yesterdayBrokerageGoodsAttr;

@end
NS_ASSUME_NONNULL_END
