//
//  HFStoreIntroductionViewController.h
//  HiFu
//
//  Created by Peng Wan on 11/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFStoreIntroductionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *detailIntroduction;
@property (copy, nonatomic) NSString *detailText;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogo;
@property (strong, nonatomic) NSString *storeLogoURL;

@end
