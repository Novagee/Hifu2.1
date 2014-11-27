//
//  EnterCodeViewController.h
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface EnterCodeViewController : LoginViewController  <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *enterCodeField;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;

//LABELS - TEXTS
@property (weak, nonatomic) IBOutlet UILabel  *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel  *errorMessage;

- (IBAction)enterCodeClicked: (id)sender;
- (IBAction)resendCodeClicked:(id)sender;
- (IBAction)finishedClicked:  (id)sender;
- (IBAction)skipClicked:      (id)sender;


@property (nonatomic) int  retryCount;
@property (nonatomic) BOOL canResend;
@property (nonatomic) int  countDown;
@property (nonatomic) BOOL isFromUserSettings;


//UNDERLINES TEXT

@property (weak, nonatomic) IBOutlet UIButton *resendButton;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;


//EXTRA BUTTONS
@property (weak, nonatomic) IBOutlet UIView  *inputBackBar;

@property (weak, nonatomic) IBOutlet UIView  *whiteBackCode;




@end

