//
//  SDCheckUserRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCheckUserRequest : SDBSRequest

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL exists;
@property (nonatomic, assign) BOOL password;

@end

NS_ASSUME_NONNULL_END
