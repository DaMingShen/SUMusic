//
//  SuButton.h
//  SuUtility
//
//  Created by KevinSu on 15/10/18.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuButton : UIButton

@property (nonatomic,copy) void(^buttonAction)(SuButton * button);

#pragma mark 系统按钮，自定义标题，字体
+ (instancetype)systemButtonWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;


#pragma mark 自定义按钮，自定义标题，字体
+ (instancetype)customButtonWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color;

+ (instancetype)customButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highLightedImage:(NSString *)highLightedImage;

+ (instancetype)customButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage disableImage:(NSString *)disableImage;

+ (instancetype)customButtonWithFrame:(CGRect)frame titlt:(NSString *)title normalBGImage:(NSString *)normalImage selectedBGImage:(NSString *)selectedImage disableBGImage:(NSString *)disableImage;

/*
 重写layoutSubviews方法设置图片文字垂直排列
 */

@end
