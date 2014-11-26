//
//  HFBrandListTableViewCell.h
//  HiFu
//
//  Created by Peng Wan on 10/7/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFShopListCellDelegate <NSObject>

- (void)handleShopListLikeButton:(UIButton *)likeButton;

@end

@class StoreObject;
@interface HFShopListTableViewCell : UITableViewCell

@property (weak, nonatomic) id <HFShopListCellDelegate> delegate;

@property (nonatomic, strong) StoreObject *store;

@property (assign, nonatomic) BOOL liked;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *storeNameCN;
@property (weak, nonatomic) IBOutlet UILabel *storeNameEN;
@property (weak, nonatomic) IBOutlet UILabel *storeLocationName;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *giftLabel;
@property (weak, nonatomic) IBOutlet UILabel *openStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogo;
@property (weak, nonatomic) IBOutlet UIImageView *discountImageView;
@property (weak, nonatomic) IBOutlet UIButton *discountLabel;

// Goods type controls
//
@property (weak, nonatomic) IBOutlet UILabel *firstGoodsTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondGoodsTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdGoodsTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstGoodsDot;
@property (weak, nonatomic) IBOutlet UIImageView *secondGoodsDot;

@property (weak, nonatomic) IBOutlet UILabel *firstServerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondServerLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdServerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondServerDot;
@property (weak, nonatomic) IBOutlet UIImageView *firstServerDot;

@property (weak, nonatomic) IBOutlet UIImageView *storeNameImage;
@property (weak, nonatomic) IBOutlet UILabel *openingTime;
@property (weak, nonatomic) IBOutlet UILabel *isOpeningLabel;


- (void)constructCellBasedOnCoupon:(StoreObject *)store;

@end
