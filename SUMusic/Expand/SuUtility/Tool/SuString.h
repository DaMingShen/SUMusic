//
//  SuString.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuString : NSObject

/*
 * 对字符串进行URL编码转换
 */
+ (NSString *)urlEncodeCovertString:(NSString *)source;

/*
 * 将字典转换为JSON字典
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/*
 * 将字典数组转换为JSON数组
 */
+ (NSString *)dictionaryArrayToJsonArray:(NSArray<NSDictionary *> *)dicArray;


/*
 * 将字符串转换为
 */
+ (void)convertString:(NSString *)source toHexBytes:(unsigned char *)hexBuffer;

/*
 * 将当前时间转换为时间戳字符串：since 1970，如@"1369118167"
 */
+ (NSString *)intervalFromNowTime;

/*
 * 删除中文输入法下的空格
 */
+ (NSString *)deleteChinesSpace:(NSString *)sourceText;

/*
 * 转化为字符串类型
 */
+ (NSString *)stringFromObject:(id)obj;

/*
 * 将URL的查询字符串放入字典中如：http://..?userName=name&password=password
 * 将查询字符串userName=name&password=password 放入字典
 */
+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

/*
 * 将unicode码转成普通文字.(\u6790)
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeString;

@end
