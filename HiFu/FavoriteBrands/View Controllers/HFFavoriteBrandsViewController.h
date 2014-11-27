//
//  HFFavoriteBrandsViewController.h
//  HiFu
//
//  Created by Yin Xu on 7/15/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFavoriteBrandCell.h"

@interface HFFavoriteBrandsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, HFFavoriteBrandCell>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplay;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end
