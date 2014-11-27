//
//  HFCouponDetailInfoCell.h
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"
@class CouponObject;
@protocol HFCouponDetailInfoCellDelegate;

@interface HFCouponDetailInfoCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UITextView *couponDescriptionTextView;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *heartButton;
@property (nonatomic, weak) IBOutlet UIButton *moreButton;
@property (nonatomic, weak) IBOutlet UIImageView *moreImageView;

@property (nonatomic, assign) id<HFCouponDetailInfoCellDelegate> delegate;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL canExpand;
@property (nonatomic, assign) BOOL isFavorite;

+ (float)cellHeightForCoupon:(CouponObject *)coupon isExpanded:(BOOL)expanded;

- (IBAction)moreButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)heartButtonTapped:(id)sender;

@end

@protocol HFCouponDetailInfoCellDelegate <NSObject>

-(void)couponDetailInfoCellMoreButtonTapped;
-(void)couponDetailInfoCellShareButtonTapped;
-(void)couponDetailInfoCellHeartButtonTapped;

@end