//
//  SuViewTool.m
//  WanZhongLife
//
//  Created by 万众科技 on 15/11/10.
//  Copyright © 2015年 com.revenco.company. All rights reserved.
//

#import "SuViewTool.h"

@implementation SuViewTool

#pragma mark - toast msg
- (void)ToastMessage:(NSString *)message {
    
    //计算字符串的尺寸
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];
    CGSize textSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    //创建Label
    UILabel * msg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 30, textSize.height + 20)];
    msg.center = CGPointMake(ScreenW / 2, ScreenH * 8.0 / 9.0);
    msg.text = message;
    msg.font = [UIFont systemFontOfSize:15.0];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.backgroundColor = [UIColor blackColor];
    msg.textColor = [UIColor whiteColor];
    msg.layer.masksToBounds = YES;
    msg.layer.cornerRadius = (textSize.height + 20) / 2;
    
    //加到window上
    [[UIApplication sharedApplication].keyWindow addSubview:msg];
    
    //出现后的动画
    POPSpringAnimation * scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [msg.layer pop_addAnimation:scaleAnimation forKey:@"size"];
    [self performSelector:@selector(dismissMsg:) withObject:msg afterDelay:1.5];
    
}

- (void)dismissMsg:(UIView *)msg {
    
    //透明度变化动画
    POPBasicAnimation * alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnimation.fromValue = @(1.0);
    alphaAnimation.toValue = @(0.0);
    [msg pop_addAnimation:alphaAnimation forKey:@"outAlpha"];
    
    [alphaAnimation setCompletionBlock:^(POPAnimation * anim, BOOL finished) {
        
        //动画完成之后从视图中移除
        [msg removeFromSuperview];
    }];
}

#pragma mark - 获取当前控制器
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    //如果是Nav
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)result;
        return nav.topViewController;
    }
    
    return result;
}


@end
