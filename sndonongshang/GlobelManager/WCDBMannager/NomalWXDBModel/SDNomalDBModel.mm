//
//  SDNomalDBModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDNomalDBModel.h"
#import <WCDB/WCDB.h>

@implementation SDNomalDBModel
WCDB_IMPLEMENTATION(SDNomalDBModel)

WCDB_SYNTHESIZE(SDNomalDBModel, userId)
WCDB_SYNTHESIZE(SDNomalDBModel, section)
WCDB_SYNTHESIZE(SDNomalDBModel, url)
WCDB_SYNTHESIZE(SDNomalDBModel, json)
WCDB_SYNTHESIZE(SDNomalDBModel, createTime)

// 约束宏定义数据库的主键
WCDB_PRIMARY(SDNomalDBModel, userId)
// 定义数据库的索引属性，它直接定义createTime字段为索引
// 同时 WCDB 会将表名 + "_index" 作为该索引的名称
WCDB_INDEX(SDNomalDBModel, "_index", createTime)

@end
