//
//  SuAudioTool.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuAudioTool.h"

@implementation SuAudioTool

/**
 *  存放所有的音频ID
 *  字典：fileName作为key，soundID作为value
 */
static NSMutableDictionary *_soundIDDict;

/**
 *  存放所有的音乐播放器
 *  字典：fileName作为key，soundID作为value
 */
static NSMutableDictionary *_audioPlayerDict;


/**
 *  初始化
 */
+ (void)initialize
{
    _soundIDDict = [NSMutableDictionary dictionary];
    _audioPlayerDict = [NSMutableDictionary dictionary];
    
    // 设置音乐会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}

/**
 *  播放音效
 *
 *  @param filename 音效文件名
 */
+ (void)playSound:(NSString *)fileName
{
    if (!fileName) return;
    
    // 1.从字典中取出soundID
    SystemSoundID soundID = [_soundIDDict[fileName] unsignedIntValue];
    if (!soundID) { // 创建
        // 加载音效文件
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (!url) return;
        
        // 创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        
        // 放入字典
        _soundIDDict[fileName] = @(soundID);
    }
    
    // 2.播放
    AudioServicesPlaySystemSound(soundID);
}

/**
 *  销毁音效
 *
 *  @param filename 音效文件名
 */
+ (void)disposeSound:(NSString *)fileName
{
    if (!fileName) return;
    
    SystemSoundID soundID = [_soundIDDict[fileName] unsignedIntValue];
    if (soundID) {
        // 销毁音效ID
        AudioServicesDisposeSystemSoundID(soundID);
        
        // 从字典中移除
        [_soundIDDict removeObjectForKey:fileName];
    }
}

/**
 *  播放音乐
 *
 *  @param filename 音乐文件名
 */
+ (AVAudioPlayer *)playMusic:(NSString *)fileName
{
    if (!fileName) return nil;
    
    // 1.从字典中取出audioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayerDict[fileName];
    if (!audioPlayer) { // 创建
        // 加载音乐文件
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (!url) return nil;
        
        // 创建audioPlayer
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 缓冲
        [audioPlayer prepareToPlay];
        
        //        audioPlayer.enableRate = YES;
        //        audioPlayer.rate = 10.0f;
        
        // 放入字典
        _audioPlayerDict[fileName] = audioPlayer;
    }
    
    // 2.播放
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
    }
    return audioPlayer;
}

/**
 *  暂停音乐
 *
 *  @param filename 音乐文件名
 */
+ (void)pauseMusic:(NSString *)fileName
{
    if (!fileName) return;
    
    // 1.从字典中取出audioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayerDict[fileName];
    
    // 2.暂停
    if (audioPlayer.isPlaying) {
        [audioPlayer pause];
    }
}

/**
 *  停止音乐
 *
 *  @param filename 音乐文件名
 */
+ (void)stopMusic:(NSString *)fileName
{
    if (!fileName) return;
    
    // 1.从字典中取出audioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayerDict[fileName];
    
    // 2.暂停
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
        
        // 直接销毁
        [_audioPlayerDict removeObjectForKey:fileName];
    }
    
}

/**
 *  返回当前正在播放的音乐播放器
 */
+ (AVAudioPlayer *)currentPlayingAudioPlayer
{
    for (NSString *fileName in _audioPlayerDict) {
        AVAudioPlayer *audioPlayer = _audioPlayerDict[fileName];
        if (audioPlayer.isPlaying) {
            return audioPlayer;
        }
    }
    
    return nil;
}

@end
