//
//  HFDiscountProblemViewController.m
//  HiFu
//
//  Created by Kelvin Lam on 10/9/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFDiscountProblemViewController.h"

@interface HFDiscountProblemViewController ()

@property (assign, nonatomic) CGFloat keyboardHeight;
@property (weak, nonatomic) IBOutlet UITextField *phoneInputField;

@end

@implementation HFDiscountProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Touch to resign the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    // You should add the gesture to the
    [self.view addGestureRecognizer:tap];

}

- (IBAction)continueButtonTapped:(id)sender {
    UITabBarController *storeView  =  [self.storyboard instantiateViewControllerWithIdentifier:@"browserTabs"];
    [self presentViewController:storeView animated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSTimeInterval animationDuration;
    UIViewAnimationOptions curve;
    NSDictionary *userInfo = [notification userInfo];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    NSValue *keyboardHeightValue = [notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    _keyboardHeight = keyboardHeightValue.CGRectValue.size.height;
    
    // run animation using keyboard's curve and duration
    __weak HFDiscountProblemViewController *weakSelf = self;
    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{
        
        CGPoint currentCenter = self.view.center;
        weakSelf.view.center = CGPointMake(160, currentCenter.y - weakSelf.keyboardHeight);
        
    } completion:^(BOOL completion) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    NSTimeInterval animationDuration;
    UIViewAnimationOptions curve;
    NSDictionary *userInfo = [notification userInfo];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    NSValue *keyboardHeightValue = [notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    _keyboardHeight = keyboardHeightValue.CGRectValue.size.height;
    
    // run animation using keyboard's curve and duration
    __weak HFDiscountProblemViewController *weakSelf = self;
    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{
        
        CGPoint currentCenter = self.view.center;
        weakSelf.view.center = CGPointMake(160, currentCenter.y + weakSelf.keyboardHeight);
        
    } completion:^(BOOL completion) {
        
    }];
    
}

#pragma mark - Tap Gesture Method

- (void) dismissKeyboard {
    // Resgin the keyboard
    //
    if ([self.phoneInputField isFirstResponder]) {
        [self.phoneInputField resignFirstResponder];
    }
    
    /*
     else if([self.verificateInput isFirstResponder])
     {
     [self.verificateInput resignFirstResponder];
     }
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
