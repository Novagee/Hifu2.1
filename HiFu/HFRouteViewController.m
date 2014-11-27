//
//  HFRouteViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/13/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFRouteViewController.h"
#import "HFCityTableViewCell.h"
#import "HFFightTableViewCell.h"

@interface HFRouteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HFRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HFCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"HFCityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HFFightTableViewCell" bundle:nil] forCellReuseIdentifier:@"HFFightCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Slide up gesture
    //
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    
    
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint tranlate = [pan translationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (tranlate.y < 0) {
            self.view.transform = CGAffineTransformMakeTranslation(0, tranlate.y);
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (tranlate.y <= -self.view.bounds.size.height/2) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.view.transform = CGAffineTransformMakeTranslation(0, -self.view.height);
                             }
                             completion:^(BOOL finished){
                                 [self dismissViewControllerAnimated:NO completion:nil];
                             }];
        }
        else {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.view.transform = CGAffineTransformIdentity;
                             }];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const defaultCellIdentifier = @"Cell";
    
    if (indexPath.row == 1) {
        
        HFCityTableViewCell *cityTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"HFFightCell" forIndexPath:indexPath];
        
        return cityTableViewCell;
    }
    else if (indexPath.row == 0 || indexPath.row == 2){
        
        HFFightTableViewCell *fightTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"HFCityCell" forIndexPath:indexPath];
        
        return fightTableViewCell;
    }
    else if (indexPath.row == 3) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellIdentifier];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = cell.bounds;
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"＋ 添加航班信息" forState:UIControlStateNormal];
        
        [cell addSubview:button];
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellIdentifier];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = cell.bounds;
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"＋ 添加目的城市" forState:UIControlStateNormal];
        
        [cell addSubview:button];
        
        return cell;
        
    }
    // Configure the cell...

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return 135;
    }
    return 55;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
