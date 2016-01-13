//
//  ViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ViewController.h"
#import "SUPlayerManager.h"

@interface ViewController ()

@property (nonatomic, strong)SUPlayerManager * player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.player = [SUPlayerManager manager];
    [self.player startPlay];

    
    //    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getSongProgress) userInfo:nil repeats:YES];
}

- (void)getSongProgress {
    [self.player bufferProgress];
}

- (IBAction)play:(id)sender {
    if (self.player.isPlaying) {
        [self.player pausePlay];
    }else {
        [self.player restartPlay];
    }
}
- (IBAction)pre:(id)sender {
    [[SUPlayerManager manager]show];
//    [self.player playLast];
}
- (IBAction)next:(id)sender {
    [self.player playNext];
}

@end
