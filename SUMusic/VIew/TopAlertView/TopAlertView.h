//
//  TopAlertView.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/15.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopAlertType) {
    TopAlertTypeAdd,
    TopAlertTypeBan,
    TopAlertTypeCheck
};

@interface TopAlertView : UIView

//@property (nonatomic, assign) NSInteger duration;

+ (TopAlertView *)showWithType:(TopAlertType)type message:(NSString*)text;

@end
