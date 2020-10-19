//
//  SDBSRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDBSRequest : YTKRequest

@property (nonatomic, strong, readonly) NSString *msg;

@property (nonatomic, assign, readonly) NSInteger code;

@property (nonatomic, copy, readonly) NSString *alert;

@property (nonatomic, strong, readonly) id ret;

@property (nonatomic ,assign) BOOL noFaildAlterShow;
@property (nonatomic, assign) BOOL nodissMissHud;
- (NSString*)bs_requestUrl;

@end

NS_ASSUME_NONNULL_END
