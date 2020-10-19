//
//  SDWeChatLoginRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDWeChatLoginRequest : SDBSRequest

@property (nonatomic, copy) NSString *wechatCode;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
