//
//  TopTabItemView.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTabItemView : UIView

@property (nonatomic, copy) void(^tabBlock)(NSInteger index);

@end
