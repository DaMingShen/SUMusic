//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    
    AppDelegate * _delegate;
}


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    _delegate = [AppDelegate delegate];
    [_delegate.player startPlay];
    
    [_delegate.playView show];

}



@end
