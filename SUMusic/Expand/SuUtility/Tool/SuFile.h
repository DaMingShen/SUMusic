//
//  SuFile.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuFile : NSObject

/**
 *功能: 判断文件或文件夹是否已存在
 *参数:
 filePath: 文件或文件夹的全路径
 *返回:
 TRUE : 已经存在
 FALSE: 不存在
 **/
+ (BOOL)isFileExist:(NSString *)filePath;

/**
 *功能: 创建目录
 *参数:
 filePath: 文件或文件夹的全路径；不存在就自动创建
 *返回:
 TRUE : 已经存在或不存在就创建
 FALSE: 创建失败
 **/
+ (BOOL)createPath:(NSString *)filePath;

/**
 *功能: 重命名文件
 TRUE : 成功
 FALSE: 创建失败
 **/
+ (BOOL)renameFile:(NSString *)filePath toFile:(NSString *)toPath;

/**
 *功能: 删除文件或文件夹
 *参数:
 filePath: 文件或文件夹的全路径
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)deleteFile:(NSString *)filePath;

/**
 *功能: 将文件或文件夹从一个目录拷贝到另一个目录
 *参数:
 fromPath   : 原始目录,如/Library/11
 toPath     : 目标目录,如/Documents/11
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)copyFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath
           isReplace:(BOOL)isReplace;

/**
 *功能: 将文件夹中的内容拷贝到另一个目录中,
 *参数:
 fromPath   : 原始目录,如/Library/11,其中有1.jpg
 toPath     : 目标目录,如/Documents/,执行成功后,/Documents/1.jpg
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)copyContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath
                   isReplace:(BOOL)isReplace;


/**
 *功能: 将文件或文件夹从一个目录移动到另一个目录
 *参数:
 fromPath   : 原始目录,如/Library/11
 toPath     : 目标目录,如/Documents/11
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)moveFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath
           isReplace:(BOOL)isReplace;

/**
 *功能: 将文件夹中的内容移动到另一个目录中,
 *参数:
 fromPath   : 原始目录,如/Library/11,其中有1.jpg
 toPath     : 目标目录,如/Documents/,执行成功后,/Documents/1.jpg
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)moveContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath
                   isReplace:(BOOL)isReplace;

/**
 *功能: 计算一个文件或文件夹大小,
 *参数:
 filePath   : 文件或文件夹路径
 *返回: 文件或文件夹所占字节数
 **/
+ (double)calculteFileSzie:(NSString *)filePath;

/**
 *功能: 计算一个文件夹大小,该方法效率更高
 *参数:
 filePath   : 文件或文件夹路径
 *返回: 文件或文件夹所占字节数
 **/
+ (double)calculteFileSzieEx:(NSString *)filePath;


/**
 *功能：递归删除某个目录下的指定文件
 **/
+ (void)deleteFiles:(NSArray *)fileNames inPath:(NSString *)path;

@end
