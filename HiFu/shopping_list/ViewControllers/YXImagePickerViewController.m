//
//  GBTestImagePickerViewController.m
//  Gogobot-iOS
//
//  Created by Yin Xu on 11/12/13.
//  Copyright (c) 2013 Gogobot. All rights reserved.
//

#import "YXImagePickerViewController.h"

@interface YXImagePickerViewController ()

@end

@implementation YXImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)   // iOS7+ only
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}


@end
