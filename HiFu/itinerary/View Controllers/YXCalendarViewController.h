//
//  YXViewController.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarView.h"
#import "YXDestinationSearchView.h"

@interface YXCalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, YXCalendarViewDelegate, YXDestinationSearchViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *hintLabel;
@property (nonatomic, weak) IBOutlet YXCalendarView *calendarView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;

- (IBAction)editButtonClicked:(id)sender;

@end


