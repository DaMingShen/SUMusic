//
//  UILabel+SuExt.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "UILabel+SU.h"

@implementation UILabel (SU)

- (CGSize)boundsSize:(CGSize)size
{
    CGSize resSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedDescending) {
        NSDictionary *attribute = @{NSFontAttributeName:self.font};
        
        resSize = [self.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    } else {
        resSize = [self.text sizeWithFont:[UIFont systemFontOfSize:self.font.pointSize] constrainedToSize:CGSizeMake(size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return resSize;
}

@end
