//
//  NSDictionary+SuExt.h
//  NewsReader
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SU)


/*
 * 从字典取值，并转化成字符串
 * nil和null值判断，返回空字符串
 */
- (NSString *)getObjectFromKey:(NSString *)key;


/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
