//
//  UIView+EasyFrames.m
//  XiaoYing
//
//  Created by Rich on 9/11/13.
//  Copyright (c) 2013 XiaoYing Team. All rights reserved.
//

#import "UIView+EasyFrames.h"
#import <objc/runtime.h>

@implementation UIView (EasyFrames)

//Shortcut for frame.size.height
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

// Shortcut for frame.size.width
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

//Shortcut for frame.origin
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

//Shortcut for center.x
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


//Shortcut for frame.origin.y
- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


//Shortcut for frame.size
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

//Shortcut for frame.origin.x.
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

//Shortcut for frame.origin.y
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//Shortcut for frame.origin.x + frame.size.width
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

//Shortcut for frame.origin.y + frame.size.height
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

-(void)freeAutoLayout{
    UIView *saveSuper = self.superview;
    [self removeFromSuperview];
    [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self setFrame:self.frame];
    [saveSuper addSubview:self];
}

-(CGPoint)iSize //RETURNS CURRENT SCREEN DIMENSIONS
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    CGPoint retPoint;
    retPoint.x = screenWidth;
    retPoint.y = screenHeight;
    return retPoint;
}


-(void)setFrameBottomedInsideFrame:(CGRect)superFrame centered:(BOOL)centered{
    
    CGRect frame =self.frame;
    frame.origin.y = superFrame.size.height-self.frame.size.height;
    if (centered) {
        frame.origin.x = (superFrame.size.width/2) - (frame.size.width/2);
    }
    self.frame = frame;
}


-(void)setFrameToppedInsideFrame:(CGRect)superFrame centered:(BOOL)centered{
    CGRect frame =self.frame;
    frame.origin.y = 0;
    if (centered) {
        frame.origin.x = (superFrame.size.width/2) - (frame.size.width/2);
    }
    self.frame = frame;
    
}

-(void)centerYInsideFrame:(CGRect)superFrame{
    CGRect frame =self.frame;
    frame.origin.y = (superFrame.size.height/2) - (frame.size.height/2);
    self.frame = frame;
}

-(void)centerXInsideFrame:(CGRect)superFrame{
    CGRect frame =self.frame;
    frame.origin.x = (superFrame.size.width/2) - (frame.size.width/2);
    self.frame = frame;
}

-(void)centerInsideFrame:(CGRect)superFrame{
    CGRect frame =self.frame;
    frame.origin.x = (superFrame.size.width/2) - (frame.size.width/2);
    frame.origin.y = (superFrame.size.height/2) - (frame.size.height/2);
    self.frame = frame;
}

-(void)centerWithLandscapeOrientation{
    CGRect frame =self.frame;
    frame.origin.x = ([self iSize].y/2) - (frame.size.width/2);
    frame.origin.y = ([self iSize].x/2) - (frame.size.height/2);
    self.frame = frame;
}

-(void)centerWithPortraitOrientation{
    CGRect frame =self.frame;
    frame.origin.x = ([self iSize].x/2) - (frame.size.width/2);
    frame.origin.y = ([self iSize].y/2) - (frame.size.height/2);
    self.frame = frame;
}

-(void)shiftFrameY:(float)shift{
    CGRect frame =self.frame;
    frame.origin.y+=shift;
    self.frame = frame;
}

-(void)setFrameY:(float)shift{
    CGRect frame =self.frame;
    frame.origin.y=shift;
    self.frame = frame;
}

-(void)shiftFrameX:(float)shift{
    CGRect frame =self.frame;
    frame.origin.x+=shift;
    self.frame = frame;
}

-(void)setFrameX:(float)shift{
    CGRect frame =self.frame;
    frame.origin.x=shift;
    self.frame = frame;
}

-(void)shiftFrameWidth:(float)shift{
    CGRect frame =self.frame;
    frame.size.width+=shift;
    self.frame = frame;
}

-(void)setFrameWidth:(float)shift{
    CGRect frame =self.frame;
    frame.size.width=shift;
    self.frame = frame;
}

-(void)shiftFrameHeight:(float)shift{
    CGRect frame =self.frame;
    frame.size.height+=shift;
    self.frame = frame;
}

-(void)setFrameHeight:(float)shift{
    CGRect frame =self.frame;
    frame.size.height=shift;
    self.frame = frame;
}
@end
