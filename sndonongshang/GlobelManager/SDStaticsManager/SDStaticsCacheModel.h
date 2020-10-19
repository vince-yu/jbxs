//
//  SDStaticsCacheModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/21.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDStaticsCacheModel : NSObject<WCTTableCoding>
@property (nonatomic, copy) NSString  *type;
@property (nonatomic, copy) NSString  *json;

WCDB_PROPERTY(type)
WCDB_PROPERTY(json)
@end

NS_ASSUME_NONNULL_END
