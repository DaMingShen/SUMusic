//
//  SuCaptureCodeView.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SuCaptureCodeView : UIView


/*
 扫描二维码
 */
+ (void)startCaptureWithPreView:(UIView *)preView Content:(void(^)(BOOL *stop,AVMetadataMachineReadableCodeObject *content))content;

@end
