//
//  BaseInfo.h
//  NewsReader
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfo : NSObject

#pragma mark - 数据解析
//从字典获取modol实例
+ (instancetype)infoFromDict:(NSDictionary *)dict;

//从字典获取model数组
+ (NSArray *)arrayFromDict:(NSDictionary *)dict;

//从字典数组获取model数组
+ (NSArray *)arrayFromArray:(NSArray *)array;




@end
