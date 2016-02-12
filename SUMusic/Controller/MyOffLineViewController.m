//
//  MyOffLineViewController.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/2.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "MyOffLineViewController.h"
#import "SongListTableViewCell.h"

@interface MyOffLineViewController ()

@property (weak, nonatomic) IBOutlet UIView *noDataNotice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * songSource;

@end

@implementation MyOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我的离线"];
    
    [self setupUI];
    [self loadListFromDB];
    
    RegisterNotify(SONGPLAYSTATUSCHANGE, @selector(observeSongPlayStatus))
    RegisterNotify(REFRESHSONGLIST, @selector(loadListFromDB))
}

- (void)observeSongPlayStatus {
    if ([AppDelegate delegate].player.status == SUPlayStatusReadyToPlay) {
        [self.tableView reloadData];
    }
}

- (void)loadListFromDB {
    
    self.songSource = [SuDBManager fetchOffLineList];
    
    if (self.songSource.count > 0) {
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OffLineCell"];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OffLineCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    [cell.songCover sd_setImageWithURL:[NSURL URLWithString:info.picture] placeholderImage:DefaultImg];
    cell.songName.text = info.title;
    cell.artist.text = info.artist;
    
    //播放状态
    if ([AppDelegate delegate].player.isOffLinePlay &&
        [[AppDelegate delegate].player.currentSong.sid isEqualToString:info.sid]) {
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
    
    SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    if (![[AppDelegate delegate].player.currentSong.sid isEqualToString:info.sid]) {
        [[AppDelegate delegate].player playOffLineList:self.songSource index:indexPath.row];
    }
    [[AppDelegate delegate].playView show];
    [tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SongInfo * songInfo = self.songSource[indexPath.row];
    [SuDBManager deleteFromOffLineListWithSid:songInfo.sid];
}

@end
