//
//  HFUIHelpers.h
//  HiFu
//
//  Created by Yin Xu on 8/21/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFUIHelpers : NSObject

+ (UIBarButtonItem *)generateNavBarBackButton;

/**
 *  Set the HiFu pink style and fonts on navigation bar buttons and titles
 *
 *  @param navigationBar
 *  @param navigationItem
 */
+ (void)setupStyleFor:(UINavigationBar *)navigationBar and:(UINavigationItem *)navigationItem;

/**
 *  remove the bottom border from nav bar
 *
 *  @param navbar the actual nav bar
 */
+ (void)removeBottomBorderFromNavBar:(UINavigationBar *)navbar;

/**
 *  take a screen shot for current view and apply blur on it, use as a fake blur background
 *
 *  @param view       the view we want to take screen shot of
 *  @param size       the size of the image, usually should use view.bound
 *  @param isBlur     should we blur the image
 *  @param blurRadius blur radius, the larger the more blur
 *
 *  @return blurred image
 */
+ (UIImage *)takeScreenShotOf:(UIView *)view withSize:(CGSize)size andApplyBlurEffect:(BOOL)isBlur andBlurRadius:(CGFloat)blurRadius;

+ (UIImage *)takeScreenShotForViewController:(UIViewController *)viewController andApplyBlurEffect:(BOOL)isBlur andBlurRadius:(CGFloat)blurRadius;


+ (void)roundCornerToHFDefaultRadius:(UIView *)view;

@end
