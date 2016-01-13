//
//  SuDate.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuDate.h"

#define YMDFormat       @"YYYY-MM-dd"
#define YMDEHMFormat    @"YYYY-MM-dd EEE HH:mm"
#define YMDHMSFormat    @"YYYY-MM-dd HH:mm:ss"

static NSDateFormatter *s_formatterYMD = nil;
static NSDateFormatter *s_formatterYMDEHM = nil;
static NSDateFormatter *s_formatterYMDHMS = nil;

@implementation SuDate 

+ (NSString *)stringFromDate:(NSDate *)date
                    formater:(NSDateFormatter * __strong *)formatter
                      format:(NSString *)format
{
    if (*formatter == nil) {
        *formatter = [[NSDateFormatter alloc] init];
        
        [*formatter setLocale:[NSLocale  currentLocale]];
        [*formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [*formatter setDateStyle:NSDateFormatterMediumStyle];
        [*formatter setTimeStyle:NSDateFormatterShortStyle];
        [*formatter setDateFormat:format];
    }
    
    return [*formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString
                  formater:(NSDateFormatter * __strong *)formatter
                    format:(NSString *)format
{
    if (dateString.length <= 0) {
        return [NSDate date];
    }
    if (*formatter == nil) {
        *formatter = [[NSDateFormatter alloc] init];
        
        [*formatter setLocale:[NSLocale  currentLocale]];
        [*formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [*formatter setDateStyle:NSDateFormatterMediumStyle];
        [*formatter setTimeStyle:NSDateFormatterShortStyle];
        [*formatter setDateFormat:format];
    }
    
    return [*formatter dateFromString:dateString];
}


+ (NSString *)stringFromDateYMD:(NSDate *)date
{
    return [SuDate stringFromDate:date formater:&s_formatterYMD format:YMDFormat];
}

+ (NSDate *)dateFromStringYMD:(NSString *)dateString
{
    return [SuDate dateFromString:dateString formater:&s_formatterYMD format:YMDFormat];
}

+ (NSString *)stringFromDateYMDEHM:(NSDate *)date
{
    return [SuDate stringFromDate:date formater:&s_formatterYMDEHM format:YMDEHMFormat];
}

+ (NSDate *)dateFromStringYMDEHM:(NSString *)dateString
{
    return [SuDate dateFromString:dateString formater:&s_formatterYMDEHM format:YMDEHMFormat];
}

+ (NSString *)stringFromDateYMDHMS:(NSDate *)date
{
    return [SuDate stringFromDate:date formater:&s_formatterYMDHMS format:YMDHMSFormat];
}

+ (NSDate *)dateFromStringYMDHMS:(NSString *)dateString
{
    return [SuDate dateFromString:dateString formater:&s_formatterYMDHMS format:YMDHMSFormat];
}

+ (NSString *)getYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    
    /*
     // 年月日获得
     comps = [calendar components:NSYearCalendarUnit  | NSMonthCalendarUnit |
     NSDayCalendarUnit
     fromDate:date];
     */
    comps = [calendar components:NSYearCalendarUnit fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%@", @([comps year])];
    
    return year;
}

+ (NSString *)getMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSMonthCalendarUnit fromDate:date];
    NSString *month = [NSString stringWithFormat:@"%@", @([comps month])];
    
    return month;
}

+ (NSString *)getDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:
             NSDayCalendarUnit fromDate:date];
    NSString *day = [NSString stringWithFormat:@"%@", @([comps day])];
    
    return day;
}

@end
