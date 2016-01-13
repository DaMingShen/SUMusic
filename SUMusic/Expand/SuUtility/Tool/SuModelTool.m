//
//  SuModelTool.m
//  SuUtility
//
//  Created by KevinSu on 15/10/18.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuModelTool.h"

@implementation SuModelTool

//输出model类，直接copy过去用
+ (void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName {
    
    printf("\n@interface %s :NSObject\n",modelName.UTF8String);
    for (NSString *key in dict) {
        printf("@property (nonatomic,copy) NSString *%s;\n",key.UTF8String);
    }
    printf("@end\n");
}

@end
