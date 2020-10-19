//
//  SDGoodModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodModel.h"

@implementation SDGoodModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodId":@"_id",
             @"priceActive":@"price_active",
             @"groupId":@"group_id",
             @"endTime":@"end_time",
             @"miniPic":@"mini_pic",
             @"dataId":@"data_id",
             @"totalInventory":@"total_inventory",
             @"startTime":@"start_time",
             @"rebateRate":@"rebate_rate",
             @"currentTime":@"current_time",
             @"limitPerUser":@"limit_per_user",
             @"soldOut":@"sold_out"
             };
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.goodId forKey:@"goodId"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.tabId forKey:@"tabId"];
    [coder encodeObject:self.miniPic forKey:@"miniPic"];
    [coder encodeObject:self.sold forKey:@"sold"];
    [coder encodeObject:self.tags forKey:@"tags"];
    [coder encodeObject:self.price forKey:@"price"];
    [coder encodeObject:self.priceActive forKey:@"priceActive"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.groupId forKey:@"groupId"];
    [coder encodeObject:self.endTime forKey:@"endTime"];
    [coder encodeObject:self.num forKey:@"num"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.selected forKey:@"selected"];
    [coder encodeObject:self.spec forKey:@"spec"];
    [coder encodeObject:self.beyond forKey:@"beyond"];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.goodId = [coder decodeObjectForKey:@"goodId"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.tabId = [coder decodeObjectForKey:@"tabId"];
        self.miniPic = [coder decodeObjectForKey:@"miniPic"];
        self.sold = [coder decodeObjectForKey:@"sold"];
        self.tags = [coder decodeObjectForKey:@"tags"];
        self.price = [coder decodeObjectForKey:@"price"];
        self.priceActive = [coder decodeObjectForKey:@"priceActive"];
        self.type = [coder decodeObjectForKey:@"type"];
        self.groupId = [coder decodeObjectForKey:@"groupId"];
        self.endTime = [coder decodeObjectForKey:@"endTime"];
        self.num = [coder decodeObjectForKey:@"num"];
        self.status = [coder decodeObjectForKey:@"status"];
        self.selected = [coder decodeObjectForKey:@"selected"];
        self.spec = [coder decodeObjectForKey:@"spec"];
        self.beyond = [coder decodeObjectForKey:@"beyond"];
    }
    return self;
}

- (void)setMiniPic:(NSString *)miniPic {
    if ([miniPic hasPrefix:@"http://"] || [miniPic hasPrefix:@"https://"]) {
        _miniPic = miniPic;
    }else {
        NSString *baseUrl = [SDNetConfig sharedInstance].baseUrl;
        NSString *picStr = [NSString stringWithFormat:@"%@%@", baseUrl, miniPic];
        _miniPic = picStr;
    }
}

- (CGFloat)contentH {
    if (!_contentH) {
        _contentH += 15;
        CGFloat shopNameH = [self.name sizeWithFont:[UIFont fontWithName:kSDPFBoldFont size:14] maxSize:CGSizeMake(SCREEN_WIDTH - 100 - 30, 42)].height;
        _contentH += shopNameH;
        
        if ([self.type isEqualToString:@"4"] && [self.beyond intValue] > 0) { // 秒杀 并且数量超过最大购买量
            if (self.beyond.intValue == self.num.intValue && [self.limiting isEqualToString:@"goods"]) {
                _contentH += 10 + 14; // 标签高度
                CGFloat priceH = 11;
                _contentH += priceH + 10; // 原价高度
            }else {
                CGFloat priceH = 14;
                _contentH += 10 + priceH + 8 + priceH;
            }
        }else {
            if (self.tags && self.tags.count > 0) {
                _contentH += 10 + 14;
            }

            CGFloat priceH = 11;
            if ([self.priceActive isNotEmpty]) {
                CGFloat priceActiveH = 14;
                _contentH += 10 + priceActiveH + 4 + priceH;
            }else {
                _contentH += priceH + 10;
            }
        }
        
        _contentH += 15;
        _contentH += 0.5;
        _contentH = MAX(_contentH, 105.5);
    }
    return _contentH;
}

@end
