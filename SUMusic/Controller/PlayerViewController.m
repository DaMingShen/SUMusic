//
//  PlayerViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)back:(id)sender {
    
}

- (IBAction)coverTap:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.cover.frame = CGRectMake(67, 130, 240, 240);
        self.bg.alpha = 1.0;
    }];
    
}

@end
