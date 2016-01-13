//
//  SuButton.m
//  SuUtility
//
//  Created by KevinSu on 15/10/18.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuButton.h"

@implementation SuButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonPressAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonPressAction:(id)sender {
    if (_buttonAction) {
        _buttonAction(sender);
    }
}

+ (instancetype)systemButtonWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font {
    SuButton * button = [SuButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    return button;
}

+ (instancetype)customButtonWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color {
    SuButton * button = [[self alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (instancetype)customButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highLightedImage:(NSString *)highLightedImage {
    SuButton * button = [[self alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highLightedImage] forState:UIControlStateHighlighted];
    return button;
}

+ (instancetype)customButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage disableImage:(NSString *)disableImage {
    
    SuButton * button = [[self alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    return button;
    
}

+ (instancetype)customButtonWithFrame:(CGRect)frame titlt:(NSString *)title normalBGImage:(NSString *)normalImage selectedBGImage:(NSString *)selectedImage disableBGImage:(NSString *)disableImage {
    
    SuButton * button = [[self alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    return button;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
