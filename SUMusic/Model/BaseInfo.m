//
//  BaseInfo.m
//  NewsReader
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 KevinSu. All rights reserved.
//

#import "BaseInfo.h"

@implementation BaseInfo

+ (instancetype)infoFromDict:(NSDictionary *)dict {
    
    return [[self alloc]initWithStringDict:dict];
}

+ (NSArray *)arrayFromDict:(NSDictionary *)dict {
    
    NSArray * array = [dict objectForKey:NetSong];
    
    return [[self class] arrayFromArray:array];
}

+ (NSArray *)arrayFromArray:(NSArray *)array {
    
    NSMutableArray * infos = [NSMutableArray array];
    
    for (NSDictionary * dict in array) {
        [infos addObject:[[self class] infoFromDict:dict]];
    }
    
    if (infos.count == 0) {
        infos = nil;
    }
    
    return infos;
}

@end
