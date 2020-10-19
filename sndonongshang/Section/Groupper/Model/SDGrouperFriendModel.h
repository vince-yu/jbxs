//
//  SDGrouperFriendModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/6/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDGrouperFriendListModel : NSObject
@property (nonatomic ,copy) NSArray *list;
@property (nonatomic ,copy) NSString *count;
@end

@interface SDGrouperFriendModel : NSObject
@property (nonatomic ,copy) NSString *friendId;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,copy) NSString *mobile;
@property (nonatomic ,copy) NSString *header;
@property (nonatomic ,copy) NSString *rank;
@end

NS_ASSUME_NONNULL_END
