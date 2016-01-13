//
//  UIView+SuExt.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "UIView+SU.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

@implementation UIView (SU)

//h
-(void)setH:(float)h{
    CGRect frm = self.frame;
    frm.size.height = h;
    self.frame = frm;
}

-(float)h{
    return self.frame.size.height;
}



//w
-(void)setW:(float)w{
    CGRect frm = self.frame;
    frm.size.width = w;
    self.frame = frm;
}

-(float)w{
    return self.frame.size.width;
}


//x
-(void)setX:(float)x{
    CGRect frm = self.frame;
    frm.origin.x = x;
    self.frame = frm;
    
}


-(float)x{
    return self.frame.origin.x;
}



//y
-(void)setY:(float)y{
    CGRect frm = self.frame;
    frm.origin.y = y;
    self.frame = frm;
    
}


-(float)y{
    return self.frame.origin.y;
}


- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


-(float)top
{
    return self.frame.origin.x;
}

-(float)bottom
{
    return self.top+self.frame.size.height;
}

-(float)left
{
    return self.frame.origin.x;
}

-(float)right
{
    return self.left+self.frame.size.width;
}

/*截图*/
- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 2.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 画像素为1的线
+ (instancetype)drawVerticalLineWithFrame:(CGRect)frame {
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x  - SINGLE_LINE_ADJUST_OFFSET, frame.origin.y, SINGLE_LINE_WIDTH, frame.size.height)];
    line.backgroundColor = [UIColor colorWithHexRGB:@"#dfdfdf"];
    return line;
}

+ (instancetype)drawHorizonLineWithFrame:(CGRect)frame {
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - SINGLE_LINE_ADJUST_OFFSET, frame.size.width, SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexRGB:@"#dfdfdf"];
    return line;
}







#pragma mark - Animation

- (void)startShakeAnimation
{
    CGFloat rotation = 0.05;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.2;
    shake.autoreverses = YES;
    shake.repeatCount = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -rotation, 0.0, 0.0, 1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,  rotation, 0.0, 0.0, 1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void)stopShakeAnimation
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}

- (void)startRotateAnimation
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.5;
    shake.autoreverses = NO;
    shake.repeatCount = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, M_PI, 0.0, 0.0, 1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,  0.0, 0.0, 0.0, 1.0)];
    
    [self.layer addAnimation:shake forKey:@"rotateAnimation"];
}

- (void)stopRotateAnimation
{
    [self.layer removeAnimationForKey:@"rotateAnimation"];
}


@end
