//
//  ViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ViewController.h"
#import "SUPlayerManager.h"
#import "SongInfo.h"

@interface ViewController ()

@property (nonatomic, strong)SUPlayerManager * player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.player = [SUPlayerManager manager];
    
     NSArray * songNames = @[@"周慧敏 - 痴心换情深.mp3", @"张宇 - 曲终人散.mp3", @"张芸京 - 偏爱.mp3"];
    for (NSString * name in songNames) {
        SongInfo * info = [[SongInfo alloc]init];
        info.title = name;
//        info.url = [[NSBundle mainBundle]URLForResource:name withExtension:nil];
        info.url = @"http://mr7.doubanio.com/1f079ad8113fde4c2ccc2f042f3482f1/0/fm/song/p1383671_128k.mp4";
        [self.player.songList addObject:info];
    }
    [self.player startPlay];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getSongProgress) userInfo:nil repeats:YES];
     
    
//    [SUNetwork fetchChannels];
    [SUNetwork fetchPlayList];
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
