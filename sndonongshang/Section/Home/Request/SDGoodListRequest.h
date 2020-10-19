//
//  SDGoodListRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDGoodListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodListRequest : SDBSRequest
@property (nonatomic ,strong) SDGoodListModel *listModel;
@property (nonatomic ,copy) NSString *tabId;
@property (nonatomic ,copy) NSString *limit;
@property (nonatomic ,copy) NSString *page;
@end

NS_ASSUME_NONNULL_END
