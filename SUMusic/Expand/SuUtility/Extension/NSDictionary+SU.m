//
//  NSDictionary+SuExt.m
//  NewsReader
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 KevinSu. All rights reserved.
//

#import "NSDictionary+SU.h"

@implementation NSDictionary (SU)

- (NSString *)getObjectFromKey:(NSString *)key {
    
    NSString * obj = [self valueForKey:key];
    
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@",obj];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

    if(err) {

        return nil;
    }
    
    return dic;
}

#if 0
- (NSString *)descriptionWithLocale:(id)locale
{
    // 在iOS中，如果数据包含在数组或者字典中，直接打印看不到结果，所以需要重写此方法，修正此BUG
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [strM appendString:@"}"];
    return strM;
}
#endif

@end
