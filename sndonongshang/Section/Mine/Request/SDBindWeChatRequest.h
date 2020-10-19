//
//  SDBindWeChatRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBindWeChatRequest : SDBSRequest

@property (nonatomic, copy) NSString *wechatCode;

@end

NS_ASSUME_NONNULL_END
