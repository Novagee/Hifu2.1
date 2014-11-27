 //
//  UIViewController+Standard.m
//  HiFu
//
//  Created by Rich on 6/6/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "UIViewController+Standard.h"
#import "ServerModel.h"
#import "UserObject.h"
#import "UserServerApi.h"
#import "EasyData.h"
#import "HFRangeViewController.h"
#import "HFBrowersTabBarController.h"
#import "UserServerApi.h"
#import "UserObject.h"
#import "HFUserApi.h"

@implementation UIViewController (Standard)

#pragma mark - navigation
-(void)skipToEndWithAnimation:(BOOL)animate
{
    if(![UserServerApi sharedInstance].currentUserId)
    {
//        [[UserServerApi sharedInstance] createUUIDUserSuccess:^{
        [HFUserApi registerDefaultUserSuccess:^(id responseObject){
            if (responseObject&&responseObject[@"data"]&&responseObject[@"data"][@"id"]) {
                UserObject *user = [[UserObject alloc]initWithDictionary:responseObject[@"data"]];
                user.loginChannel = @"LOGIN_CHANNEL_SKIP";
                [[UserServerApi sharedInstance] setCurrentUser:user];
            }
            [self presentTabViewControllerWithAnimation:animate];
        } failure:^(NSError *error) {
//            [HFGeneralHelpers showErrorAlertViewBasedOn:error];
        }];
    }
    else
    {
        [self presentTabViewControllerWithAnimation:animate];
    }
}

- (void)presentTabViewControllerWithAnimation:(BOOL)animate
{
#warning in iOS8 this will be discouraged, we should use setRootViewController
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITabBarController *storeView  =  [storyboard instantiateViewControllerWithIdentifier:@"browserTabs"];
//    [self presentViewController:storeView animated:animate completion:nil];
    
    UIStoryboard *hfmainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HFBrowersTabBarController *browserTabsViewController = [hfmainStoryboard instantiateViewControllerWithIdentifier:@"browserTabs"];

    NSLog(@"%@", [UIApplication sharedApplication].windows.lastObject);
    
//    [self presentViewController:browserTabsViewController animated:YES completion:nil];
    
    [[UIApplication sharedApplication].windows.firstObject setRootViewController:browserTabsViewController];
    
}

-(void)pushToIdentifier:(NSString*)indents{
    NSString *indent = indents;
    if ([indent isKindOfClass:NSTimer.class]) {
        indent = [(NSTimer*)indents userInfo];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *storeView  =  [storyboard instantiateViewControllerWithIdentifier:indent];
    [self.navigationController pushViewController:storeView animated:YES];
}

-(IBAction)popViewBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text Formating

-(void)underlineText:(UIView*)uView forText:(NSString*)uText{
    
    if (!uText) {
        return;
    }
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:uText];
    
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    
    if ([uView isKindOfClass:UIButton.class]) {
        [(UIButton*)uView setAttributedTitle: titleString forState:UIControlStateNormal];
    }
    if ([uView isKindOfClass:UILabel.class]) {
        [(UILabel*)uView setAttributedText: titleString];
    }
}


@end
