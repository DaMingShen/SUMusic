//
//  UIImage+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SU)

/**
 *  加载图片
 *
 *  @param imageName 图片名
 *
 *  @return 适配系统的图片
 */
+ (instancetype)imageWithName:(NSString *)imageName;

/**
 *  返回一张自由拉伸的图片
 */
+ (instancetype)resizedImageWithName:(NSString *)imageName;
+ (instancetype)resizedImageWithName:(NSString *)imageName left:(CGFloat)left top:(CGFloat)top;

/**
 *  获取view所对应的图片
 *
 *  @param view 目标view
 *
 *  @return image
 */
+ (instancetype)captureImageWithViwe:(UIView *)view;

/**
 *  获得给定颜色和大小的图片
 *
 *  @param color 指定的图片颜色
 *  @param size  指定返回的图片大小
 *
 *  @return 返回指定颜色和大小的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  圆形图片
 *
 *  @param name        待处理的图片名
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return 原型图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (UIImage *)createNewImageWithBg:(UIImage *)bgImage icon:(UIImage *)icon;
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

/**
 * 第一个参数string：二维码信息
 * 第二个参数imageSize:二维码的宽或者高
 * 第三个参数icon:需要添加到二维码上面的图片的名字
 * 第四个参数iconSize：需要添加到二维码上面的图片的size；
 */
+ (UIImage *)imageWithQRCodeImageMessage:(NSString *)string imageSize:(CGFloat)imageSize icon:(NSString *)icon iconSize:(CGSize)iconSize;


//图片拉伸、平铺接口
- (UIImage *)resizableImageWithCompatibleCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;
//图片以ScaleToFit方式拉伸后的CGSize
- (CGSize)sizeOfScaleToFit:(CGSize)scaledSize;

//将图片转向调整为向上
- (UIImage *)fixOrientation;

//以ScaleToFit方式压缩图片
- (UIImage *)compressedImageWithSize:(CGSize)compressedSize;

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end
