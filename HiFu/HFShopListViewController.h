//
//  HFitemListViewController.h
//  HiFu
//
//  Created by Peng Wan on 10/7/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kStoreCity) {
    
    kStoreCityAllCity = 100,
    kStoreCitySF,
    kStoreCityNY,
};

@interface HFShopListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) kStoreCity currentStoreCity;

@end
