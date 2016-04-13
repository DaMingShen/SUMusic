//
//  SuNetwork.m
//  WanZhongLife
//
//  Created by 万众科技 on 15/11/26.
//  Copyright © 2015年 com.revenco.company. All rights reserved.
//

#import "SuNetworkMonitor.h"
#import <Reachability.h>

@interface SuNetworkMonitor () {
    
    Reachability * _reachability;
}

@end

@implementation SuNetworkMonitor


+ (instancetype)monitor {
    
    static SuNetworkMonitor * monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        monitor = [[SuNetworkMonitor alloc]init];
    });
    return monitor;
}

/**
 *  开启网络状态的监听
 */
- (void)startMonitorNetwork {
    
    RegisterNotify(kReachabilityChangedNotification, @selector(reachabilityChanged:))
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    [AppDelegate delegate].networkStatus = _reachability.currentReachabilityStatus;
}


- (void)reachabilityChanged:(NSNotification *)notice {
    
    NetworkStatus status = _reachability.currentReachabilityStatus;
    switch (status) {
        case NotReachable:
            BASE_INFO_FUN(@"无连接");
            break;
        case ReachableViaWiFi:
            BASE_INFO_FUN(@"WiFi连接");
            break;
        case ReachableViaWWAN:
            BASE_INFO_FUN(@"数据网络");
            break;
        default:
            break;
    }
    [AppDelegate delegate].networkStatus = status;
}


- (BOOL)isWiFiEnable {
    
    return _reachability.currentReachabilityStatus == ReachableViaWiFi;
}

- (BOOL)isNetworkEnable {
    
    return _reachability.currentReachabilityStatus != NotReachable;
}




@end
