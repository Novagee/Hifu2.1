//
//  DCTransitionAnimator.m
//  DCTransition
//
//  Created by Paul on 11/2/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import "DCTransitionAnimator.h"

@implementation DCTransitionAnimator

#pragma mark - Transition time;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return self.transitionDuration;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // Step 1. Fetch the source view controller and
    // destinationController
    //
    UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:sourceViewController.view];
    [containerView addSubview:destinationViewController.view];
    

    
    
    if (self.presenting) {
        NSLog(@"Present");
    }
    else {
        NSLog(@"Dismiss");
    }
    
    
    [UIView animateWithDuration:0.318
                     animations:^{
                         
                         destinationViewController.view.alpha = 1.0f;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [transitionContext completeTransition:YES];
                         
                     }];

    
}

@end
