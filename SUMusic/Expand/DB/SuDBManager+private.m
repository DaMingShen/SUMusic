//
//  SuDBManager+private.m
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import "SuDBManager+private.h"
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>

@implementation SuDBManager (private)

//otherFields:表字段名称，不包含主键,统一为TEXT数据类型


/**
 *  将内容存储到指定数据库的表中
 *
 *  @param dictContent 要存储的内容(包含主键)
 *  @param primaryKey  表主键,不能为nil
 *  @param tableName   表名称
 *  @param dbFile      数据库文件，路径+文件名
 */
+ (void)save:(NSDictionary *)dictContent
  primaryKey:(NSString *)primaryKey
     inTable:(NSString *)tableName
    inDBFile:(NSString *)dbFile {
    
    if (dictContent == nil) {
        
        NSLog(@"保存内容不能为空");
        return;
    }
    
    if (primaryKey.length <= 0) {
        
        NSLog(@"表主键不能为空");
        return;
    }
    
    if (!tableName) {
        
        NSLog(@"表名称不能为空");
        return;
    }
    
    if (!dbFile) {
        
        NSLog(@"数据库名称不能为空");
        return;
    }
    
    //多线程操作数据库，需要使用FMDatabaseQueue来保证线程安全
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSMutableString * fields = [[NSMutableString alloc]init]; //字段的名称
        NSMutableString * values = [[NSMutableString alloc]init]; //字段的值
        
        //加入主键
        [fields appendFormat:@"%@ TEXT PRIMARY KEY", primaryKey];
        [values appendFormat:@"%@", dictContent[primaryKey]];
        
        //加入其他字段及值
        for (NSString * key in dictContent) {
            
            if ([key isEqualToString:primaryKey]) continue;
            
            [fields appendFormat:@", %@ TEXT", key];
            [values appendFormat:@", '%@'", [dictContent objectForKey:key]];
        }
        
        //创建或打开表格
        NSString * tableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", tableName, fields];
        if ([db executeUpdate:tableSql]) {
            
            NSString * insertSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES (%@)", tableName, values];
            if ([db executeUpdate:insertSql]) {
                
                NSLog(@"%@ 创建或插入数据成功", tableName);
                
            }else {
                
                NSLog(@"%@ 创建或插入数据错误", tableName);
            }
            
        }else {
            
            NSLog(@"%@ 创建或插入数据错误", tableName);
        }
        
    }];
    
    [queue close];
}

/**
 *  读取指定的内容
 *
 *  @param dictCondition 条件关键字，格式为：｛字段：值｝
 *  @param fields        查询的字段，格式为字符串数组
 *  @param tableName     表名称
 *  @param dbFile        数据库文件，路径+文件名
 *
 *  @return 结果数组，包含字典，字典格式为：｛字段：值｝
 */
+ (NSArray *)fetchWithCondition:(NSDictionary *)dictCondition
                      forFields:(NSArray *)fields
                        inTable:(NSString *)tableName
                       inDBFile:(NSString *)dbFile {
    //结果数组
    NSMutableArray * contents = [[NSMutableArray alloc] init];
    
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSMutableString * sql = [[NSMutableString alloc]init];
        [sql appendFormat:@"SELECT * FROM %@", tableName];
        
        NSInteger index = 0;
        for (NSString * key in dictCondition) {
            
            if (index == 0) {
                
                [sql appendString:@" WHERE "];
            }else {
                
                [sql appendString:@" AND "];
            }
            
            if ([dictCondition objectForKey:key]) {
                
                [sql appendFormat:@"%@ = '%@'", key, [dictCondition objectForKey:key]];
            }else {
                
                [sql appendFormat:@"%@ = %@", key, [dictCondition objectForKey:key]];
            }
            
            index ++;
        }
        
        FMResultSet * set = [db executeQuery:sql];
        while (set.next) {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            for (NSString * key in fields) {
                
                [dict setObject:[set stringForColumn:key] forKey:key];
            }
            [contents addObject:dict];
        }
        
        
    }];
    
    [queue close];
    
    return contents;
}


/**
 *  删除指定的内容
 *
 *  @param dictCondition 条件关键字，格式为：｛字段：值｝
 *  @param tableName     表名称
 *  @param dbFile        数据库文件，路径+文件名
 */
+ (void)deleteWithCondition:(NSDictionary *)dictCondition
                    inTable:(NSString *)tableName
                   inDBFile:(NSString *)dbFile {
    
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSMutableString * sql = [[NSMutableString alloc]init];
        [sql appendFormat:@"DELETE FROM %@", tableName];
        
        NSInteger index = 0;
        for (NSString * key in dictCondition) {
            
            if (index == 0) {
                
                [sql appendString:@" WHERE "];
            }else {
                
                [sql appendString:@" AND "];
            }
            
            if ([dictCondition objectForKey:key]) {
                
                [sql appendFormat:@"%@ = '%@'", key, [dictCondition objectForKey:key]];
            }else {
                
                [sql appendFormat:@"%@ = %@", key, [dictCondition objectForKey:key]];
            }
            
            index ++;
        }
        
        if ([db executeUpdate:sql]) {
            
            NSLog(@"%@ 删除数据成功", tableName);
        }else {
            
            NSLog(@"%@ 删除数据错误", tableName);
        }
        
    }];
    
    [queue close];
}



@end
