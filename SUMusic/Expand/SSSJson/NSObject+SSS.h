//
//  NSObject+SSS.h
//  SSSJsonModel
//
//  Created by KevinSu on 15/12/16.
//  Copyright © 2015年 SuXiaoMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SSS)

/*
 *  将Json转化成Model(全部解析成字符串)
 */
- (_Nullable id)initWithStringDict:(NSDictionary * _Nonnull )dict;

/*
 *  将Json转化成Model(对空值不作处理)
 */
- (_Nullable id)initWithOriginalDict:( NSDictionary * _Nonnull )dict;

@end
