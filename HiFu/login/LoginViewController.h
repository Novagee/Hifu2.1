//
//  LoginViewController.h
//  HiFu
//
//  Created by Rich on 5/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//BASE CLASS FOR LOGIN VIEW CONTROLLERS

@interface LoginViewController : UIViewController

@property (strong, nonatomic) CLLocationManager *locationManager;

-(BOOL)baseVCisStart;


-(void)startLocationTracking;

-(void)currentView:(NSString*)viewName;

@end
