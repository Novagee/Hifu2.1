//
//  HFCouponDetailViewController.h
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "HFCouponDetailInfoCell.h"
#import "HFShareView.h"

@class CouponObject;
@interface HFCouponDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HFCouponDetailInfoCellDelegate, HFShareViewDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *couponCoverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *couponLogoImageView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *useCouponButton;
@property (nonatomic, weak) IBOutlet UIView *downloadingView;
@property (nonatomic, weak) IBOutlet UIProgressView *downloadingProgressView;
@property (nonatomic, weak) IBOutlet UILabel *downloadSuccessLabel;
@property (nonatomic, weak) IBOutlet UILabel *downloadingLabel;

@property (nonatomic, strong) CouponObject *coupon;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) UIImage *couponLogoImage;
@property (nonatomic, assign) BOOL shouldLoadFromDownloadedCopy;

- (IBAction)redeemCoupon:(id)sender;

@end
