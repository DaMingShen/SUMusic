//
//  UIColor+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SU)

/*由16进制字符串获取颜色*/
+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString;

@end
