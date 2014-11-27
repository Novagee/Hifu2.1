//
//  HFSegue.m
//  HiFu
//
//  Created by Peng Wan on 11/6/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFSegue.h"

@implementation HFSegue

- (void)perform {
    
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    destinationViewController.view.alpha = 0.0f;
    [sourceViewController.view.window addSubview:destinationViewController.view];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                     
                         destinationViewController.view.alpha = 1.0f;
                         
                     }
                     completion:^(BOOL finished) {
                     
                         
                         
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:nil];
                         
                         [destinationViewController.view.window addSubview:sourceViewController.view];
                         [destinationViewController.view.window sendSubviewToBack:sourceViewController.view];
                     }];
    
}

@end
