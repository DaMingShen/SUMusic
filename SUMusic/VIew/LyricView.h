//
//  LyricView.h
//  SUMusic
//
//  Created by 万众科技 on 16/1/26.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricView : UIView

@property (nonatomic, copy) void(^tapBlock)(LyricView * lyrView);

/*
 * 加载歌词
 */
- (void)loadLyric:(NSDictionary *)dict;

/*
 * 清除歌词
 */
- (void)clearLyric;

/*
 * 滚动歌词
 */
- (void)scrollLyric;

/*
 * 显示
 */
- (void)show;

/*
 * 隐藏
 */
- (void)hide;

@end
