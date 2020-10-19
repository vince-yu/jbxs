//
//  SDNomalDBModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDNomalDBModel : NSObject
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *section;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic ,copy) NSString *json;
@property (nonatomic ,strong) NSDate *createTime;

@end

NS_ASSUME_NONNULL_END
