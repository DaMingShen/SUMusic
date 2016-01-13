//
//  UIView+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SU)


/*
 设置或返回View的 x y h w
 */
@property (nonatomic, assign) float h;
@property (nonatomic, assign) float w;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


@property (nonatomic,readonly) float top;
@property (nonatomic,readonly) float bottom;
@property (nonatomic,readonly) float left;
@property (nonatomic,readonly) float right;

/*
 画像素为1的线
 */
+ (instancetype)drawVerticalLineWithFrame:(CGRect)frame;
+ (instancetype)drawHorizonLineWithFrame:(CGRect)frame;

- (void)startShakeAnimation;//摇动动画
- (void)stopShakeAnimation;
- (void)startRotateAnimation;//360°旋转动画
- (void)stopRotateAnimation;

///截图
- (UIImage *)screenshot;


@end
