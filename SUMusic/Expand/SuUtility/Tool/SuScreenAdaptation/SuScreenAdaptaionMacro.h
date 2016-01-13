//
//  SuScreenAdaptaionMacro.h
//  SuUtility
//
//  Created by KevinSu on 15/10/18.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//
/*
 iphone5以上屏幕适配
 全局导入screenadaption
 需要适配的页面倒入Macro就行了
 */

#define AdaptaionFlag

#ifdef  AdaptaionFlag

    #define CGRectMake CGRectMakeEx
    #define CGSizeMake CGSizeMakeEx
    #define widthEx widthEx
    #define heightEx heightEx

#else

    #define CGRectMake CGRectMake
    #define CGSizeMake CGSizeMake
    #define widthEx
    #define heightEx

#endif

