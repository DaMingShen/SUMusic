//
//  UIColor+SuExt.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "UIColor+SU.h"

@implementation UIColor (SU)

+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString
{
    
    if ([hexRGBString hasPrefix:@"#"]) {
        
        hexRGBString = [hexRGBString substringFromIndex:1];
    }
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (hexRGBString) {
        NSScanner *scanner = [NSScanner scannerWithString:hexRGBString];
        [scanner scanHexInt:&colorCode];
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    
    return [UIColor colorWithRed:(float)redByte/0xff green:(float)greenByte/0xff blue:(float)blueByte/0xff alpha:1.0];
}

@end
