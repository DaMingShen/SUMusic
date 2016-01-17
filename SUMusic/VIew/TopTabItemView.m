//
//  TopTabItemView.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "TopTabItemView.h"

@interface TopTabItemView ()

@property (weak, nonatomic) IBOutlet UIButton *channels;
@property (weak, nonatomic) IBOutlet UIButton *mine;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, strong) UIButton * currentTab;

@end

@implementation TopTabItemView

- (IBAction)tabItemClick:(UIButton *)sender {
    
    if (self.currentTab == sender) return;
    
    sender.selected = YES;
    self.currentTab.selected = NO;
    self.currentTab = sender;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.line.centerX = sender.centerX;
    } completion:^(BOOL finished) {
        
    }];
    if (self.tabBlock) self.tabBlock(sender.tag);
}

- (UIButton *)currentTab {
    if (_currentTab == nil) {
        _currentTab = self.channels;
    }
    return _currentTab;
}


@end
