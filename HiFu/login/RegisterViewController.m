//
//  RegisterViewController.m
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "RegisterViewController.h"
#import "ServerModel.h"
#import "EnterCodeViewController.h"
#import "UserServerApi.h"
#import "HFGeneralHelpers.h"
#import "SVProgressHUD.h"
#import "HFBrowersTabBarController.h"
#import <Appsee/Appsee.h>

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;}

@interface RegisterViewController ()

@end


@implementation RegisterViewController

#pragma mark - localization
-(void)ibViewLocalization{
    
    [self.titleNavItem     setTitle:  NSLocalizedString(@"reg_title_nav",
                                                        @"10秒完成注册")];
    
    [self.countryCodeLabel1 setText:  NSLocalizedString(@"reg_country_china",
                                                        @"中国")];
    
    [self.inputNumberLabel  setText:  NSLocalizedString(@"reg_input_num_text",
                                                        @"填写手机号码")];
    
    [self.errorMessage      setText:  NSLocalizedString(@"reg_error_message",
                                                        @"代码错误，重新输入")];
    
    [self.skipButton       setTitle:  NSLocalizedString(@"reg_skip", @"跳过")
                           forState:  UIControlStateNormal];
    
    [self.carrierLabel      setText:  NSLocalizedString(@"reg_carrier_default",
                                                        @"全球免费接收短信验证码")];
}


#pragma mark -

-(void)completedNumber{
    [self continueClicked:nil];
}

-(BOOL)checkMobileFormat:(NSString*)mobile{
    if (![HFGeneralHelpers isChinaCountryCode:[UserServerApi sharedInstance].userCountryCode]) {
        return NO;
    }
    NSString *errorStr =[HFPhoneNumberHelpers checkNumberFormat:mobile];
    if (errorStr) {
        [self.errorMessage setText:errorStr];
        [self showErrorMessage];
        return YES;
    }
    return NO;
}

#pragma mark -


-(void)enterCodeView{
    int endSpace = 13;
    if (![HFGeneralHelpers isChinaCountryCode:[UserServerApi sharedInstance].userCountryCode]) {
        endSpace--;
    }

    if (self.inputNumberField.text.length<endSpace) {
        [self.errorMessage setText:@"手机号码太短"];
        [self showErrorMessage];
        return;
        
    }
    
    if ([HFPhoneNumberHelpers checkNumberFormat:self.inputNumberField.text]) {
        
        [self checkMobileFormat:self.inputNumberField.text];
        return;
    }
    
    [[ServerModel sharedManager] vailidateMobile:[HFPhoneNumberHelpers removeSpaces:self.inputNumberField.text]
                                         Country:nil
                                        Location:CGPointMake(0, 0)];
    self.xInputButton.hidden = YES;
    self.animationImageView.hidden = NO;
    [self.animationImageView startAnimating];


    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(checkImage)
                                   userInfo:nil repeats:NO];
    
        self.isChecked = YES;
}

-(void)checkImage{
     self.isChecked = NO;
    self.xInputButton.hidden = NO;
    self.animationImageView.hidden = YES;
    [self.animationImageView stopAnimating];
        [self.xInputButton setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
}


#pragma mark - Buttons Clicked

- (IBAction)continueClicked:(id)sender {
    [self.view endEditing:YES];
    [self enterCodeView];
}

- (IBAction)skipClicked:(id)sender {
    
    NSLog(@"Skip ");
    if (sender) {
        [Appsee addEvent:@"Skip Button Clicked"];
    }
    [self skipToEndWithAnimation:YES];
}



- (IBAction)xInputClicked:(id)sender {
    int endSpace = 9;
    if (![HFGeneralHelpers isChinaCountryCode:[UserServerApi sharedInstance].userCountryCode]) {
        endSpace--;
    }
    
    if      (self.inputNumberField.text.length > 9) {
       self.inputNumberField.text = [self.inputNumberField.text substringToIndex:9];
    }
    else if (self.inputNumberField.text.length > 4) {
       self.inputNumberField.text = [self.inputNumberField.text substringToIndex:4];
    }
    else if (self.inputNumberField.text.length > 0) {
        [self.inputNumberField setText: @"" ];
    }
    [self checkEmpty:self.inputNumberField.text];
}
#pragma mark -


-(void)updateCarrierInformation : (NSString*)newString{
    
    NSString *carrier = [HFPhoneNumberHelpers carrierFromNumber:newString];
    
    if (carrier) {
        [self.carrierLabel setText:carrier];
    }
    else{
        [self.carrierLabel setText: @"" ];
    }
}



-(void)inputNumSetHidden:(BOOL)hidden{
    [self.inputNumberLabel setHidden: hidden];
    [self.spaceBox1        setHidden:!hidden];
    [self.spaceBox2        setHidden:!hidden];
}



-(void)checkEmpty:(NSString*)newString{
    if ([newString isEqualToString:@""]) {
        [self inputNumSetHidden:NO];
    }
    else{
        [self inputNumSetHidden:YES];
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.xInputButton setHidden:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (!self.isChecked) {
        [self.xInputButton setHidden:YES];
    }
}


- (BOOL)                textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string{
    
    NSLog(@"textField");
    
/*这个Method完全可以用一个
 [textField addTarget:self
               action:@selector(textFieldDidChange:)
     forControlEvents:UIControlEventEditingChanged];
 做到的。。逻辑实在太复杂和混乱。无法理清。建议删光重写。0回收利用率。
 包括MFieldDelegator, NumHelper等等文件，全部没任何办法理解。。实在是不可思议的混乱。
 by Yin 看了半天的注册流程的全部Files，本来打算在他的基础上修改，就不全部重写了。现在无奈的想哭。
 
*/
    [self.cursorNum setText:string];
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    //show label based on newString
    [self checkEmpty:newString];
    
    if ([self checkMobileFormat:newString]) {
        
        //show label based on oldString
        textField.text =@"";
        [self checkEmpty:textField.text];
        return NO;
    }
    
    [self updateCarrierInformation : newString];
    
    return NO;
}

#pragma mark - error setup


-(void)showErrorMessage{
    [self.carrierLabel setAlpha:0.0];
    [self.shadowView   setAlpha:1.0];
    [self.shadowView2  setAlpha:1.0];
    [self.errorMessage setAlpha:1.0];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(hideError)
                                   userInfo:nil
                                    repeats:NO];
    
}


- (void)hideError{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.shadowView   setAlpha:0.0];
        [self.shadowView2  setAlpha:0.0];
        [self.errorMessage setAlpha:0.0];
        [self.carrierLabel setAlpha:1.0];
    }];
    
}



#pragma mark - basic view methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewDidAppear:(BOOL)animated{
//    [self.inputNumberField becomeFirstResponder];
}




-(void)setSubviewAppearance{
    [self.view           setBackgroundColor:   UIColorFromRGB(0xffefeff4)];
    [self.numberInput    setBackgroundColor:   UIColorFromRGB(0xffefeff4)];
    [self.carrierLabel         setTextColor:   UIColorFromRGB(0xff7d7d7d)];
    [self.inputNumberField     setTintColor:   UIColorFromRGB(0xffff6368)];

    [self.carrierLabel              setFont:   HeitiSC_Medium(14)];
    [self.errorMessage              setFont : HeitiSC_Medium(14)];
    [self.countryCodeLabel1         setFont:   HeitiSC_Medium(14)];
    [self.countryCodeLabel2         setFont:   HeitiSC_Medium(14)];
    
    [self.skipButton.titleLabel     setFont:   HeitiSC_Medium(14)];
    
    [self.ccBrackets freeAutoLayout];
    [self.ccBrackets shiftFrameY:1.5];
    
    [self.countryCodeLabel2 freeAutoLayout];
    [self.countryCodeLabel2 shiftFrameY:-1];
    
    [self.continueButton setBackgroundColor:   HFThemePink];
    
    [HFUIHelpers roundCornerToHFDefaultRadius:self.continueButton];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.whiteBoxLeft];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.whiteBoxRight];
//    [HFUIHelpers roundCornerToHFDefaultRadius:self.nextButton];
    
    
    //numbers set to different font than default
    [self.countryCode setFont:HelveticaNeue_Regular(15)];
    
    //Hide Error messenging
    [self.errorMessage setAlpha:0.0];
    [self.shadowView   setAlpha:0.0];
    [self.shadowView2  setAlpha:0.0];
    [self.cursorNum    setAlpha:0.0];
    
    self.cursorRect = self.cursorNum.frame;
    
    self.cursorNum.layer.shouldRasterize = YES;
    
    self.cursorNum.layer.rasterizationScale = 2.0;
    
    [self.xInputButton   setHidden:YES];
    [self.spaceBox1      setHidden:YES];
    [self.spaceBox2      setHidden:YES];
    [self.continueButton setHidden:YES];
    
    [self.inputNumberField      setFont : HelveticaNeue_Regular(25)];
    [self.inputNumberField setTextColor : UIColorFromRGB(0xff000000)];
}


-(void)viewDidLayoutSubviews{
    // [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
    // [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
}

- (void)setupLoaderAnimation
{
    self.animationImageView.layer.zPosition = MAXFLOAT;
    self.animationImageView.animationDuration = 1.5;
    self.animationImageView.animationRepeatCount = MAXFLOAT;
    
    NSMutableArray *animationImages = [NSMutableArray new];
    for (int i = 0 ; i < 39; i++) {
        [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"reg_loader_%d",i]]];
    }
    
    self.animationImageView.animationImages = animationImages;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationItem.backBarButtonItem.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;

    _isCCChina = YES;
    [[ServerModel sharedManager] setCountryCode:self.ccNumbers.text];
    
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    [self setSubviewAppearance];
    [self setupLoaderAnimation];
    [_inputNumberField setParent:(id<echoDelegate>)self];
    [_inputNumberField setCursorNum:_cursorNum];
    
//    if (self.isFromUserSettings) {
//        self.navigationItem.rightBarButtonItem = nil;
////        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭"
////                                                                                style:UIBarButtonItemStylePlain
////                                                                               target:self
////                                                                               action:@selector(closeButtonClicked)];
//    }
    
    // Navigation Item
    //
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
//    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [[HFTencentService getInstance] initTencent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading:) name:HFLOGINSHOWMASK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading:) name:HFLOGINHIDEMASK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoadingAndEnter:) name:HFLOGINHIDEMASKANDENTER object:nil];
}

- (void)showLoading:(NSNotification *)notification{
    [SVProgressHUD show];
}

- (void)hideLoading:(NSNotification *)notification{
    [SVProgressHUD dismiss];
}

- (void)hideLoadingAndEnter:(NSNotification *)notification{
    
    [SVProgressHUD dismiss];
    UIStoryboard *hfmainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HFBrowersTabBarController *browserTabsViewController = [hfmainStoryboard instantiateViewControllerWithIdentifier:@"browserTabs"];
    NSLog(@"%@", [UIApplication sharedApplication].windows.lastObject);
    [[UIApplication sharedApplication].windows.firstObject setRootViewController:browserTabsViewController];

}
//
//- (void)leftBarButtonItemTapped {
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

- (void)closeButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self currentView:@"注册"];
    [self changeCountryCodeClicked:nil];
    [self changeCountryCodeClicked:nil];
}



- (void)selectCursor:(id)object{
    
}

- (IBAction)changeCountryCodeClicked:(id)sender {
    
    if (self.isCCChina) {
        _isCCChina = NO;
        _ccNumbers.text = @"1";
        _countryCodeLabel1.text = @"美国";

    }else{
        _isCCChina = YES;
        _ccNumbers.text = @"86";
        _countryCodeLabel1.text = @"中国";
    }
    
    //Animate fade-in/fade-out
    [UIView animateWithDuration:0.2 animations:^{
        [_ccNumbers setAlpha:0.0];
        [_countryCodeLabel1 setAlpha:0.0];
        _ccNumbers.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            [_ccNumbers setAlpha:1.0];
            [_countryCodeLabel1 setAlpha:1.0];
            _ccNumbers.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
        }];
    }];
    
    [UserServerApi sharedInstance].userCountryCode = self.ccNumbers.text;
//    [[ServerModel sharedManager] setCountryCode:self.ccNumbers.text];
}

- (IBAction)nextButtonClicked:(id)sender
{
    if ([self.inputNumberField.text isEqualToString:@""]) {
        [self showErrorMessage];
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnterCodeViewController *enterCodeVC  =  (EnterCodeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"enterCode"];
    
    [self.navigationController pushViewController:enterCodeVC animated:YES];
}

#pragma mark - Social Login Methods

- (IBAction)weiboLoginTapped:(id)sender {
    [self.view endEditing:YES];
    // Weibo login stuff here
    [Appsee addEvent:@"Weibo Login Button Clicked"];
    [[HFWeiboService getInstance] initWeiboLoginAuthorizeRequest];
}

- (IBAction)weChatLoginTapped:(id)sender {
    [self.view endEditing:YES];
    // WeChat login stuff here
    [Appsee addEvent:@"Wechat Login Button Clicked"];
    [[HFWeixinService getInstance] sendWechatAuthRequest];
}

- (IBAction)qqLoginTapped:(id)sender {
    [self.view endEditing:YES];
    // QQ login Stuff here
    [Appsee addEvent:@"QQ Login Button Clicked"];
    [[UserServerApi sharedInstance].currentUser.tencentOAuth authorize:[UserServerApi sharedInstance].currentUser.tencentPermissions inSafari:NO];
}



@end


