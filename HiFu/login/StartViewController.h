//
//  StartViewController.h
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HFCustomPageControl.h"

@interface StartViewController : LoginViewController <UIScrollViewDelegate>

- (IBAction)enter:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *hiImage;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIScrollView *introImages;
@property (weak, nonatomic) IBOutlet HFCustomPageControl *pageControl;
@property (nonatomic)       BOOL pageControlUsed;
@property (nonatomic)       BOOL hasPushedSegue;

- (IBAction)pageClicked:(id)sender;
@end
