//
//  SDCartDeleteRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCartDeleteRequest : SDBSRequest
@property(nonatomic ,copy) NSString *goodId;
@end

NS_ASSUME_NONNULL_END
