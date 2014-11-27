//
//  HFCouponAddCommentViewController.m
//  HiFu
//
//  Created by Yin Xu on 8/4/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponAddCommentViewController.h"

//Objects
#import "CommentObject.h"
#import "CouponObject.h"
#import "UserObject.h"

//Apis
#import "CommentServerApi.h"
#import "UserServerApi.h"


@interface HFCouponAddCommentViewController ()

@end

@implementation HFCouponAddCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self.textView resignFirstResponder];
    
    if (![self.textView.text isEqualToString:@""] && ![self.textView.text isEqualToString:@"点击添加评论"]) {
        [CommentServerApi addCommentsForCouponId:self.coupon.itemId
                                      withUserId:[UserServerApi sharedInstance].currentUserId
                                      andContent:self.textView.text
                                         success:^{
                                             CommentObject *comment = [[CommentObject alloc] init];
                                             comment.userId = [UserServerApi sharedInstance].currentUserId;
                                             comment.content = self.textView.text;
                                             comment.couponId = self.coupon.itemId;
                                             comment.avatarNum = [UserServerApi sharedInstance].currentUser.avatarNum;
                                             [[NSNotificationCenter defaultCenter] postNotificationName:HFAddCommentSuccessfully object:comment userInfo:nil];
                                         } failure:^(NSError *error) {
                                             NSLog(@"%@", error);
                                         }];
    }
    else
    {
        self.textView.text = @"点击添加评论";
        self.textView.textColor = [UIColor lightGrayColor];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入评论" message:@"请在框内输入评论" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"点击添加评论"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    self.textCountLabel.text = [NSString stringWithFormat:@"%lu/140", 140- textView.text.length];
 
}

@end
