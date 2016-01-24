//
//  SuDBManager.h
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SuDBManager : NSObject

+ (void)saveUserInfoDict:(NSDictionary *)dict;

+ (NSDictionary *)fetchUserInfoDict;

@end
