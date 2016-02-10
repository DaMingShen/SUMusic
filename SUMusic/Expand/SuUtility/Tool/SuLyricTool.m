//
//  SuLyricTool.m
//  SUMusic
//
//  Created by 万众科技 on 16/1/25.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SuLyricTool.h"

@implementation SuLyricTool

+ (NSDictionary *)parseLyricStirng:(NSString *)lyricsString {
    
    NSMutableDictionary * lyrDict = [NSMutableDictionary dictionary];
    //1 取出每一行
    NSArray<NSString *> * lyricsArray = [lyricsString componentsSeparatedByString:@"\n"];
    //如果带有[ti:歌曲名]这样的歌词。。。
    //ti ar al by
    for (NSString * lineString in lyricsArray) {
        if ([lineString isEqualToString:@""]) continue;
        //2 每一行通过]进行分割
        NSArray<NSString *> * lineArray = [lineString componentsSeparatedByString:@"]"];
        //3 如果第一个元素的第二个字符是0-9说明该行有时间和歌词
        if (lineArray[0].length > 2) {
            
            if ([lineArray[0] substringWithRange:NSMakeRange(1, 1)].intValue <= 9) {
                
                //3.1 歌词
                NSString * lyr = [lineArray lastObject];
                
                for (NSString * subString in lineArray) {
                    if ([subString isEqualToString:lyr]) break;
                    //3.2 歌词对应的时间
                    NSString * timeStr = [subString substringWithRange:NSMakeRange(1, 5)];
                    NSArray<NSString *> * timeArray = [timeStr componentsSeparatedByString:@":"];
                    int seconds = 0;
                    if (timeArray.count >= 2) seconds = timeArray[0].intValue * 60 + timeArray[1].intValue;
                    //4 加入到字典中
                    [lyrDict setValue:lyr forKey:[NSString stringWithFormat:@"%d",seconds]];
                }
                
            }
            /*
            else {
                
                //5 如果不是0-9则是头部信息
                NSString * preStr = [lineArray[0] substringWithRange:NSMakeRange(1, 2)];
                if ([preStr isEqualToString:@"ti"]) [lyrDict setValue:preStr forKey:@"ti"];
                if ([preStr isEqualToString:@"ar"]) [lyrDict setValue:preStr forKey:@"ar"];
                if ([preStr isEqualToString:@"al"]) [lyrDict setValue:preStr forKey:@"al"];
                if ([preStr isEqualToString:@"by"]) [lyrDict setValue:preStr forKey:@"by"];
            }
             */
        }
    }
    if ([lyrDict isEqualToDictionary:@{}]) lyrDict = nil;
    return lyrDict;
}

@end
