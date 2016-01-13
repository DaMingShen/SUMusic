//
//  UILabel+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SU)

/*
 获得Label的大小，常用于自适应高度
 */
- (CGSize)boundsSize:(CGSize)size;

@end
