//
//  SuAppSetting.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuAppSetting.h"

@implementation SuAppSetting

+ (BOOL)getBool:(NSString *)key {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    return [userDef boolForKey:key];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setBool:value forKey:key];
    [userDef synchronize];
}


+ (NSString *)getValue:(NSString *)key
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    return [userDef objectForKey:key];
}

+ (void)setValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setObject:value forKey:key];
    [userDef synchronize];
}

@end
