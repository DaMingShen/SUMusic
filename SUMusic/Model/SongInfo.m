//
//  SongInfo.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SongInfo.h"

@implementation SongInfo

+ (instancetype)infoFromDict:(NSDictionary *)dict {
    SongInfo * info = [[self alloc]initWithStringDict:dict];
    info.jsonString = [SuString dictionaryToJson:dict];
    return info;
}

@end

@implementation Singers

@end



