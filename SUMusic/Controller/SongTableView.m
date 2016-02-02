//
//  SongTableView.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/2.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SongTableView.h"
#import "SongListTableViewCell.h"

@interface SongTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *noDataNotice;

@end

@implementation SongTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)loadListWithType:(ListType)listType {
    
    switch (listType) {
        case ListTypeOffLine:
            self.songSource = [SuDBManager fetchDownList].mutableCopy;
            break;
        case ListTypeMyFavor:
            self.songSource = [SuDBManager fetchFavorList].mutableCopy;
            break;
        case ListTypeShared:
            self.songSource = [SuDBManager fetchSharedList].mutableCopy;
            break;
        default:
            break;
    }

    if (self.songSource.count > 0) {
        self.noDataNotice.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else {
        self.tableView.hidden = YES;
        self.noDataNotice.hidden = NO;
    }
}

#pragma mark - UI
- (void)setupUI {
    
    self.view.frame = ScreenB;
    
    self.tableView.rowHeight = 70.0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"favorCell"];
    
    RegisterNotify(RADIOPLAY, @selector(refreshSongList))
    RegisterNotify(SONGREADY, @selector(refreshSongList))
}

- (void)refreshSongList {
    if (self.tableView.hidden) return;
    [self.tableView reloadData];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    [cell.songCover sd_setImageWithURL:[NSURL URLWithString:info.picture] placeholderImage:DefaultImg];
    cell.songName.text = info.title;
    cell.artist.text = info.artist;
    
    if ([[AppDelegate delegate].player.currentSong.sid isEqualToString:info.sid]) {
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
    
    BASE_INFO_FUN(@"播放歌曲");
    SUPlayerManager * player = [AppDelegate delegate].player;
    if (!player.isLocalPlay) SendNotify(LOCALPLAY, nil)
        
        SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    if (![player.currentSong.sid isEqualToString:info.sid] ) {
        [player.songList removeAllObjects];
        [player.songList addObjectsFromArray:self.songSource];
        [player playLocalListWithIndex:indexPath.row];
    }
    [[AppDelegate delegate].playView show];
}


@end
