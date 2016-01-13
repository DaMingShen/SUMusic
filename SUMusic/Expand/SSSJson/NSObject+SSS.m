//
//  NSObject+SSS.m
//  SSSJsonModel
//
//  Created by KevinSu on 15/12/16.
//  Copyright © 2015年 SuXiaoMing. All rights reserved.
//

#import "NSObject+SSS.h"
#import <objc/runtime.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define SSSERROR @"SSSJsonModel错误: %@"

@implementation NSObject (SSS)

- (NSNumber *)sssNoNull {
    
    return objc_getAssociatedObject(self, @selector(sssNoNull));
}

- (void)setSssNoNull:(NSNumber *)sssNoNull {
    
    objc_setAssociatedObject(self, @selector(sssNoNull), sssNoNull, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 带处理的JsonModel
- (id)initWithDictionary:(NSDictionary *)dict dealNull:(BOOL)isDeal{
    
    self.sssNoNull = [NSNumber numberWithBool:isDeal];
    return [self initWithDictionary:dict];
}

#pragma mark - 不带处理的JsonModel
- (id)initWithDictionary:(NSDictionary *)dict {
    
    //验证dict是否有传入
    if (!dict) {
        NSLog(SSSERROR, @"传入的dict为空");
        return nil;
    }
    
    //验证传入的dict类型
    if (![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(SSSERROR, @"传入的参数不是NSDictionary类型");
        return nil;
    }
    
    //初始化
    self = [self init];
    
    //初始化失败
    if (!self) {
        NSLog(SSSERROR, @"初始化失败");
        return nil;
    }
    
    //KVC赋值
    [self setValueWithDictionary:dict];
    
    return self;
}

#pragma mark - 获取类的属性及属性对应的类型
/*
 * 获取类的属性
 */
- (NSArray<NSString *> *)propertyKeys {
    
    NSMutableArray * keys = [NSMutableArray array];
    
    //获取类的属性列表
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    /*
     * 例子
     * name = value3 attribute = T@"NSString",C,N,V_value3
     name = value4 attribute = T^i,N,V_value4
     */
    //通过property_getName函数获得属性的名字
    //通过property_getAttributes函数可以获得属性的名字和@encode编码
    for (int i = 0; i < outCount; i ++) {
        
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    
    //立即释放properties指向的内存
    free(properties);
    return keys;
}

/*
 * 获取类的属性类型
 */
- (NSArray<NSString *> *)propertyAttributes {
    
    NSMutableArray * attributes = [NSMutableArray array];
    
    //获取类的属性列表
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    /*
     * 例子
     * name = value3 attribute = T@"NSString",C,N,V_value3
     name = value4 attribute = T^i,N,V_value4
     */
    //通过property_getName函数获得属性的名字
    //通过property_getAttributes函数可以获得属性的名字和@encode编码
    for (int i = 0; i < outCount; i ++) {
        
        objc_property_t property = properties[i];
        NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//        NSLog(@"propertyAttribute = %@",propertyAttribute);
        [attributes addObject:propertyAttribute];
    }
    
    //立即释放properties指向的内存
    free(properties);
    return attributes;
}

#pragma mark - 获取类名并创建实例
/*
 *  从属性的类型中获取类名
 */
- (NSString *)getClassNameWithAttribute:(NSString *)attribute {
    
    //T@"NSString",C,N,V_value3
    //干掉前面字符
    NSString * className = [attribute substringFromIndex:[attribute rangeOfString:@"\""].location + 1];
    //干掉后面字符
    className = [className substringToIndex:[className rangeOfString:@"\""].location];
    
    return className;
}

/*
 *  获取类型的实例并赋值
 */
- (id)createInstance:(NSString *)className withDictionary:(NSDictionary *)dict{
    
    id instance = [NSClassFromString(className) alloc];
    
    //判断调用的方法
    NSString * method = @"unTouchedInstanceWithDictionary:";
    
    if (self.sssNoNull.boolValue) method = @"nonullInstanceWithDictionary:";
    
    //判断是否实现该方法
    if ([instance respondsToSelector:NSSelectorFromString(method)]) {
        
        //忽略performSelector may cause a leak警告
        SuppressPerformSelectorLeakWarning(
                                           
                                           [instance performSelector:NSSelectorFromString(method) withObject:dict];
                                           );
    }
    
    return instance;
}

#pragma mark - 判断是否为基本数据类型
- (BOOL)iselementaryDataType:(NSString *)attribute {
    
    if ([attribute hasPrefix:@"T@"]) return NO;
    
    return YES;
}




#pragma mark - 核心方法: JsonModel转化
- (void)setValueWithDictionary:(id)dict {
    
    //字段名
    NSArray * keys = [self propertyKeys];
    //字段属性名
    NSArray * attributes = [self propertyAttributes];
    //自定义字段映射
    NSDictionary * keysMapping = [self performSelector:@selector(customFieldsMapping)];
//    if (keysMapping) NSLog(@"keysMapping = %@",keysMapping);
    
    //判断每个key对应的值，如果有则赋值
    for (int i = 0; i < keys.count; i ++) {
        
        //取出key
        NSString * key = keys[i];
        
        //获取key对应的值
        id value = [dict valueForKey:key];;
        
        //验证自定义key的有效性
        if (keysMapping) {
            
            id customKey = [keysMapping valueForKey:key];
            if (customKey && [customKey isKindOfClass:[NSString class]]) value = [dict valueForKey:customKey];
        }
        
        //判断值是否为空, 为空则不赋值, 跳过
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            
            //判断是否需要设置空值
            if (!self.sssNoNull.boolValue) continue;
            
            //如果不是基本数据类型则初始化的值
            if (![self iselementaryDataType:attributes[i]]) {
                
                 NSString * className = [self getClassNameWithAttribute:attributes[i]];
                value = [[NSClassFromString(className) alloc]init];
//                NSLog(@"handle className = %@ value = %@", className, value);
                
            //如果是基本数据类型则跳过
            }else {
                
                continue;
            }
//            NSString * className = [self getClassNameWithAttribute:attributes[i]];
//            if (className && [className isEqualToString:@"NSString"]) value = @"";
        }
        
        //判断值是否为Dictionary类型，是则继续解析
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            //取出key对应的类型
            NSString * className = attributes[i];
            
            //创建实例
            value = [self createInstance:[self getClassNameWithAttribute:className] withDictionary:value];
        }
        
        //判断值是否为NSArray类型，是则继续解析
        if ([value isKindOfClass:[NSArray class]]) {
            
            //判断是否有定义对应的数组解析类型
            if ([self respondsToSelector:@selector(arrayAndClassMapping)]) {
                
                NSDictionary * mapDict = [self performSelector:@selector(arrayAndClassMapping)];
//                NSLog(@"mapDict = %@",mapDict);
                
                //获取数组对应的类名
                NSString * className = [mapDict valueForKey:key];
//                NSLog(@"className = %@",className);
                
                //有则继续解析
                if (className) {
                    
                    NSMutableArray * modelArray = [NSMutableArray array];
                    //遍历数组转化
                    for (NSDictionary * dict in value) {
                        
                        id obj = [self createInstance:className withDictionary:dict];
                        [modelArray addObject:obj];
                    }
                    value = modelArray;
                }
                //无则存储字典数组
            }
            
        }
        
        //赋值
        [self setValue:value forKey:key];
    
    }
}


#pragma mark - 创建数组&类的映射
- (NSDictionary *)arrayAndClassMapping {
    
//    return @{@"array":@"MyTest"};
    return nil;
}

#pragma mark - 创建自定义字段的映射
- (NSDictionary *)customFieldsMapping {
    
//    return @{@"name":@"id"};
    return nil;
}


@end
