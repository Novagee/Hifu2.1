//
//  YXMeInfoSettingViewController.h
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserObject;
@interface YXMeInfoSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) UserObject *currentUser;

- (IBAction)doneButtonClicked:(id)sender;

@end
