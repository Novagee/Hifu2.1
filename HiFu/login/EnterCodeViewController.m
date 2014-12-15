//
//  EnterCodeViewController.m
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "EnterCodeViewController.h"
#import "HFPhoneNumberHelpers.h"
#import "ServerModel.h"
#import "YXMeInfoSettingViewController.h"
#import <Appsee/Appsee.h>

@interface EnterCodeViewController ()

@end

@implementation EnterCodeViewController


-(BOOL)isFromUserSettings{
    return ![self baseVCisStart];
}

#pragma mark - localization
-(void)ibViewLocalization{
    
    [self.navigationController
                           setTitle:  NSLocalizedString(@"code_title_nav", @"输入验证码")];
    
    [self.errorMessage      setText:  NSLocalizedString(@"code_error_message", @"代码错误，重新输入")];
    
    [self.secondsLabel      setText:  NSLocalizedString(@"code_seconds", @"秒")];
    
    [self.skipButton       setTitle:  NSLocalizedString(@"code_skip", @"跳过")
                           forState:  UIControlStateNormal];
    
    [self.finishButton     setTitle:  NSLocalizedString(@"code_finish", @"完成")
                           forState:  UIControlStateNormal];

    [self.resendButton     setTitle:  NSLocalizedString(@"code_resend", @"没收到验证码? 再发一次")
                           forState:  UIControlStateNormal];

}

#pragma mark -



#pragma mark - error messages

-(void)showErrorMessage{
    [self.errorMessage setAlpha:1.0];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(hideError)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)hideError{
    [UIView animateWithDuration:0.5 animations:^{
        [self.errorMessage setAlpha:0.0];
    }];
}


-(void)setupShadow{

    [self.errorMessage  setAlpha:0.0];
}



#pragma mark - setup view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.retryCount = 4;
    self.canResend  = YES;
    
    NSDictionary  *leftAtrb = @{ NSForegroundColorAttributeName   : [UIColor whiteColor],
                                 NSFontAttributeName              : HeitiSC_Medium(10) };
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes : leftAtrb
                                                         forState : UIControlStateNormal];
    
    [self.secondsLabel setHidden:YES];
    [self setupShadow];
    
    //[HFUIHelpers roundCornerToHFDefaultRadius:self.finishButton];
//    [HFUIHelpers roundCornerToHFDefaultRadius:self.whiteBackCode];
    
//    [self.finishButton setBackgroundColor:HFThemePink];
    [self.finishButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.view setBackgroundColor: UIColorFromRGB(0xffefeff4)];
    
    [self.enterCodeField       setTextColor : [UIColor blackColor]];
    [self.enterCodeField            setFont : HelveticaNeue_Regular(15)];
    [self.enterCodeField       setTintColor : UIColorFromRGB(0xffff6368)];
    
    [self.errorMessage              setFont : HeitiSC_Medium(14)];
    
    [self.resendButton        setTitleColor : UIColorFromRGB(0x0000b2b2)
                                   forState : UIControlStateNormal];
    
    [self.resendButton.titleLabel   setFont : HeitiSC_Medium(13)];
    
    //start as default checked
    [self.finishButton.titleLabel setFont:HeitiSC_Medium(18)];
    [self.skipButton.titleLabel   setFont:HeitiSC_Medium(14)];
    
    if (self.isFromUserSettings) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // Navigation Item
    //
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)leftBarButtonItemTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.enterCodeField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -

- (IBAction)enterCodeClicked:(id)sender {
    [self.view endEditing:YES];
     self.enterCodeField.text = @"";
}

-(void)stepCountDown{
    
    if (self.countDown <=0){
        [self.secondsLabel setHidden:YES];
        self.countDown =60;
        self.canResend = YES;
        return;
    }

    NSDictionary *text1 = [NSDictionary dictionaryWithObject: HelveticaNeue_Regular(12) forKey:NSFontAttributeName];
    NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i",self.countDown] attributes: text1];
    

    NSDictionary *text2 = [NSDictionary dictionaryWithObject:HeitiSC_Medium(12) forKey:NSFontAttributeName];
    NSMutableAttributedString *secondStrong = [[NSMutableAttributedString alloc]initWithString: NSLocalizedString(@"code_seconds", @"秒") attributes:text2];
    
    [firstString appendAttributedString:secondStrong];
    
    self.secondsLabel.attributedText = firstString;

    self.countDown--;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(stepCountDown)
                                   userInfo:nil
                                    repeats:NO];

}

#pragma mark - textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    if (newString.length >3) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - button Click Methods
- (IBAction)resendCodeClicked:(id)sender {
    if (self.canResend) {
        
        [[ServerModel sharedManager] reValidate];
        
        [self.secondsLabel setHidden:NO];
        
         self.countDown = 60;
        
         self.canResend = NO;
        
        [self stepCountDown];
    }
    else{
    }
}

- (IBAction)finishedClicked:(id)sender {
    //CORRECT CODE
    if ([[ServerModel sharedManager] validCode:self.enterCodeField.text]
        //SECRET CODE (testing)
        //|| [self.enterCodeField.text isEqualToString:@"119"]
        )
    {
        
        if(![[ServerModel sharedManager] mobileCode]) {
            self.enterCodeField.text = @"";
            return;
            
        }else{
            
            [[ServerModel sharedManager] createUserWithCompletion:^(bool success) {
                
                [self skipClicked:nil];
            }];
        }
    }
    //WRONG CODE
    else{
        self.errorMessage.text = NSLocalizedString(@"code_error_message", @"代码错误，重新输入") ;
        [self showErrorMessage];
    }
    self.enterCodeField.text = @"";
}

- (IBAction)skipClicked:(id)sender {
    
    NSLog(@"Skip kicked"
          );
    
    if (sender) {
         [Appsee addEvent:@"Skip Button Clicked"];
    }
//    NSArray*stack =[self.navigationController viewControllers];
//    if (self.isFromUserSettings) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPhoneNumberLinked" object:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [self skipToEndWithAnimation:YES];
//    }

    [self skipToEndWithAnimation:YES];
    
    
}




@end
