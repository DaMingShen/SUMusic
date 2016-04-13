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

/*
- (NSNumber *)dealNull {
    
    return objc_getAssociatedObject(self, @selector(dealNull));
}

- (void)setDealNull:(NSNumber *)dealNull {
    
    objc_setAssociatedObject(self, @selector(dealNull), dealNull, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
*/

/*
 *  将Json转化成Model(全部解析成字符串)
 */
- (_Nullable id)initWithStringDict:(NSDictionary * _Nonnull )dict {
    return [self initWithDict:dict dealNull:YES];
}

/*
 *  将Json转化成Model(对空值不作处理)
 */
- (_Nullable id)initWithOriginalDict:( NSDictionary * _Nonnull )dict {
    return [self initWithDict:dict dealNull:NO];
}

/*
 *  将Json转化成Model(对空值不作处理)
 */
- (_Nullable id)initWithDict:( NSDictionary * _Nonnull )dict dealNull:(BOOL)dealNull {
    
    if (self = [self init]) {
        
//(1)获取类的属性及属性对应的类型
        NSMutableArray * keys = [NSMutableArray array];
        NSMutableArray * attributes = [NSMutableArray array];
        /*
         * 例子
         * name = value3 attribute = T@"NSString",C,N,V_value3
         * name = value4 attribute = T^i,N,V_value4
         */
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            //通过property_getAttributes函数可以获得属性的名字和@encode编码
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        //立即释放properties指向的内存
        free(properties);
        
//(2)核心方法：根据类型给属性赋值
        
        //自定义字段映射
        NSDictionary * keysMapping = [self performSelector:@selector(customFieldsMapping)];
        
        //判断每个key对应的值，如果有则赋值
        for (int i = 0; i < keys.count; i ++) {
            
            //获取key对应的值
            NSString * key = keys[i];
            id value = [dict valueForKey:key];;
            
            //验证自定义key的有效性
            if (keysMapping) {
                NSString * customKey = [keysMapping valueForKey:key];
                if (customKey) value = [dict valueForKey:customKey];
            }
            
            //非自定义类和数组时：
            if (![value isKindOfClass:[NSDictionary class]] && ![value isKindOfClass:[NSArray class]]) {
                if (dealNull) {
                    //统一转成字符串
                    value = [NSString stringWithFormat:@"%@",(value == nil || [value isKindOfClass:[NSNull class]]) ? @"" : value];
                }else {
                    //为空时跳过不处理
                    if (value == nil || [value isKindOfClass:[NSNull class]]) continue;
                    //不为空时，则取得model该属性的类型，如果不是该类型则转化
                    //。。。。待完善
                }
            }
            
            //自定义类时：
            if ([value isKindOfClass:[NSDictionary class]]) {
                //取出key对应的类型
                NSString * className = attributes[i];
                //创建实例
                value = [self createInstance:[self getClassNameWithAttribute:className] withDictionary:value dealNull:dealNull];
            }
            
            //数组时：
            if ([value isKindOfClass:[NSArray class]]) {
                //判断是否有定义对应的数组解析类型
                if ([self respondsToSelector:@selector(arrayAndClassMapping)]) {
                    NSDictionary * mapDict = [self performSelector:@selector(arrayAndClassMapping)];
                    //获取数组对应的类名
                    NSString * className = [mapDict valueForKey:key];
                    //有则继续解析
                    if (className) {
                        NSMutableArray * modelArray = [NSMutableArray array];
                        //遍历数组转化
                        for (NSDictionary * dict in value) {
                            
                            id obj = [self createInstance:className withDictionary:dict dealNull:dealNull];
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
    return self;
}

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
- (id)createInstance:(NSString *)className withDictionary:(NSDictionary *)dict dealNull:(BOOL)dealNull {
    
    id instance = [NSClassFromString(className) alloc];
    
    //判断调用的方法
    NSString * method = dealNull ? @"initWithStringDict:" : @"initWithOriginalDict:";
    
    //判断是否实现该方法
    if ([instance respondsToSelector:NSSelectorFromString(method)]) {
        
        //忽略performSelector may cause a leak警告
        SuppressPerformSelectorLeakWarning(
                                           
                                           [instance performSelector:NSSelectorFromString(method) withObject:dict];
                                           );
    }
    return instance;
}

#pragma mark - 映射方法（可重写）
/*
 *  创建数组&类的映射
 */
- (NSDictionary *)arrayAndClassMapping {
    
//    return @{@"array":@"MyTest"};
    return nil;
}
/*
 *  创建自定义字段的映射
 */
- (NSDictionary *)customFieldsMapping {
    
//    return @{@"name":@"id"};
    return nil;
}


@end
