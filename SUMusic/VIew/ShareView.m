//
//  ShareView.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIView *panel;
@end

@implementation ShareView

- (void)showInView:(UIView *)view {
    self.userInteractionEnabled = YES;
    self.panel.y = self.h;
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.bg.alpha = 0.2;
        self.panel.y = self.h - self.panel.h;
    }];
}

- (IBAction)share:(UIButton *)sender {
    if (self.shareBlock) self.shareBlock(sender.tag);
}

- (IBAction)dismiss:(id)sender {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.bg.alpha = 0.f;
        self.panel.y = self.h;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
