//
//  SuNav.h
//  LazyWeather
//
//  Created by KevinSu on 15/10/27.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuImageView : NSObject

/*
 * 寻找1像素的线(可以用来隐藏导航栏下面的黑线） 
 */
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
