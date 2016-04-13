//
//  UIButton+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SU)

/*
 * 按钮： 背景为指定颜色，圆角
 */
+ (UIButton *)createColorButtonWithFrame:(CGRect)frame Title:(NSString *)title Color:(UIColor *)color Target:(id)target Selector:(SEL)selector;

/*
 * 按钮： 内容可拉伸，而边角不拉伸的图片做背景图片，高度为图片高度
 */
+ (UIButton *)createResizedButtonWithFrame:(CGRect)frame Title:(NSString *)title Image:(NSString*)image Target:(id)target Selector:(SEL)selector;

/*
 * 按钮： 背景图片、高亮图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImagePressed:(NSString *)imagePressed;

/*
 * 按钮： 背景图片、高亮图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector ForgroundImage:(NSString*)image ForgroundImageSelected:(NSString *)imageSelected;

/*
 * 按钮：背景图片、选中图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImageSelected:(NSString *)imageSelected;

/*
 * 按钮：标题、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector;

/*
 * 按钮：标题、字体、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title FontSize:(CGFloat)fontSize Target:(id)target Selector:(SEL)selector;

/*
 * 按钮：标题、字体、颜色、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title FontSize:(CGFloat)fontSize Color:(UIColor *)color Target:(id)target Selector:(SEL)selector;

/*
 * 按钮：标题、字体、颜色、背景图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title FontSize:(CGFloat)fontSize Color:(UIColor *)color BgImage:(NSString*)bgImage Target:(id)target Selector:(SEL)selector;



@end
