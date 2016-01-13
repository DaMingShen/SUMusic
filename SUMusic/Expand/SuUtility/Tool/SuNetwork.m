//
//  SuNetwork.m
//  WanZhongLife
//
//  Created by 万众科技 on 15/11/26.
//  Copyright © 2015年 com.revenco.company. All rights reserved.
//

#import "SuNetwork.h"

@interface SuNetwork ()<UIAlertViewDelegate> {
    
    AFNetworkReachabilityManager * _networkManager;
    UIAlertView * _alertView;
}

@end

@implementation SuNetwork


+ (instancetype)manager {
    
    static SuNetwork * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SuNetwork alloc]init];
    });
    return manager;
}

/**
 *  用AFNetWroking的方法做网络状态的监听
 */
- (void)startMonitorNetwork {
    
    _networkManager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    [_networkManager startMonitoring];
    RegisterNotify(AFNetworkingReachabilityDidChangeNotification, @selector(reachabilityChanged:));
}


- (void)reachabilityChanged:(NSNotification *)notice {
    
    //移动数据
    if (_networkManager.reachableViaWWAN == YES) {
        
        BASE_INFO_FUN(@"移动数据");
        
        if (_alertView) [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        
//        [[[UIAlertView alloc]initWithTitle:nil message:@"当前处于移动数据网络下\n请注意您的流量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    //Wi-Fi
    else if (_networkManager.reachableViaWiFi) {
        
        BASE_INFO_FUN(@"Wi-Fi");
        
        if (_alertView) [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    //无网络
    else {
        
        BASE_INFO_FUN(@"无网络");
        
        //如果当前有显示，则不再继续显示
        if (_alertView) return;
        
        if (Is_iOS_8_Later) {
            
            _alertView = [[UIAlertView alloc]initWithTitle:nil message:@"当前没有网络\n请检查您的网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"设置", nil];
            
        }else {
            
            _alertView = [[UIAlertView alloc]initWithTitle:nil message:@"当前没有网络\n请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
        
        [_alertView show];
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex) {
        
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];  //跳转到系统设置
//        NSURL * url = [NSURL URLWithString:@"prefs:root=WIFI"];  //跳转到系统WiFi设置
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    _alertView = nil;
}


+ (BOOL)isNetworkEnabled {
    
    BOOL isEnabled = FALSE;
    NSString *url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    
    isEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    
    CFRelease(ref);
    if (isEnabled) {
        //        kSCNetworkReachabilityFlagsReachable：能够连接网络
        //        kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
        //        kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        isEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
//        NSLog(@"判断网络状态：%d",isEnabled ?YES:NO);
    }
    
    return isEnabled;
}


@end
