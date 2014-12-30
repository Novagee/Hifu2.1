//
//  HFUploadBillViewController.m
//  HiFu
//
//  Created by Paul on 12/25/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFUploadBillViewController.h"
#import "Cloudinary/Cloudinary.h"
#import "SVProgressHUD.h"
#import "HFCouponApi.h"
#import "UserServerApi.h"

@interface HFUploadBillViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,CLUploaderDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainBottom;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userAlipayLabel;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *userEmailLabel;

@property (strong, nonatomic) NSArray *textFields;
@property (assign, nonatomic) NSInteger currentTextFieldIndex;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImage *uploadImage;

@end

@implementation HFUploadBillViewController

- (void)viewDidLoad {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Configure Left Bar button Item
    //
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xButton"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapped)];
    leftBarButton.tintColor = [UIColor colorWithRed:255/255 green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // Add observer for keyboard events
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
    // Configure image picker view controller
    //
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:0.910 green:0.314 blue:0.239 alpha:1.000];
    
    // Configure scroll view
    //
    _mainBottom.contentSize = CGSizeMake(self.mainBottom.width, self.view.height);
    
    // Use an array to mantain the text fields
    //
    _textFields = @[self.userNameLabel, self.userAlipayLabel, self.userPhoneLabel, self.userEmailLabel];
    _currentTextFieldIndex = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
 
    self.view.frame = CGRectMake(0, 64, self.view.width, [UIScreen mainScreen].bounds.size.height - 64);
    _mainBottom.frame = CGRectMake(0, 30, self.mainBottom.width, self.view.size.height - 30);

}

- (void)leftBarButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Notifications Stack

- (void)keyboardWillShow:(NSNotification *)notification {

    // Fetch keyboard rect and height
    //
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    // Resize the mainBottom frame
    //
    self.mainBottom.frame = CGRectMake(0, 30, self.mainBottom.width,
                                       self.view.height - 30 - keyboardHeight);
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    // Recover the mainBottom frame
    //
    self.mainBottom.frame = CGRectMake(0, 30, self.mainBottom.width, [UIScreen mainScreen].bounds.size.height - 30 - 64);

}

#pragma mark - UIImagePickerView Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Use these to fix the status bar issue
    //
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Fetch the
    _uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       _uploadImageView.image = self.uploadImage;
                   });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // Use these to fix the status bar issue
    //
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Control's Action

- (IBAction)uploadImageButtonTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从照片选择", nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)uploadDataTapped:(id)sender {
    [SVProgressHUD show];
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    [cloudinary.config setValue:Cloudinary_Cloud_Name forKey:@"cloud_name"];
    [cloudinary.config setValue:Cloudinary_APP_Key forKey:@"api_key"];
    [cloudinary.config setValue:Cloudinary_APP_secret forKey:@"api_secret"];
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    long long milliseconds = (long long)[[NSDate date] timeIntervalSince1970];
    NSString *public_id = [NSString stringWithFormat:@"%lld",milliseconds];
    [uploader upload:UIImageJPEGRepresentation(self.uploadImage, .5) options:@{@"public_id": [NSString stringWithFormat:@"%@%@",@"hifu/redeem/",public_id]}];
}

#pragma CLUploaderDelegate methods
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    NSString* publicId = [result valueForKey:@"public_id"];
    NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
    NSString *url=result[@"url"];
    if (url!=nil&&url.length>0) {
        NSString *userId=[UserServerApi sharedInstance].currentUserId;
        NSString *email=self.userEmailLabel.text;
        NSString *phone=self.userPhoneLabel.text;
        NSString *aliPay=self.userAlipayLabel.text;
        [HFCouponApi uploadReceiptWithUserId:userId withEmail:email withPhone:phone withAliPay:aliPay withReceiptUrl:url success:^{
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    }
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
    [SVProgressHUD dismiss];
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _currentTextFieldIndex = textField.tag;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.currentTextFieldIndex <= 2) {
        
        // Move the currentTextField index to next
        //
        _currentTextFieldIndex++;
        
        // Fetch the next textField and make it become the first responser
        //
        UITextField *nextTextField = self.textFields[self.currentTextFieldIndex];
        [nextTextField becomeFirstResponder];
        
    }
    else {
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}

#pragma mark - Action sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        // Fetch image from camera
        //
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        
    }
    else if (buttonIndex == 1){
    
        // Fetch image from photo library
        //
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        
    }
    
}

@end
