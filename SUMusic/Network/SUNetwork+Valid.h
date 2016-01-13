//
//  SUNetwork+Valid.h
//  SUMusic
//
//  Created by KevinSu on 16/1/13.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUNetwork.h"

@interface SUNetwork (Valid)

+ (void)validDict:(NSDictionary *)dict completion:(void(^)(NSArray * data))completion;

@end
