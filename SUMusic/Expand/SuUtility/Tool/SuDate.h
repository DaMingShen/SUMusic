//
//  SuDate.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuDate : NSObject 

/*
 日期-字符串转换函数
 */
//年月日转换：2015-10-30
+ (NSString *)stringFromDateYMD:(NSDate *)date;
+ (NSDate *)dateFromStringYMD:(NSString *)dateString;

//年月日星期时分：2015-10-30 星期四 10:20
+ (NSString *)stringFromDateYMDEHM:(NSDate *)date;
+ (NSDate *)dateFromStringYMDEHM:(NSString *)dateString;

//年月日时分秒：2015-10-30 10:10:10
+ (NSString *)stringFromDateYMDHMS:(NSDate *)date;
+ (NSDate *)dateFromStringYMDHMS:(NSString *)dateString;

//获取年、月、日
+ (NSString *)getYear:(NSDate *)date;
+ (NSString *)getMonth:(NSDate *)date;
+ (NSString *)getDay:(NSDate *)date;

@end
