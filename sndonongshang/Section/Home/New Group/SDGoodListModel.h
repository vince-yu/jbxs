//
//  SDGoodListModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDGoodListModel : NSObject
@property (nonatomic ,copy) NSString *tabId;
@property (nonatomic ,copy) NSString *page;
@property (nonatomic ,copy) NSString *count;
@property (nonatomic ,strong) NSArray *data;
@end

NS_ASSUME_NONNULL_END
