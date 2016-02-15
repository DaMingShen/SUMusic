//
//  FxGlobal.h
//  FxHejinbo
//
//  Created by hejinbo on 15/5/12.
//  Copyright (c) 2015年 MyCos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuGlobal : NSObject

/*
 * 用户是否已登陆
 */
+ (BOOL)checkLogin;
+ (void)setLoginStatus:(BOOL)status;

/*
 * APP是否刚启动
 */
+ (BOOL)checkLauch;
+ (void)setLauchStatus:(BOOL)status;

/*
 * APP是否第一次打开
 */
+ (BOOL)checkFirstOpenAPP;
+ (void)setFirstOpenStatus:(BOOL)status;

/*
 * 是否使用流量收听
 */
+ (BOOL)checkFlowUsable;
+ (void)setFlowUsableStatus:(BOOL)status;

// 缓存路径
+ (NSString *)getRootPath;
+ (NSString *)getArchiverFile;
+ (NSString *)getUserDBFile;
+ (NSString *)getOffLinePath;
+ (NSString *)getOffLineFilePath;

// 系统提示
+ (void)alertMessage:(NSString *)message;

#pragma mark - 可收听验证
+ (BOOL)checkNetworkEnable;

@end
