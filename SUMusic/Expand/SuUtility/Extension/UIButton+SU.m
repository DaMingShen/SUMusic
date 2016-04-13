//
//  UIButton+SuExt.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "UIButton+SU.h"

@implementation UIButton (SU)

/*
 * 按钮： 背景为指定颜色，圆角
 */
+ (UIButton *)createColorButtonWithFrame:(CGRect)frame Title:(NSString *)title Color:(UIColor *)color Target:(id)target Selector:(SEL)selector {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.h / 2;
    button.backgroundColor = color;
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/*
 * 按钮： 内容可拉伸，而边角不拉伸的图片做背景图片，高度为图片高度
 */
+ (UIButton *)createResizedButtonWithFrame:(CGRect)frame Title:(NSString *)title Image:(NSString*)image Target:(id)target Selector:(SEL)selector {
    
    //读取图片
    UIImage * img = [UIImage imageNamed:image];
    
    //设置frame
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    frame.size.height = img.size.height;
    [button setFrame:frame];
    
    //设置背景
    UIImage * resizedImg = [[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height / 2];
//    UIImage * resizedImg = [[UIImage imageNamed:image] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:resizedImg forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/*
 * 按钮：图片、高亮图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed;
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imagePressed] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/*
 * 按钮： 背景图片、高亮图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector ForgroundImage:(NSString*)image ForgroundImageSelected:(NSString *)imageSelected {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/*
 * 按钮：图片、选中图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImageSelected:(NSString *)imageSelected {
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;

}

/*
 * 按钮：标题、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:BlackColor forState:UIControlStateNormal];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/*
 * 按钮：标题、字体、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title FontSize:(CGFloat)fontSize Target:(id)target Selector:(SEL)selector {
    
    UIButton * button = [[self class]createButtonWithFrame:frame Title:title Target:target Selector:selector];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    return button;
}

/*
 * 按钮：标题、字体、颜色、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title FontSize:(CGFloat)fontSize Color:(UIColor *)color Target:(id)target Selector:(SEL)selector {
    
    UIButton * button = [[self class]createButtonWithFrame:frame Title:title FontSize:fontSize Target:target Selector:selector];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

/*
 * 按钮：标题、字体、颜色、背景图片、动作
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title FontSize:(CGFloat)fontSize Color:(UIColor *)color BgImage:(NSString*)bgImage Target:(id)target Selector:(SEL)selector {
    
    UIButton * button = [[self class]createButtonWithFrame:frame Title:title FontSize:fontSize Color:color Target:target Selector:selector];
    [button setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    return button;
}

@end
