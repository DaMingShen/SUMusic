//
//  SuViewTool.h
//  WanZhongLife
//
//  Created by 万众科技 on 15/11/10.
//  Copyright © 2015年 com.revenco.company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuViewTool : NSObject
/*
 * 显示消息
 */
- (void)ToastMessage:(NSString *)message;

/*
 * 获取当前控制器
 */
+ (UIViewController *)getCurrentVC;




@end
