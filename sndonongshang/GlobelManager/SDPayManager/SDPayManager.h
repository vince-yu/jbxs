//
//  SDPayManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/7.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWeChatPayModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface SDPayManager : NSObject
+ (instancetype)sharedInstance;

/**
 微信支付
 */
- (void)wechatPayWithModel:(SDWeChatPayModel *)model;
/**
支付宝支付
*/
- (void)alipayPayWithOrderStr:(NSString *)orderStr;
@end

NS_ASSUME_NONNULL_END
