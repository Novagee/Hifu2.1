//
//  DCTransitionAnimator.h
//  DCTransition
//
//  Created by Paul on 11/2/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

@import UIKit;

@interface DCTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) NSTimeInterval transitionDuration;
@property (assign, nonatomic) BOOL presenting;

@end
