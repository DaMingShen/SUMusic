//
//  SUNetwork+Valid.m
//  SUMusic
//
//  Created by KevinSu on 16/1/13.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUNetwork+Valid.h"

@implementation SUNetwork (Valid)


+ (void)validDict:(NSDictionary *)dict completion:(void(^)(NSArray * data))completion {
    
    if ([[dict objectForKey:NetResult] intValue] == NetOk) {
        
        if ([[dict objectForKey:NetSong] isKindOfClass:[NSArray class]]) {
            if (completion) completion([dict objectForKey:NetSong]);
        }
        
    }else {
        
        if (completion) completion(nil);
    }
}

@end
