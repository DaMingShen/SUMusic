//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ChannelListViewController.h"
#import "LoginPage.h"

@interface ChannelListViewController () {
    
    AppDelegate * _appDelegate;
}


@end

@implementation ChannelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _appDelegate = [AppDelegate delegate];
//    [_appDelegate.player startPlay];
    
//    [_appDelegate.playView show];
//    [SUNetwork loginWithUserName:@"446135517@qq.com" password:@"kevinsu0321"];
    [SUNetwork fetchMyFavorSongList];
}

- (IBAction)showPlayView:(id)sender {
    [_appDelegate.playView show];
}

- (IBAction)login:(id)sender {
    
    LoginPage * loginVC = [[LoginPage alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
