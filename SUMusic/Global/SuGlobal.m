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
    
    return [SuAppSetting getBool:isLogin];
}

+ (void)setLoginStatus:(BOOL)status {
    
    [SuAppSetting setBool:status forKey:isLogin];
}

#pragma mark - APP是否刚启动
+ (BOOL)checkLauch {
    
    return ![SuAppSetting getBool:isLauch];
}

+ (void)setLauchStatus:(BOOL)status {
    
    [SuAppSetting setBool:!status forKey:isLauch];
}

#pragma mark - APP是否第一次打开
+ (BOOL)checkFirstOpenAPP {
    
    return ![SuAppSetting getBool:isFirstOpen];
}

+ (void)setFirstOpenStatus:(BOOL)status {
    
    [SuAppSetting setBool:!status forKey:isFirstOpen];
}


#pragma mark - 缓存路径

+ (NSString *)getRootPath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:RootPath];
    [SuFile createPath:path];
    
    return path;
}

+ (NSString *)getArchiverFile;
{
    NSString *path = [[SuGlobal getRootPath] stringByAppendingPathComponent:ArchiverFile];
    return path;
}

+ (NSString *)getUserDBFile
{
    NSString *path = [SuGlobal getRootPath];
    return [path stringByAppendingPathComponent:DBFile];
}

+ (BOOL)setNotBackUp:(NSString *)filePath
{
    NSError *error = nil;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSNumber *attrValue = [NSNumber numberWithBool:YES];
    
    [fileURL setResourceValue:attrValue
                       forKey:NSURLIsExcludedFromBackupKey
                        error:&error];
    if (error!=nil) {
        BASE_ERROR_FUN([error localizedDescription]);
        return NO;
    }
    
    return YES;
}


#pragma mark - 系统提示

+ (void)alertMessage:(NSString *)message
{
    [SuGlobal alertMessageEx:message
                       title:nil
                    okTtitle:@"确定"
                 cancelTitle:nil
                    delegate:nil];
}

+ (void)alertMessageEx:(NSString *)message
                 title:(NSString *)title
              okTtitle:(NSString *)okTitle
           cancelTitle:(NSString *)cancelTitle
              delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:delegate
                              cancelButtonTitle:cancelTitle
                              otherButtonTitles:okTitle,
                              nil];
    
    [alertView show];
}

@end
