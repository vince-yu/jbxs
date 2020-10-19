//
//  SDGrouperFriendListRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/6/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDGrouperFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGrouperFriendListRequest : SDBSRequest
@property (nonatomic ,copy) NSString *page;
@property (nonatomic ,copy) NSString *limit;

@property (nonatomic ,strong) SDGrouperFriendListModel *listModel;
@end

NS_ASSUME_NONNULL_END
