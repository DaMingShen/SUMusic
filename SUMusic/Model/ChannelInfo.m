//
//  ChannelInfo.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ChannelInfo.h"

@implementation ChannelInfo

+ (instancetype)infoFromDict:(NSDictionary *)dict {
    ChannelInfo * info = [[self alloc]initWithStringDict:dict];
    info.jsonString = [SuString dictionaryToJson:dict];
    return info;
}

@end
