//
//  UITextField+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SU)

/**
 添加文件输入框左边的View,添加图片
 */
-(void)addLeftViewWithImage:(NSString *)image;

/**
 * 判断是否为手机号码
 */
-(BOOL)isTelphoneNum;

@end
