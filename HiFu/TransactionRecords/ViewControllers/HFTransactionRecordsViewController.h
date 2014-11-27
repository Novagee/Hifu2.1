//
//  HFTransactionRecordsViewController.h
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFTransactionRecordsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *noRecordImageView;

@end
