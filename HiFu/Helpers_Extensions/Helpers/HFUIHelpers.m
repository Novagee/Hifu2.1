//
//  HFUIHelpers.m
//  HiFu
//
//  Created by Yin Xu on 8/21/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFUIHelpers.h"
#import "UIImage+ImageEffects.h"

@implementation HFUIHelpers

+ (UIBarButtonItem *)generateNavBarBackButton
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"返回";
    return barButton;
}

+ (void)setupStyleFor:(UINavigationBar *)navigationBar and:(UINavigationItem *)navigationItem
{
    //    [self setNeedsStatusBarAppearanceUpdate];
    UINavigationBar *navBar = navigationBar;
    
    [navBar setTranslucent:NO];
    [navBar setTintColor:[UIColor whiteColor]];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    NSDictionary * leftAtrb =   @{NSForegroundColorAttributeName  : [UIColor whiteColor],
                                  NSFontAttributeName             : HeitiSC_Medium(14) };
    [navigationItem.leftBarButtonItem setTitleTextAttributes : leftAtrb
                                                    forState : UIControlStateNormal];
    
    [navigationItem.rightBarButtonItem setTitleTextAttributes : leftAtrb
                                                     forState : UIControlStateNormal];
//    [navBar setBarTintColor:HFThemePink];
    [navBar setBarTintColor:UIColorFromRGB(0x141414)];
}

+ (void)removeBottomBorderFromNavBar:(UINavigationBar *)navbar
{
    [navbar setShadowImage:[UIImage new]];
    [navbar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

+ (UIImage *)takeScreenShotOf:(UIView *)view withSize:(CGSize)size andApplyBlurEffect:(BOOL)isBlur andBlurRadius:(CGFloat)blurRadius
{
    //take a screen shot for the cureent view
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return isBlur ? [snapshot applyBlurWithRadius:blurRadius tintColor:nil saturationDeltaFactor:1.5 maskImage:nil] : snapshot;
}

+ (UIImage *)takeScreenShotForViewController:(UIViewController *)viewController andApplyBlurEffect:(BOOL)isBlur andBlurRadius:(CGFloat)blurRadius
{
    UIScreen *screen = [UIScreen mainScreen];
    
    UIGraphicsBeginImageContextWithOptions(screen.bounds.size, NO, screen.scale);
    
    [viewController.view.window drawViewHierarchyInRect:viewController.view.window.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return isBlur ? [image applyBlurWithRadius:blurRadius tintColor:nil saturationDeltaFactor:1.5 maskImage:nil] : image;
}

+ (void)roundCornerToHFDefaultRadius:(UIView *)view
{
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
}

@end
