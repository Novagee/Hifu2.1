//
//  HFFavoriteBrandsViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/15/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "UIImageView+WebCache.h"

#import "HFFavoriteBrandsViewController.h"

//Apis
#import "MerchantsServerApi.h"
#import "UserServerApi.h"

//Objects
#import "UserObject.h"
#import "MerchantObject.h"

//Helper
#import "HFGeneralHelpers.h"

@interface HFFavoriteBrandsViewController ()
{
    NSMutableArray *merchantsArray, *favoriteMerchantIdArray;
    NSArray *searchResultArray;;
}

@end

@implementation HFFavoriteBrandsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"偏好品牌";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.view.backgroundColor = HFThemePink;

    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame), 0);
    [self.searchDisplayController.searchBar setBackgroundImage:[HFGeneralHelpers imageWithColor:HFThemePink]
                                                forBarPosition:0
                                                    barMetrics:UIBarMetricsDefault];
    self.searchDisplayController.searchBar.delegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:HFDarkGray];
    [HFUIHelpers removeBottomBorderFromNavBar:self.navigationController.navigationBar];
  
    
    [self.tableView registerNib:[HFFavoriteBrandCell cellNib] forCellReuseIdentifier:[HFFavoriteBrandCell reuseIdentifier]];
    [self.searchDisplayController.searchResultsTableView registerNib:[HFFavoriteBrandCell cellNib] forCellReuseIdentifier:[HFFavoriteBrandCell reuseIdentifier]];

    [self getMerchants];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Api calls
- (void)getMerchants
{
    merchantsArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFMerchantsPath]];
    if (!merchantsArray) {
        merchantsArray = [NSMutableArray new];
    }
    else
    {
        [HFGeneralHelpers deleteDataFileAtPath:[HFGeneralHelpers dataFilePath:HFMerchantsPath]];
    }
    
    [MerchantsServerApi getMerchantsForUser:[UserServerApi sharedInstance].currentUser.itemId
                                withTimeStamp:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantUpdatedTimeStamp"]
                                      success:^(id allUpdatedMerchants, id favoriteMerchantId) {
                                          for (NSDictionary *dict in allUpdatedMerchants) {
                                              MerchantObject *m = [[MerchantObject alloc] initWithDictionary:dict];
                                              [merchantsArray addObject:m];
                                          }
                                          favoriteMerchantIdArray = (NSMutableArray *)favoriteMerchantId;
                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
                                              [HFGeneralHelpers saveData:merchantsArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFMerchantsPath]];
                                          });
                                          [self.tableView reloadData];
                                      } failure:^(NSError *error) {
        
                                      }];
}

- (void)favoriteMerchantId:(NSString *)merchantId
{
    [MerchantsServerApi favoriteMerchantsId:merchantId
                                   withUserId:[UserServerApi sharedInstance].currentUser.itemId
                                      success:^{
                                          NSLog(@"Favorite Branding Success");
                                      } failure:^(NSError *error) {
                                          NSLog(@"%@", error);
                                      }];
}

- (void)unfavoriteMerchantId:(NSString *)merchantId
{
    [MerchantsServerApi unfavoriteMerchantsId:merchantId
                                   withUserId:[UserServerApi sharedInstance].currentUser.itemId
                                      success:^{
                                        NSLog(@"Unfavorite Branding Success");
                                      } failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                      }];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResultArray count];
    }
    return [merchantsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HFFavoriteBrandCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFFavoriteBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFFavoriteBrandCell reuseIdentifier]];
    cell.delegate = self;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.merchant = [searchResultArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.merchant = [merchantsArray objectAtIndex:indexPath.row];
    }
    
    if ([favoriteMerchantIdArray containsObject:@([cell.merchant.itemId intValue])]) {
        cell.isFavorite = YES;
        [cell.favoriteButton setImage:[UIImage imageNamed:@"heart_button_selected"]
                             forState:UIControlStateNormal];
    }
    else
    {
        cell.isFavorite = NO;
        [cell.favoriteButton setImage:[UIImage imageNamed:@"heart_button"]
                             forState:UIControlStateNormal];
    }
    
    [cell.brandLogoImageView setImageWithURL:[NSURL URLWithString:cell.merchant.logoPictureUrl]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      if (image && !error) {
                                          cell.brandLogoImageView.image = image;
                                          cell.brandLogoImageView.clipsToBounds = YES;

                                      }
                              }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableView Delegate


#pragma mark - UISearchDisplayController Delegate
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if (!searchResultArray) {
        searchResultArray = [NSMutableArray new];
    }
}

#pragma mark - UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR nameCn CONTAINS[cd] %@ OR alias CONTAINS [cd] %@ OR aliasCn CONTAINS [cd] %@", searchText, searchText, searchText, searchText];
    searchResultArray = [merchantsArray filteredArrayUsingPredicate:resultPredicate];
    if ([searchText isEqualToString:@""]) {
        //if the search string is empty, we go back to the entire list
        searchResultArray = merchantsArray;
    }
    
    [self.tableView reloadData];
}

#pragma mark - HFFavoriteBrandCell Delegate
- (void)didFavoriteBrand:(MerchantObject *)merchant forCell:(HFFavoriteBrandCell *)cell
{
    [self favoriteMerchantId:merchant.itemId];
}

- (void)didUnfavoriteBrand:(MerchantObject *)merchant forCell:(HFFavoriteBrandCell *)cell
{
    [self unfavoriteMerchantId:merchant.itemId];
}

@end
