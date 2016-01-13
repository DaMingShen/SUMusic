//
//  SuAppSetting.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuAppSetting : NSObject

/*
 从UserDefault取值
 */
+ (BOOL)getBool:(NSString *)key;

/*
 存值到UserDefault
 */
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

/*
 从UserDefault取值
 */
+ (NSString *)getValue:(NSString *)key;

/*
 存值到UserDefault
 */
+ (void)setValue:(id)value forKey:(NSString *)key;

@end
