//
//  SDNetConfig.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDNetConfig : NSObject

@property (nonatomic, assign) SeverType type;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *htmlUrl;

+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
