//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ChannelListViewController.h"
#import "ChannelTableViewCell.h"
#import "ChannelInfo.h"

@interface ChannelListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    AppDelegate * _appDelegate;
    UIImageView * _unConnectNotic;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) ChannelInfo * myHeartChannel;

@end

@implementation ChannelListViewController

- (ChannelInfo *)myHeartChannel {
    if (_myHeartChannel == nil) {
        _myHeartChannel = [[ChannelInfo alloc]init];
        _myHeartChannel.channel_id = @"-3";
        _myHeartChannel.name = @"我的红心";
    }
    return _myHeartChannel;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        if ([SuGlobal checkLogin]) [_dataSource addObject:self.myHeartChannel];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _appDelegate = [AppDelegate delegate];
    
    [self setupUI];
    [self fetchChannels];
    
    RegisterNotify(LoginSUCC, @selector(userLoginInOutRefresh))
}

#pragma mark - UI
- (void)setupUI {
    
    //表格设置
    self.tableView.rowHeight = 70.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"channelCell"];
    self.tableView.tableFooterView = [UIView new];
    
    _unConnectNotic = [[UIImageView alloc]initWithFrame:ScreenB];
    _unConnectNotic.image = [UIImage imageNamed:@"network_404"];
    _unConnectNotic.hidden = YES;
    [self.view addSubview:_unConnectNotic];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fetchChannels)];
    [_unConnectNotic addGestureRecognizer:tap];
}

- (void)userLoginInOutRefresh {
    if ([SuGlobal checkLogin] && ![self.dataSource containsObject:self.myHeartChannel]) {
        [self.dataSource insertObject:self.myHeartChannel atIndex:0];
        [self.tableView reloadData];
    }else if (![SuGlobal checkLogin] && [self.dataSource containsObject:self.myHeartChannel]) {
        [self.dataSource removeObject:self.myHeartChannel];
        [self.tableView reloadData];
    }
    [_appDelegate.player newChannelPlay];
}

- (void)offLinePlayingRefresh {
    ChannelInfo * info = [[ChannelInfo alloc]init];
    info.channel_id = @"OffLine";
    info.name = @"离线歌曲";
    _appDelegate.player.currentChannel = info;
    [_tableView reloadData];
}

#pragma mark - 网络
- (void)fetchChannels {
    
    //showAni
    
    //loadData
    [SUNetwork fetchChannelsWithCompletion:^(BOOL isSucc, NSArray *channels) {
        //stopAni
        
        //refreshUI
        if (isSucc) {
            [self.dataSource addObjectsFromArray:channels];
            _unConnectNotic.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else {
            _unConnectNotic.hidden = NO;
        }
    }];

}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ChannelInfo * channel = [self.dataSource objectAtIndex:indexPath.row];
    cell.channelName.text = channel.name;
    
    if ([_appDelegate.player.currentChannel.channel_id isEqualToString:channel.channel_id]) {
        cell.playIndicator.hidden = NO;
        cell.playIndicator.animationImages = @[[UIImage imageNamed:@"ic_channel_nowplaying1"],
                                               [UIImage imageNamed:@"ic_channel_nowplaying2"],
                                               [UIImage imageNamed:@"ic_channel_nowplaying3"],
                                               [UIImage imageNamed:@"ic_channel_nowplaying4"]];
        cell.playIndicator.animationDuration = 1.0;
        cell.playIndicator.animationRepeatCount = 0;
        [cell.playIndicator startAnimating];
    }else {
        [cell.playIndicator stopAnimating];
        cell.playIndicator.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelInfo * channel = [self.dataSource objectAtIndex:indexPath.row];
    if (![_appDelegate.player.currentChannel.channel_id isEqualToString:channel.channel_id]) {
        //改变channel
        _appDelegate.player.currentChannel = channel;
        //开始播放
        [_appDelegate.player newChannelPlay];
        //刷新表格
        [tableView reloadData];
    }
    //弹出播放器
    [_appDelegate.playView show];
}

@end
