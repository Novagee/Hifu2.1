//
//  UIViewController+Standard.h
//  HiFu
//
//  Created by Rich on 6/6/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Standard)
-(void)underlineText:(UIView*)uView forText:(NSString*)uText;
-(void)skipToEndWithAnimation:(BOOL)animate;
-(void)pushToIdentifier:(NSString*)ident;

-(IBAction)popViewBack:(id)sender;
-(void)ibViewLocalization;

@end
