//
//  SuNetwork.h
//  WanZhongLife
//
//  Created by 万众科技 on 15/11/26.
//  Copyright © 2015年 com.revenco.company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuNetworkMonitor : NSObject

+ (instancetype)monitor;

/**
 *  开启网络状态的监听
 */
- (void)startMonitorNetwork;

- (BOOL)isWiFiEnable;

- (BOOL)isNetworkEnable;


@end
