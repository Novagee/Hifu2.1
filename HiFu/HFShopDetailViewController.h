//
//  HFShopDetailViewController.h
//  HiFu
//
//  Created by Peng Wan on 10/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreObject;
@interface HFShopDetailViewController : UIViewController

@property (strong, nonatomic) StoreObject *cellInfo;

/**
 @brief Pass a value that contain the store's open time from the HFShopListTableViewCell
 */
@property (copy, nonatomic) NSString *openingTime;

/**
 @brief Pass a value that decide the store's open status from the HFShopListTableViewCell
 */
@property (copy, nonatomic) NSString *isOpening;

@property (weak, nonatomic) IBOutlet UIButton *wifiButton;
@property (weak, nonatomic) IBOutlet UIButton *chineseButton;
@property (weak, nonatomic) IBOutlet UIButton *hotTeaButton;

@end
