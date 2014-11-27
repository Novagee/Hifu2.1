//
//  YXShoppingListViewController.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/19/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>
@interface YXShoppingListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *slSegmentedControl;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *noItemImageView;

- (IBAction)slSgementedControlValueChanged:(id)sender;

@end
