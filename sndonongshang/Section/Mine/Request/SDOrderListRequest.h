//
//  SDOrderListRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDOrderListRequest : SDBSRequest
@property (nonatomic ,copy) NSString *limit;
@property (nonatomic ,copy) NSString *page; //分页参数 从1开始 page与skip二选一
@property (nonatomic ,copy) NSString *status; //[全部:1 待付款:2 待收货:3 已完成:4]
@property (nonatomic ,copy) NSString *role;

//@property (nonatomic ,strong) SDOrderListModel *listModel;
@property (nonatomic, strong) NSArray *listModel;
@end

NS_ASSUME_NONNULL_END
