//
//  SDWXDBManager.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDWXDBManager.h"
#import "SDNomalDBModel.h"
#import "SDNomalDBModel+DataTable.h"
#import <WCDB/WCDB.h>

static NSString *const kDataTableName = @"nomalDataTable";

@interface SDWXDBManager (){
    WCTDatabase *_database;
}
@end

@implementation SDWXDBManager
+ (instancetype)manager{
    static SDWXDBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDWXDBManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _database = [[WCTDatabase alloc] initWithPath:[[self class] dbFilePath]];
    }
    return self;
}
+ (NSString *)dbFilePath{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"SNDONS.sqlite"];
    NSLog(@"path = %@",filePath);
    return filePath;
}
//创建表单
- (BOOL )creatDataTableInDB{
    //测试数据库是否能够打开
    if ([_database canOpen]) {
        // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
        // 先判断表是不是已经存在
        if ([_database isOpened]) {
            if ([_database isTableExists:kDataTableName]) {
                SNDOLOG(@"banner表已经存在");
                return NO;
            }else{
                BOOL result =  [_database createTableAndIndexesOfName:kDataTableName withClass:SDNomalDBModel.class];
                SNDOLOG(@"创建banner表");
                return result;
            }
        }
    }
    return NO;
}
//插入数据
- (BOOL )insertNomalModel:(SDNomalDBModel *)model{
    if (model == nil) {
        return NO;
    }
    BOOL result = [_database insertObject:model into:kDataTableName];
    return result;
}
//查找所有数据
- (NSArray<SDNomalDBModel *> *)getAllNomalModels
{
    return [_database getAllObjectsOfClass:SDNomalDBModel.class fromTable:kDataTableName];
}
//删所有数据
- (BOOL)deleteAllNomalModels
{
    BOOL result = [_database deleteAllObjectsFromTable:kDataTableName];
    return result;
}
- (BOOL )updateNomalModel:(SDNomalDBModel *)model onProperty:(NSArray *)array{
    if (model == nil) {
        return NO;
    }
    BOOL result = [_database updateAllRowsInTable:kDataTableName onProperties:{SDNomalDBModel.userId,SDNomalDBModel.url} withObject:model];
    return result;
}
@end
