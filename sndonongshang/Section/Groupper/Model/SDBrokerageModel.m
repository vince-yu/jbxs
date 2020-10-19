//
//  SDBrokerageModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBrokerageModel.h"

@implementation SDBrokerageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"todayBrokerage":@"today_brokerage",
             @"todayBrokerageInvite":@"today_brokerage_invite",
             @"todayBrokerageGoods":@"today_brokerage_goods",
             @"yesterdayBrokerage":@"yesterday_brokerage",
             @"yesterdayBrokerageInvite":@"yesterday_brokerage_invite",
             @"yesterdayBrokerageGoods":@"yesterday_brokerage_goods",
             @"freezeBrokerage":@"freeze_brokerage",
             @"yesterdayFriends":@"yesterday_friends",
             @"todayFriends":@"today_friends"
             };
}


- (void)setTodayBrokerageInvite:(NSString *)todayBrokerageInvite {
    _todayBrokerageInvite = todayBrokerageInvite;
    self.todayBrokerageInviteAttr = [self setupAttributedString:[_todayBrokerageInvite priceStr]];
}

- (void)setTodayBrokerageGoods:(NSString *)todayBrokerageGoods {
    _todayBrokerageGoods = todayBrokerageGoods;
    self.todayBrokerageGoodsAttr = [self setupAttributedString:[_todayBrokerageGoods priceStr]];
}

- (void)setYesterdayBrokerageInvite:(NSString *)yesterdayBrokerageInvite {
    _yesterdayBrokerageInvite = yesterdayBrokerageInvite;
    self.yesterdayBrokerageInviteAttr = [self setupAttributedString:[_yesterdayBrokerageInvite priceStr]];
}

- (void)setYesterdayBrokerageGoods:(NSString *)yesterdayBrokerageGoods {
    _yesterdayBrokerageGoods = yesterdayBrokerageGoods;
    self.yesterdayBrokerageGoodsAttr = [self setupAttributedString:[_yesterdayBrokerageGoods priceStr]];
}

- (NSMutableAttributedString *)setupAttributedString:(NSString *)text {
    text = [NSString stringWithFormat:@"￥%@", text];
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    textAttr.yy_font = [UIFont fontWithName:kSDPFBoldFont size:20];
    textAttr.yy_color = [UIColor colorWithRGB:0x131413];
    [textAttr yy_setFont:[UIFont fontWithName:kSDPFMediumFont size:14] range:NSMakeRange(0, 1)];
    return textAttr;
 }

@end
