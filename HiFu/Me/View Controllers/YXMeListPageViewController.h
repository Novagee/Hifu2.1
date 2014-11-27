//
//  YXMeListPageViewController.h
//  HiFu
//
//  Created by Yin Xu on 7/1/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFLikeusTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface YXMeListPageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *hifuServiceImageView;

@end
