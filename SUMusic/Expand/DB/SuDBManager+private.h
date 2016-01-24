//
//  SuDBManager+private.h
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import "SuDBManager.h"

@interface SuDBManager (private)

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
inDBFile:(NSString *)dbFile;

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
inDBFile:(NSString *)dbFile;

/**
 *  删除指定的内容
 *
 *  @param dictCondition 条件关键字，格式为：｛字段：值｝
 *  @param tableName     表名称
 *  @param dbFile        数据库文件，路径+文件名
 */
+ (void)deleteWithCondition:(NSDictionary *)dictCondition
inTable:(NSString *)tableName
inDBFile:(NSString *)dbFile;



@end
