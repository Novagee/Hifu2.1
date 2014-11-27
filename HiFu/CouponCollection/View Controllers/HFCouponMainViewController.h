//
//  HFCouponCollectionViewController.h
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBCollectionViewBalancedColumnLayout.h"

@interface HFCouponMainViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, RBCollectionViewBalancedColumnLayoutDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *loadingMoreView;
@property (nonatomic, weak) IBOutlet UIImageView *loadingMoreImageView;

- (IBAction)segmentedControlValueChanged:(id)sender;

@end
