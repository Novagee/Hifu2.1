//
//  UIView+EasyFrames.h
//  XiaoYing
//
//  Created by Rich on 9/11/13.
//  Copyright (c) 2013 XiaoYing Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyFrames)

//@property(nonatomic, assign)BOOL touchDisabled;

// Shortcut for frame.size.width
@property (nonatomic) CGFloat width;

//Shortcut for frame.size.height
@property (nonatomic) CGFloat height;

//Shortcut for frame.origin
@property (nonatomic) CGPoint origin;

//Shortcut for center.x
@property (nonatomic) CGFloat centerX;

// Shortcut for center.y
@property (nonatomic) CGFloat centerY;

//Shortcut for frame.size
@property (nonatomic) CGSize size;

//Shortcut for frame.origin.x.
@property (nonatomic) CGFloat left;

//Shortcut for frame.origin.y
@property (nonatomic) CGFloat top;

//Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat right;

//Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat bottom;

-(void)setFrameBottomedInsideFrame:(CGRect)superFrame centered:(BOOL)centered;

-(void)setFrameToppedInsideFrame:(CGRect)superFrame centered:(BOOL)centered;

-(void)centerYInsideFrame:(CGRect)superFrame;

-(void)centerXInsideFrame:(CGRect)superFrame;

-(void)centerInsideFrame:(CGRect)superFrame;

-(void)centerWithLandscapeOrientation;

-(void)centerWithPortraitOrientation;

-(void)shiftFrameY:(float)shift;

-(void)setFrameY:(float)shift;

-(void)setSize:(CGSize)size;

-(void)shiftFrameX:(float)shift;

-(void)setFrameX:(float)shift;

-(void)shiftFrameWidth:(float)shift;

-(void)setFrameWidth:(float)shift;

-(void)shiftFrameHeight:(float)shift;

-(void)setFrameHeight:(float)shift;

-(void)freeAutoLayout;

@end
