//
//  NSObject+SSS.h
//  SSSJsonModel
//
//  Created by KevinSu on 15/12/16.
//  Copyright © 2015年 SuXiaoMing. All rights reserved.
//

/*
 * SSSJsonModel  苏晓明
 *
 * 1、功能：将Json转化成Model
 * 2、使用：
 (处理空值为空字符串) TestModel * model = [[TestModel alloc]initWithDictionary:dict dealNull:YES];
 (不处理空值)  TestModel * info = [[TestModel alloc]initWithDictionary:dict];
 *
 * 3、目前进度：
 
 (1)普通Json 可以处理所有类型的值
 (2)嵌套其他类型的Json 可以处理所有类型的值
 (3)嵌套数组的Json 完成
 (4)自定义值映射 完成
 
 
 
 * 4、局限性和待改进
 
 (1)处理空值为空字符串功能只适用于属性类型为NSString类型, 其他类型例如number类型等等初始化需要加判断，待完善
 (2)Json嵌套其他类型且为其值NSNull类型或者nil时 处理待优化
 (3)
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */


#import <Foundation/Foundation.h>

@interface NSObject (SSS)

/*
 *  是否对model做不为空处理
 */
@property (nonatomic, strong) NSNumber * sssNoNull;

/*
 *  体贴入微带处理将Json转化成Model
 */
- (id)initWithDictionary:(NSDictionary *)dict dealNull:(BOOL)isDeal;

/*
 *  原汁原味不带处理将Json转化成Model
 */
- (id)initWithDictionary:(NSDictionary *)dict;

@end
