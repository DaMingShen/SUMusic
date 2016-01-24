//
//  SuDBManager.m
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import "SuDBManager.h"
#import "SuDBManager+private.h"

#define UserInfoTable @"UserInfo"

@implementation SuDBManager

+ (void)saveUserInfoDict:(NSDictionary *)dict {
    
//    NSString * path = [WZGlobal getUserDBFile];
//    BASE_INFO_FUN(path);
//    NSString * mobile = [SuAppSetting getValue:UserID];
//    NSString * jsonStr = [SuJsonStringTool dictionaryToJsonStr:dict];
//    NSDictionary * dictContent = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",jsonStr,@"userInfo", nil];
//    [SuDBManager save:dictContent primaryKey:@"mobile" inTable:UserInfoTable inDBFile:path];
    
}

+ (NSDictionary *)fetchUserInfoDict {
    
//    NSString * path = [WZGlobal getUserDBFile];
//    NSString * mobile = [SuAppSetting getValue:UserID];
//    NSDictionary * dictCondiction = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile", nil];
//    NSArray * result = [SuDBManager fetchWithCondition:dictCondiction forFields:@[@"mobile", @"userInfo"] inTable:UserInfoTable inDBFile:path];
//    if (result.count > 0) {
//        
//        NSDictionary * rsDict = result[0];
//        NSString * jsonStr = rsDict[@"userInfo"];
//        return [SuJsonStringTool jsonStringToDictionary:jsonStr];
//    }
    return nil;
}

@end
