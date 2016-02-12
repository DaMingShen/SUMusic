//
//  LyricView.m
//  SUMusic
//
//  Created by 万众科技 on 16/1/26.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "LyricView.h"

#define LycRowH 40.0

@interface LyricView ()<UITableViewDataSource,UITableViewDelegate> {
    
    UITableView * _tableView;
    UILabel * _noLyricNotice;
    
    NSMutableArray * _timeSource;
    NSMutableArray * _lycSource;
    
    NSInteger _currentIndex;
    CADisplayLink * _timer;
}


@end

@implementation LyricView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.alpha = 0.f;
    self.hidden = YES;

    _timeSource = [NSMutableArray array];
    _lycSource = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(self.h / 2 - LycRowH / 2, 0, self.h / 2 - LycRowH / 2, 0);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = LycRowH;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    
    _noLyricNotice = [[UILabel alloc]initWithFrame:self.bounds];
    _noLyricNotice.font = [UIFont systemFontOfSize:18];
    _noLyricNotice.textAlignment = NSTextAlignmentCenter;
    _noLyricNotice.text = @"正在加载歌词...";
    _noLyricNotice.textColor = [UIColor grayColor];
    [self addSubview:_noLyricNotice];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    _currentIndex = 0;
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollLyric)];
    _timer.frameInterval = 3;
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - 加载歌词
- (void)loadLyric:(NSDictionary *)dict {
    
    if (dict == nil) {
        
        //show no lyric
        _noLyricNotice.text = @"该歌曲暂时没有歌词";
        _noLyricNotice.hidden = NO;
        
    }else {
        
        _noLyricNotice.hidden = YES;
        
        for (NSString * key in dict) {
            [_timeSource addObject:key];
            [_lycSource addObject:dict[key]];
        }
        //排序
        for (int i = 0; i < _timeSource.count - 1; i ++) {
            for (int j = i + 1; j < _timeSource.count; j ++) {
                if ([_timeSource[i] intValue] > [_timeSource[j] intValue]) {
                    [_timeSource exchangeObjectAtIndex:i withObjectAtIndex:j];
                    [_lycSource exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        //因为默认高亮第一句，所有为第一句不是0开始的加一句
        if (![_timeSource[0] isEqualToString:@"0"]) {
            [_timeSource insertObject:@"0" atIndex:0];
            [_lycSource insertObject:@"" atIndex:0];
        }
        [_tableView reloadData];
    }
}

#pragma mark - 清除歌词
- (void)clearLyric {
    _noLyricNotice.text = @"正在加载歌词...";
    _noLyricNotice.hidden = NO;
    [_timeSource removeAllObjects];
    [_lycSource removeAllObjects];
    [_tableView reloadData];
    _currentIndex = 0;
}

#pragma mark - 显示
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

#pragma mark - 隐藏
- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - 滚动歌词
//根据当前秒数滚动到对应的行
- (void)scrollLyric {
    //正在加载歌词或者无歌词
    if (!_noLyricNotice.hidden) return;
    
    //有歌词
    NSString * secNow = [AppDelegate delegate].player.playTime;
    for (NSInteger i = _currentIndex + 1; i < _timeSource.count; i ++) {
        //定位下一句
        if ([_timeSource[i] isEqualToString:secNow]) {
            NSArray * reloadRows = @[[NSIndexPath indexPathForRow:_currentIndex inSection:0],
                                      [NSIndexPath indexPathForRow:i inSection:0]];
            _currentIndex = i;
            [_tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * aCellID = @"lyricCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:aCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = _lycSource[indexPath.row];
    if (indexPath.row == _currentIndex) {
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = BaseColor;
    }else {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
}

@end
