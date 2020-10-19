//
//  SDCartListModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCartListModel : NSObject
@property (nonatomic ,copy) NSString *cartId;
@property (nonatomic ,copy) NSString *cartSum;
@property (nonatomic ,strong) NSArray *goods;
@end

NS_ASSUME_NONNULL_END
