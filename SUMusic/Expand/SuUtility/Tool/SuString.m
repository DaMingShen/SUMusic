//
//  SuString.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuString.h"

@implementation SuString

static char fxTwoCharToHex(char a, char b)
{
    char encoder[3] = {0,0,0};
    
    encoder[0] = a;
    encoder[1] = b;
    
    return (char) strtol(encoder,NULL,16);
}

+ (NSString *)urlEncodeCovertString:(NSString *)source
{
    if (source==nil) {
        return @"";
    }
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[source mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8));
    
    return result;
}

/*
 * 将字典转换为JSON
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/*
 * 将字典数组转换为JSON数组
 */
+ (NSString *)dictionaryArrayToJsonArray:(NSArray<NSDictionary *> *)dicArray {
    //1. 初始化可变字符串，存放最终生成json字串
    NSMutableString * jsonString = [[NSMutableString alloc]initWithString:@"["];
    //2. 遍历数组，取出键值对并按json格式存放
    for (NSDictionary * dict in dicArray) {
        
        NSString * dictJson = [NSString stringWithFormat:@"%@,",[SuString dictionaryToJson:dict]];
        [jsonString appendString:dictJson];
    }
    // 3. 获取末尾逗号所在位置
    NSRange range = NSMakeRange(jsonString.length - 1, 1);
    // 4. 将末尾逗号换成结束的]
    [jsonString replaceCharactersInRange:range withString:@"]"];
    return jsonString;
}



+ (void)convertString:(NSString *)source toHexBytes:(unsigned char *)hexBuffer
{
    const char * bytes = [source cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char * index = hexBuffer;
    
    while ((*bytes) && (*(bytes +1))) {
        *index = fxTwoCharToHex(*bytes, *(bytes + 1));
        
        ++index;
        bytes += 2;
    }
    
    *index = 0;
}

+ (NSString *)intervalFromNowTime
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", (long)interval];
}

+ (NSString *)deleteChinesSpace:(NSString *)sourceText
{
    return [sourceText stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString *)stringFromObject:(id)obj
{
    NSString *ret = nil;
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        ret = [NSString stringWithFormat:@"%ld", [obj longValue]];
    }
    else {
        ret = obj;
    }
    
    return ret;
}

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(key && value)
                [dict setObject:value forKey:key];
        }
    }
    
    return dict;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeString
{
    NSString *tempStr1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization
                           propertyListFromData:tempData
                           mutabilityOption:NSPropertyListImmutable
                           format:NULL
                           errorDescription:NULL
                           ];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
