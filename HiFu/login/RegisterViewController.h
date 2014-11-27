//
//  RegisterViewController.h
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HFPhoneNumberHelpers.h"
#import "MobileField.h"

#import "HFWeiboService.h"
#import "HFWeixinService.h"
#import "HFTencentService.h"

@interface RegisterViewController : LoginViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavItem;

- (IBAction)continueClicked:(id)sender;
- (IBAction)skipClicked    :(id)sender;
- (IBAction)xInputClicked  :(id)sender;


@property (weak, nonatomic) IBOutlet UILabel  *carrierLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet MobileField *inputNumberField;

@property (weak, nonatomic) IBOutlet UIButton *xInputButton;

@property (weak, nonatomic) IBOutlet UILabel *inputNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


//Error Views
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@property (weak, nonatomic) IBOutlet UIView  *shadowView;

@property (weak, nonatomic) IBOutlet UIView  *shadowView2;


//underlined link
@property (weak, nonatomic) IBOutlet UIButton *skipButton;


//helvetic font
@property (weak, nonatomic) IBOutlet UILabel  *countryCode;

@property (weak, nonatomic) IBOutlet UIButton *testButton;


//Zoom Cursor
@property (weak, nonatomic) IBOutlet UILabel *cursorNum;

@property (weak, nonatomic) IBOutlet UIView  *spaceBox1;

@property (weak, nonatomic) IBOutlet UIView  *spaceBox2;

@property (strong, nonatomic) UIGestureRecognizer *textInputGesture;

@property (nonatomic) CGRect cursorRect;


//number input items
@property (weak, nonatomic) IBOutlet UIView *numberInput;

@property (weak, nonatomic) IBOutlet UIView *whiteBoxLeft;

@property (weak, nonatomic) IBOutlet UIView *whiteBoxRight;

@property (weak, nonatomic) IBOutlet UIButton *xCheckButton;


//flag for checkMark / X image on button
@property (nonatomic) BOOL isChecked;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel1;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel2;

@property (weak, nonatomic) IBOutlet UILabel *ccBrackets;

@property (weak, nonatomic) IBOutlet UILabel *ccNumbers;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;


//Change Country Code
- (IBAction)changeCountryCodeClicked:(id)sender;
@property (nonatomic) BOOL isCCChina;
@property (nonatomic) BOOL isFromUserSettings;


//Use for checking mobile number formatting
@property (nonatomic) HFPhoneNumberHelpers *numOperator;

-(void)completedNumber;


- (IBAction)nextButtonClicked:(id)sender;



@end
