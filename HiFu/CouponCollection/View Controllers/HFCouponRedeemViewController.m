//
//  HFCouponRedeemViewController.m
//  HiFu
//
//  Created by Yin Xu on 8/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCouponRedeemViewController.h"
#import "UIImageView+WebCache.h"

#import "HFCouponRedeemSuccessViewController.h"
#import "HFCouponRedeemFailedViewController.h"
//Objects
#import "CouponObject.h"


@interface HFCouponRedeemViewController ()
{
    UIView *expandedView;
}

@property (nonatomic, assign) HFCouponRedeemFailureType failureType;

@end

@implementation HFCouponRedeemViewController

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
    [self setupViewComponents];
    [self loadCouponImages];
}

- (void)setupViewComponents
{
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];
    self.navigationItem.title = @"Promotion";
    
    if (HF_IS_IPHONE4) {
        self.bottomTitleLabel.frame = CGRectMake(self.bottomTitleLabel.origin.x, 8, self.bottomTitleLabel.width, self.bottomTitleLabel.height);
        self.bottomMiddleLabel.frame = CGRectMake(self.bottomMiddleLabel.origin.x, self.bottomTitleLabel.bottom + 8, self.bottomMiddleLabel.width, self.bottomMiddleLabel.height);
        self.couponErrorView.frame = CGRectMake(44, self.bottomMiddleLabel.bottom + 8, 112, 107);
        self.moneyErrorView.frame = CGRectMake(self.couponErrorView.right + 8, self.bottomMiddleLabel.bottom + 8, 112, 107);
        self.storeErrorView.frame = CGRectMake(44, self.couponErrorView.bottom + 8, 112, 107);
        self.timeErrorView.frame = CGRectMake(self.storeErrorView.right + 8, self.couponErrorView.bottom + 8, 112, 107);
    }
    
    self.failureType = HFCouponFailureUnknow;
    
    self.imageScrollView.minimumZoomScale=1.0f;
    self.imageScrollView.maximumZoomScale=3.0f;
    self.imageScrollView.delegate = self;
    [self.imageScrollView setShowsHorizontalScrollIndicator:NO];
    [self.imageScrollView setShowsVerticalScrollIndicator:NO];
    if (self.coupon.hasRedeemCode) {
        self.promotionCodeLabel.text = self.coupon.redeemCode;
    }
    [HFUIHelpers roundCornerToHFDefaultRadius:self.appliedButton];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.sorryButton];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.showCrashierLabelView];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.showToCustomerButton];
    
    self.showCrashierLabelView.layer.borderColor = self.couponImageWrapperView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.showCrashierLabelView.layer.borderWidth = self.couponImageWrapperView.layer.borderWidth = 0.5f;
    
    [HFUIHelpers roundCornerToHFDefaultRadius:self.couponErrorView];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.moneyErrorView];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.storeErrorView];
    [HFUIHelpers roundCornerToHFDefaultRadius:self.timeErrorView];
   
    self.couponErrorView.layer.borderColor = self.moneyErrorView.layer.borderColor = self.storeErrorView.layer.borderColor = self.timeErrorView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.couponErrorView.layer.borderWidth = self.moneyErrorView.layer.borderWidth = self.storeErrorView.layer.borderWidth = self.timeErrorView.layer.borderWidth = 0.5f;;
}

- (void)loadCouponImages
{
    if (self.coupon.redeemImage) {
        self.redeemImageView.image = self.coupon.redeemImage;
    }
    else
    {
        [self.redeemImageView setImageWithURL:[NSURL URLWithString:self.coupon.redeemCodePic]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        if (image && !error) {
                                            self.redeemImageView.image = image;
                                            self.coupon.redeemImage = image;
                                        }
                                    }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.redeemImageView;
}


#pragma mark - Action Methods
- (IBAction)expandButtonTapped:(id)sender
{
    if (!expandedView)
    {
        expandedView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        expandedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//        UIScrollView *imageZoomView = [[UIScrollView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//        imageZoomView.delegate = self;
//        imageZoomView.minimumZoomScale=1.0f;
//        imageZoomView.maximumZoomScale=3.0f;
//        [imageZoomView setShowsHorizontalScrollIndicator:NO];
//        [imageZoomView setShowsVerticalScrollIndicator:NO];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:expandedView.bounds];
        imageView.image = self.coupon.redeemImage;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tapOnExpandedView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissExpandedView)];
        [expandedView addGestureRecognizer:tapOnExpandedView];
        [expandedView addSubview:imageView];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:expandedView];
}

- (void)dismissExpandedView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        expandedView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [expandedView removeFromSuperview];
        expandedView = nil;
    }];
}

- (IBAction)acceptCouponTapped:(id)sender
{
    HFCouponRedeemSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HFCouponRedeemSuccessViewController"];
    vc.blurBackgroundImage = [HFUIHelpers takeScreenShotForViewController:self andApplyBlurEffect:YES andBlurRadius:8];
    vc.coupon = self.coupon;
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)notAcceptCoupontTapped:(id)sender
{
    [self.appliedButton setImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateNormal];
    [self.appliedButton setTitle:@"Back to Applied" forState:UIControlStateNormal];
    [self.appliedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -13, 0, 0)];
    [self.appliedButton setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.appliedButton removeTarget:self action:@selector(acceptCouponTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.appliedButton addTarget:self action:@selector(backToAppliedTapped) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.topWrapperView.frame = CGRectMake(0, HF_IS_IPHONE4 ? -361 : -449, 320, self.topWrapperView.height);
        self.bottomWrapperView.frame = CGRectMake(0, 55, 320, self.bottomWrapperView.height);
    } completion:nil];
}

- (void)backToAppliedTapped
{
    [self.appliedButton setImage:nil forState:UIControlStateNormal];
    [self.appliedButton setTitle:@"Applied" forState:UIControlStateNormal];
    [self.appliedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.appliedButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.appliedButton removeTarget:self action:@selector(backToAppliedTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.appliedButton addTarget:self action:@selector(acceptCouponTapped:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.topWrapperView.frame = CGRectMake(0, 0, 320, self.topWrapperView.height);
        self.bottomWrapperView.frame = CGRectMake(0, self.topWrapperView.height, 320, self.bottomWrapperView.height);
    } completion:nil];
}

- (IBAction)showToCustomerTapped:(id)sender
{
    if (self.failureType == HFCouponFailureUnknow) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select one reason" message:@"Please select one reason for this customer, or just click the 'Sorry' button on the top right corner." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        HFCouponRedeemFailedViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HFCouponRedeemFailedViewController"];
        vc.failureType = self.failureType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)couponFailureTapped:(id)sender
{
    if (self.failureType != HFCouponWrongCouponError)
    {
        [self resetErrorViewForType:self.failureType];
        self.failureType = HFCouponWrongCouponError;
        self.couponErrorView.backgroundColor = [UIColor colorWithRed:0.427 green:0.776 blue:0.992 alpha:1.000];
        self.couponErrorImageView.image = [UIImage imageNamed:@"coupon_error_white"];
        self.couponErrorLabel.textColor = [UIColor whiteColor];
    }
}

- (IBAction)moneyFailureTapped:(id)sender
{
    if (self.failureType != HFCouponMoneyError)
    {
        [self resetErrorViewForType:self.failureType];
        self.failureType = HFCouponMoneyError;
        self.moneyErrorView.backgroundColor = [UIColor colorWithRed:0.427 green:0.776 blue:0.992 alpha:1.000];
        self.moneyErrorImageView.image = [UIImage imageNamed:@"money_error_white"];
        self.moneyErrorLabel.textColor = [UIColor whiteColor];
    }
}

- (IBAction)storeFailureTapped:(id)sender
{
    if (self.failureType != HFCouponStoreError)
    {
        [self resetErrorViewForType:self.failureType];
        self.failureType = HFCouponStoreError;
        self.storeErrorView.backgroundColor = [UIColor colorWithRed:0.427 green:0.776 blue:0.992 alpha:1.000];
        self.storeErrorImageView.image = [UIImage imageNamed:@"shop_error_white"];
        self.storeErrorLabel.textColor = [UIColor whiteColor];
    }
}

- (IBAction)timeFailureTapped:(id)sender
{
    if (self.failureType != HFCouponTimeError)
    {
        [self resetErrorViewForType:self.failureType];
        self.failureType = HFCouponTimeError;
        self.timeErrorView.backgroundColor = [UIColor colorWithRed:0.427 green:0.776 blue:0.992 alpha:1.000];
        self.timeErrorImageView.image = [UIImage imageNamed:@"time_error_white"];
        self.timeErrorLabel.textColor = [UIColor whiteColor];
    }
}

- (void)resetErrorViewForType:(HFCouponRedeemFailureType)errorType
{
    switch (errorType) {
        case HFCouponWrongCouponError:
            self.couponErrorView.backgroundColor = [UIColor clearColor];
            self.couponErrorImageView.image = [UIImage imageNamed:@"coupon_error"];
            self.couponErrorLabel.textColor = [UIColor blackColor];
            break;
        case HFCouponMoneyError:
            self.moneyErrorView.backgroundColor = [UIColor clearColor];
            self.moneyErrorImageView.image = [UIImage imageNamed:@"money_error"];
            self.moneyErrorLabel.textColor = [UIColor blackColor];
            break;
        case HFCouponStoreError:
            self.storeErrorView.backgroundColor = [UIColor clearColor];
            self.storeErrorImageView.image = [UIImage imageNamed:@"shop_error"];
            self.storeErrorLabel.textColor = [UIColor blackColor];
            break;
        case HFCouponTimeError:
            self.timeErrorView.backgroundColor = [UIColor clearColor];
            self.timeErrorImageView.image = [UIImage imageNamed:@"time_error"];
            self.timeErrorLabel.textColor = [UIColor blackColor];
            break;
        default:
            break;
    }
}

@end
