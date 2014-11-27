//
//  HFRangeViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFRangeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HFRangeViewButton.h"

@interface HFRangeViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSMutableArray *buttonStatus;

@end

@implementation HFRangeViewController

#pragma mark - Controller's Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _locationManager = [[CLLocationManager alloc]init];
    
    _buttonStatus = [[NSMutableArray alloc]initWithCapacity:12];
    for (int i = 0; i < 12; i++) {
        [_buttonStatus addObject:@NO];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"HiFu请求允许打开地理位置信息" delegate:self cancelButtonTitle:@"同意" otherButtonTitles:@"拒绝", nil];
    
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        HFRangeViewButton *sanFranciscoButton = (HFRangeViewButton *)[self.view viewWithTag:102];
        sanFranciscoButton.tapped = YES;
        [self.buttonStatus replaceObjectAtIndex:2 withObject:@YES];
    }
    else {
        
        NSLog(@"No");
        
        for (int i = 100; i <105; i++) {
            HFRangeViewButton *sanFranciscoButton = (HFRangeViewButton *)[self.view viewWithTag:i];
            sanFranciscoButton.tapped = YES;
            [self.buttonStatus replaceObjectAtIndex:(i - 100) withObject:@YES];
        }
        
    }
    
}

#pragma mark - Dismiss View Controller

- (IBAction)cancelButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Confirm Button's Action

- (IBAction)confirmButtonTapped:(UIButton *)sender {
    
    if ([self.continueType isEqualToString:@"dismissViewController"]) {

        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        
        UITabBarController *storeView  =  [self.storyboard instantiateViewControllerWithIdentifier:@"browserTabs"];
        [self presentViewController:storeView animated:YES completion:nil];

        
    }
}

- (IBAction)cityButtonTapped:(HFRangeViewButton *)button {
    
    if ([[self.buttonStatus objectAtIndex:(button.tag - 100)] boolValue]) {
        button.tapped = NO;
        [self.buttonStatus replaceObjectAtIndex:(button.tag - 100) withObject:@NO];
    }
    else {
        button.tapped = YES;
        [self.buttonStatus replaceObjectAtIndex:(button.tag - 100) withObject:@YES];
    }
    
    
}

- (IBAction)storeCircleButtonTapped:(HFRangeViewButton *)storeCircleButton {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
