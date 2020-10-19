//
//  SDNomalDBModel+dataTable.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDNomalDBModel.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDNomalDBModel (DataTable)<WCTTableCoding>

WCDB_PROPERTY(userId)
WCDB_PROPERTY(section)
WCDB_PROPERTY(url)
WCDB_PROPERTY(json)
WCDB_PROPERTY(createTime)

@end

NS_ASSUME_NONNULL_END
