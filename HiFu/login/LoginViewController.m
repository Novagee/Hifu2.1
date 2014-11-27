//
//  LoginViewController.m
//  HiFu
//
//  Created by Rich on 5/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Standard.h"
#import "StartViewController.h"
#import "EasyData.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - check root Controller

-(BOOL)baseVCisStart{
    NSArray*stack =[self.navigationController viewControllers];
    if ([stack[0] isKindOfClass:StartViewController.class]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - register current VC

//FOR ERROR HANDLING REFERENCE
-(void)currentView:(NSString*)viewName{
    [EasyData setData:viewName forKey:@"currentView"];
}

#pragma mark - trackLocation

-(void)startLocationTracking{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_locationManager startUpdatingLocation];
}


#pragma mark - localization

-(void)ibViewLocalization{

}

#pragma mark -




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - navigation

-(IBAction)popViewBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.titleView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    [self ibViewLocalization];
    
    //changes tint color of back chevron arrow
//    [[self.navigationController.navigationBar.subviews lastObject] setTintColor:[UIColor whiteColor]];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}





@end
