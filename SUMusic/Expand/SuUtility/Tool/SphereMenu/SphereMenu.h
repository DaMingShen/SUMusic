//
//  SphereMenu.h
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//
/*
 类似facebook一个按钮弹出3个子按钮带动画效果
 
 Use:
 SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(CGRectGetWidth(self.view.frame) / 2, 320)
 startImage:startImage
 submenuImages:images];
 sphereMenu.sphereDamping = 0.3;
 sphereMenu.sphereLength = 85;
 sphereMenu.delegate = self;
 [self.view addSubview:sphereMenu];
 */

#import <UIKit/UIKit.h>

@protocol SphereMenuDelegate <NSObject>

- (void)sphereDidSelected:(int)index;

@end

@interface SphereMenu : UIView

- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images;

@property (nonatomic, weak) id<SphereMenuDelegate> delegate;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat sphereDamping;
@property (nonatomic, assign) CGFloat sphereLength;


@end
