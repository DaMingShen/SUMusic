//
//  FxGlobal.m
//  FxHejinbo
//
//  Created by hejinbo on 15/5/12.
//  Copyright (c) 2015年 MyCos. All rights reserved.
//

#import "SuGlobal.h"

@implementation SuGlobal

#pragma mark - 用户是否已经登陆
+ (BOOL)checkLogin {
    
    return [SuAppSetting getBool:UserLogin];
}

+ (void)setLoginStatus:(BOOL)status {
    
    [SuAppSetting setBool:status forKey:UserLogin];
}

#pragma mark - APP是否刚启动
+ (BOOL)checkLauch {
    
    return ![SuAppSetting getBool:UserLauch];
}

+ (void)setLauchStatus:(BOOL)status {
    
    [SuAppSetting setBool:!status forKey:UserLauch];
}

#pragma mark - APP是否第一次打开
+ (BOOL)checkFirstOpenAPP {
    
    return ![SuAppSetting getBool:isFirstOpen];
}

+ (void)setFirstOpenStatus:(BOOL)status {
    
    [SuAppSetting setBool:!status forKey:isFirstOpen];
}

#pragma mark - 是否使用流量收听
+ (BOOL)checkFlowUsable {
    
    return [SuAppSetting getBool:isFlowUsable];
}

+ (void)setFlowUsableStatus:(BOOL)status {
    
    [SuAppSetting setBool:status forKey:isFlowUsable];
}


#pragma mark - 缓存路径

+ (NSString *)getRootPath {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:RootPath];
    [SuFile createPath:path];
    return path;
}

+ (NSString *)getArchiverFile {
    NSString *path = [[SuGlobal getRootPath] stringByAppendingPathComponent:ArchiverFile];
    return path;
}

+ (NSString *)getUserDBFile {
    NSString *path = [SuGlobal getRootPath];
    return [path stringByAppendingPathComponent:DBFile];
}

+ (NSString *)getOffLinePath {
    NSString *path = [[SuGlobal getRootPath] stringByAppendingPathComponent:OffLineFile];
    [SuFile createPath:path];
    return path;
}

+ (NSString *)getOffLineFilePath {
    NSString *path = [[SuGlobal getOffLinePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[AppDelegate delegate].player.currentSong.sid,@".mp4"]];
    BASE_INFO_FUN(path);
    return path;
}


#pragma mark - 系统提示

+ (void)alertMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
}

#pragma mark - 可收听验证
+ (BOOL)checkNetworkEnable {
    
    if (![[SuNetworkMonitor monitor] isNetworkEnable]) {
        [TopAlertView showWithType:TopAlertTypeBan message:@"网络不可用"];
        return NO;
    }
    
    if (![[SuNetworkMonitor monitor] isWiFiEnable] && ![SuGlobal checkFlowUsable]) {
        [TopAlertView showWithType:TopAlertTypeBan message:@"不能使用流量收听"];
        return NO;
    }
    
    return YES;
}


@end
