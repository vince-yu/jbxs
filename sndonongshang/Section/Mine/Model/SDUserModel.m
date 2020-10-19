//
//  SDUserModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDUserModel.h"
#import "SDAddressModel.h"

@implementation SDUserModel

static dispatch_once_t onceToken;
static SDUserModel *instance = nil;

+ (instancetype)sharedInstance{
//    static SDUserModel *instance = nil;
    dispatch_once(&onceToken, ^{
        SNDOLOG(@"用户单例对象创建");
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)dealloc {
    SNDOLOG(@"用户单例对象 释放");
}

+ (void)destroyInstance {
    SNDOLOG(@"用户单例对象 销毁");
    onceToken = 0;
    instance = nil;
}
- (BOOL)isLogin {
    NSString *token =  [[NSUserDefaults standardUserDefaults] stringForKey:KToken];
    return token.isNotEmpty;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId":@"_id",
             @"brokerageInvite":@"brokerage_invite",
             @"brokerageGoods":@"brokerage_goods",
             @"isRegiment":@"is_regiment",
             @"regimentApply":@"regiment_apply"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"addr" : @"SDAddressModel"};
}

- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KToken];
}

- (NSString *)getToken {
    NSString *token =  [[NSUserDefaults standardUserDefaults] stringForKey:KToken];
    return token;
}

//- (void)setIsRegiment:(BOOL)isRegiment {
//    _isRegiment = 1;
//}

@end
