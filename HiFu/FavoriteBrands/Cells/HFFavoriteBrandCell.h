//
//  HFFavoriteBrandCell.h
//  HiFu
//
//  Created by Yin Xu on 7/15/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"

@class MerchantObject;

@protocol HFFavoriteBrandCell;

@interface HFFavoriteBrandCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *brandLogoImageView;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) MerchantObject *merchant;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) id<HFFavoriteBrandCell> delegate;

- (IBAction)favoriteButtonClicked:(id)sender;

@end

@protocol HFFavoriteBrandCell <NSObject>

- (void)didFavoriteBrand:(MerchantObject *)merchant forCell:(HFFavoriteBrandCell *)cell;
- (void)didUnfavoriteBrand:(MerchantObject *)merchant forCell:(HFFavoriteBrandCell *)cell;

@end
