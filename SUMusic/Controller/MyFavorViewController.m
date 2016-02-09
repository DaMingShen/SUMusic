//
//  MyFavorViewController.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "MyFavorViewController.h"
#import "ChannelTableViewCell.h"
#import "ChannelInfo.h"

@interface MyFavorViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *noDataNotice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * channelSource;

@end

@implementation MyFavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我的收藏"];
    
    [self setupUI];
    [self loadListFromDB];
}

- (void)loadListFromDB {
    
    self.channelSource = [SuDBManager fetchFavorList];
    
    if (self.channelSource.count > 0) {
        self.noDataNotice.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else {
        [self.tableView setEditing:NO animated:NO];
        self.tableView.hidden = YES;
        self.noDataNotice.hidden = NO;
    }
}

- (void)setupUI {
    
    self.view.frame = ScreenB;
    
    self.tableView.rowHeight = 70.0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"favorCell"];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ChannelInfo * channel = [self.channelSource objectAtIndex:indexPath.row];
    cell.channelName.text = channel.name;
    
    //播放状态
    if ([[AppDelegate delegate].player.currentChannel.channel_id isEqualToString:channel.channel_id]) {
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
    
    ChannelInfo * channel = [self.channelSource objectAtIndex:indexPath.row];
    SUPlayerManager * player = [AppDelegate delegate].player;
    if (![player.currentChannel.channel_id isEqualToString:channel.channel_id]) {
        //改变channel
        player.currentChannel = channel;
        //开始播放
        [player newChannelPlay];
        //刷新表格
        [tableView reloadData];
    }
    //弹出播放器
    [[AppDelegate delegate].playView show];
}

@end
