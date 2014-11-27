//
//  HFAlertView.m
//  HiFu
//
//  Created by Yin Xu on 8/30/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//
#import <pop/POP.h>
#import "HFAlertView.h"

@implementation HFAlertView

- (void)awakeFromNib
{
    [HFUIHelpers roundCornerToHFDefaultRadius:self.dismissButton];
}

+ (instancetype)sharedInstance
{
    static HFAlertView *sharedInstance = nil;
    if (!sharedInstance)
    {
        sharedInstance = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:self options:nil] firstObject];
    }
    return sharedInstance;
}

+ (void)show
{
    HFAlertView *ourView = [self sharedInstance];
    [ourView display];
}

- (void)display
{
    self.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    self.mainView.alpha = 0.0;
    self.mainView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];

    POPBasicAnimation *buttonAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    buttonAlphaAnimation.fromValue = @(0.0);
    buttonAlphaAnimation.toValue = @(1);
    [self.mainView pop_addAnimation:buttonAlphaAnimation forKey:@"POPViewAlpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 12.0f;
    scaleAnimation.springSpeed = 8.0f;
    [self.mainView pop_addAnimation:scaleAnimation forKey:@"POPViewScale"];
}

- (IBAction)dismissButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainView.alpha = 0.0;
        self.mainView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
