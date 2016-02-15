//
//  TopAlertView.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/15.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "TopAlertView.h"

@implementation TopAlertView

+ (TopAlertView *)showWithType:(TopAlertType)type message:(NSString*)message {
    
    TopAlertView * topAlertView = [[TopAlertView alloc]initWithType:type message:message];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:topAlertView];
    [topAlertView show];
    return topAlertView;
}

- (instancetype)initWithType:(TopAlertType)type message:(NSString*)message {
    
    if (self = [super init]) {
        [self setType:type message:message];
    };
    return self;
}

- (void)setType:(TopAlertType)type message:(NSString*)message {
    
    self.backgroundColor = BaseColor;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(0, -64, screenW, 64);
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20 + (44 - 32) / 2, 32, 32)];
    switch (type) {
        case TopAlertTypeAdd:
            icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TopAlert_add" ofType:@"png"]];
            break;
        case TopAlertTypeBan:
            icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TopAlert_ban" ofType:@"png"]];
            break;
        case TopAlertTypeCheck:
            icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TopAlert_check" ofType:@"png"]];
            break;
        default:
            break;
    }
    [self addSubview:icon];
    
    
    CGFloat messageX = 10 + CGRectGetWidth(icon.frame) + 10;
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(messageX, CGRectGetMinY(icon.frame), screenW - messageX * 2, 32)];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:17];
    messageLabel.text = message;
    [self addSubview:messageLabel];
    
}


- (void)show {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(self.layer.position.x, self.layer.position.y + 64);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:2.0];
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.15 animations:^{
        self.center = CGPointMake(self.layer.position.x, self.layer.position.y - 64);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
