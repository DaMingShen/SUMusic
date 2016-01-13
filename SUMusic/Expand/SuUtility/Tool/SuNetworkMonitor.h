//
//  SuNetwork.h
//  WanZhongLife
//
//  Created by 万众科技 on 15/11/26.
//  Copyright © 2015年 com.revenco.company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuNetworkMonitor : NSObject

+ (instancetype)manager;

- (void)startMonitorNetwork;

+ (BOOL)isNetworkEnabled;


@end
