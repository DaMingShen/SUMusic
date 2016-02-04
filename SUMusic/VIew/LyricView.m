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
    NSMutableArray * _timeSource;
    NSMutableArray * _lycSource;
    
    BOOL _isCheck;
    BOOL _isShow;
    
    UILabel * _noLyricNotice;
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
    
    _isCheck = NO;
    _isShow = NO;
    _timeSource = [NSMutableArray array];
    _lycSource = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(self.h / 2 - LycRowH / 2, 0, self.h / 2 - LycRowH / 2, 0);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = LycRowH;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    
    
    _noLyricNotice = [[UILabel alloc]initWithFrame:self.bounds];
    _noLyricNotice.font = [UIFont systemFontOfSize:18];
    _noLyricNotice.textAlignment = NSTextAlignmentCenter;
    _noLyricNotice.text = @"该歌曲暂时没有歌词";
    _noLyricNotice.textColor = [UIColor grayColor];
    _noLyricNotice.hidden = YES;
    [self addSubview:_noLyricNotice];
}

- (void)loadLyric:(NSDictionary *)dict {
    
    //状态
    _isCheck = YES;
    
    if (dict == nil) {
        
        //show no lyric
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
        [_tableView reloadData];
    }
    
}

- (void)clearLyric {
    _isCheck = NO;
    _noLyricNotice.hidden = YES;
    [_timeSource removeAllObjects];
    [_lycSource removeAllObjects];
    [_tableView reloadData];
}

- (void)showInView:(UIView *)sender {
    _isShow = YES;
    
    [_tableView reloadData];
    //先显示到当前歌词
    [self scrollToCurrentLyric];
    
    [sender addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide {
    _isShow = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)checkLyric {
    return _isCheck;
}

- (BOOL)checkShow {
    return _isShow;
}

#pragma mark - scroll lyric
//根据当前秒数滚动到对应的行
- (void)scrollLyric {
    
    NSString * secNow = [AppDelegate delegate].player.playTime;
    for (int i = 0; i < _timeSource.count; i ++) {
        if ([_timeSource[i] isEqualToString:secNow]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            //滚动
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //突出显示
            UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
            UILabel * lyc = (UILabel *)[cell.contentView viewWithTag:666];
            lyc.font = [UIFont systemFontOfSize:18];
            lyc.textColor = BaseColor;
            //恢复
            if (i > 0) {
                NSIndexPath * lastIndexPath = [NSIndexPath indexPathForRow:i - 1 inSection:0];
                UITableViewCell * cell = [_tableView cellForRowAtIndexPath:lastIndexPath];
                UILabel * lyc = (UILabel *)[cell.contentView viewWithTag:666];
                lyc.font = [UIFont systemFontOfSize:15];
                lyc.textColor = [UIColor grayColor];
            }
            break;
        }
    }
}

//根据当前描述滚动到当前播放行
- (void)scrollToCurrentLyric {
    float secNow = [AppDelegate delegate].player.playTime.floatValue;
    int rowNow = 0;
    for (int i = 1; i < _timeSource.count; i ++) {
        if (secNow > [_timeSource[i] floatValue]) {
            if ((secNow - [_timeSource[i] floatValue]) < (secNow - [_timeSource[rowNow] floatValue])) {
                rowNow = i;
            }
        }else {
            break;
        }
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:rowNow inSection:0];
    //滚动
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //突出显示
    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    UILabel * lyc = (UILabel *)[cell.contentView viewWithTag:666];
    lyc.font = [UIFont systemFontOfSize:18];
    lyc.textColor = BaseColor;
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * aCellID = @"lyricCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:aCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.w, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 666;
        [cell.contentView addSubview:label];
    }
    UILabel * lyc = (UILabel *)[cell.contentView viewWithTag:666];
    lyc.font = [UIFont systemFontOfSize:15];
    lyc.textColor = [UIColor grayColor];
    lyc.text = _lycSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
}

@end
