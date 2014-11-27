//
//  HFMyFavCouponViewController.m
//  HiFu
//
//  Created by Peng Wan on 10/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFMyFavoritesViewController.h"
#import "HFRangeViewController.h"
#import "HFShopMapViewController.h"
#import "HFShopListTableViewCell.h"
#import "HFShopDetailViewController.h"

#import "HFWifiViewController.h"
#import "HFHotTeaViewController.h"
#import "HFChineseHelpViewController.h"
#import "HFUserApi.h"
#import "UserServerApi.h"
#import "StoreObject.h"
#import "HFUIHelpers.h"
#import "HFGeneralHelpers.h"
#import "UIView+EasyFrames.h"
#import <POP/POP.h>

@interface HFMyFavoritesViewController ()<HFShopListCellDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *favSegment;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HFShopMapViewController *mapViewController;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *storeView;
@property (strong, nonatomic) NSArray *storesArray;
@property (weak, nonatomic) IBOutlet UIView *firstShareBottom;

@end

@implementation HFMyFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerCustomCellsFromNibs];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray* collectedStores = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
    
    // Hide bottom mask if the user already have their favourite store
    //
    self.firstShareBottom.hidden = NO;
    if (collectedStores.count) {
        self.firstShareBottom.hidden = YES;
    }
    
    if (!collectedStores) {
        self.storesArray = [NSArray new];
    }else{
        self.storesArray = [collectedStores copy];
    }
    NSLog(@"storesArrayCount:%i",self.storesArray.count);
}

- (IBAction)segmentTapped:(id)sender {
    switch (self.favSegment.selectedSegmentIndex) {
            
        case 0:
        {
            self.couponView.hidden = NO;
            self.storeView.hidden = YES;
            break;
        }
        case 1:
        {
            self.couponView.hidden = YES;
            self.storeView.hidden = NO;
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HFShopListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HFShopListTableViewCell"];
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return self.storesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 348.0f;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFShopListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HFShopListTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.store = [self.storesArray objectAtIndex:indexPath.row];
    [cell constructCellBasedOnCoupon:cell.store];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFShopDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"shopDetail"];
    
    detailViewController.cellInfo = self.storesArray[indexPath.row];
    
    // Fetch the cell and pass the store opening time stuff
    //
    HFShopListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HFShopListTableViewCell" forIndexPath:indexPath];
    cell.store = [self.storesArray objectAtIndex:indexPath.row];
    [cell constructCellBasedOnCoupon:cell.store];
    
    detailViewController.openingTime = cell.openingTime.text;
    detailViewController.isOpening = cell.isOpeningLabel.text;
    
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@ vs %@", detailViewController.openingTime, detailViewController.isOpening);
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (IBAction)rangeButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)showMapView:(id)sender {
    
    [UIView beginAnimations:@"animation" context:nil];
    self.mapViewController.view.alpha = 1.0f;
    [self.navigationController pushViewController:self.mapViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
}

#pragma mark - Test Cell Delegate

- (void)handleShopListLikeButton:(UIButton *)likeButton {
    
    UIView *view = likeButton;
    
    while (! [view isKindOfClass:[HFShopListTableViewCell class]]) {
        view = view.superview;
    }
    
    HFShopListTableViewCell *shopListTableViewCell = (HFShopListTableViewCell *)view;
    shopListTableViewCell.isliked = !shopListTableViewCell.isliked;
    [likeButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    [self unfavoriteStoreId:shopListTableViewCell.store forCell:shopListTableViewCell];
    return;
}

- (void)favouriteAnimationWithButton:(UIButton *)likeButton {
    
    // Convert the like button's center to window
    //
    UIView *view = likeButton;
    while (! [view isKindOfClass:[HFShopListTableViewCell class]]) {
        view = view.superview;
    }
    HFShopListTableViewCell *shopListTableViewCell = (HFShopListTableViewCell *)view;
    
    CGPoint likeButtonCenter = [shopListTableViewCell convertPoint:likeButton.center toView:self.view.window];
    
    // Duplicate a fake like button for animation
    //
    UIView *fakeLikeButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like"]];
    fakeLikeButton.center = likeButtonCenter;
    
    [self.view.window addSubview:fakeLikeButton];
    
    // Fetch the tab Bar Item
    //
    CGPoint finalPoint = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.63f, [UIScreen mainScreen].bounds.size.height - 30);
    
    // Configure the like animation
    //
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:likeButtonCenter];
    [path addLineToPoint:likeButtonCenter];
    [path addLineToPoint:[self makeTopPoint:likeButtonCenter]];
    [path addLineToPoint:finalPoint];
    [path addLineToPoint:finalPoint];
    pathAnimation.path = path.CGPath;
    
    pathAnimation.keyTimes = @[@(0), @(0.2), @(0.5), @(0.9), @(1)];
    pathAnimation.duration = 0.7f;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)]
                              ];
    scaleAnimation.keyTimes =  @[@(0), @(0.3), @(0.5), @(0.7), @(1)];
    
    scaleAnimation.duration = 0.7f;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[pathAnimation, scaleAnimation];
    animationGroup.duration = 0.7f;
    
    [fakeLikeButton.layer addAnimation:animationGroup forKey:@""];
    
    // Remove the fake like button once the animation stop
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fakeLikeButton removeFromSuperview];
    });
    
}

- (CGPoint)makeTopPoint:(CGPoint)startPoint {
    
    return CGPointMake(startPoint.x - 30, startPoint.y - 30);
    
}

- (void)unfavoriteStoreId:(StoreObject *)store forCell:(HFShopListTableViewCell *)cell{
    //call api
    [HFUserApi unfavoriteStoreId:store.storeId
                      withUserId:[UserServerApi sharedInstance].currentUserId//@5
                         success:^{
                             NSLog(@"Unfavorite Store Success");
                             //remove from local
                             NSMutableArray* storeArray = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                             for (StoreObject *storeObj in storeArray) {
                                 if (storeObj&&storeObj.storeId&&storeObj.storeId == store.storeId) {
                                     [storeArray removeObject:storeObj];
                                     self.storesArray = [storeArray copy];
                                     NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
                                     [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
                                     
                                     break;
                                 }
                             }
                             [HFGeneralHelpers saveData:storeArray toFileAtPath:[HFGeneralHelpers dataFilePath:HFStoresPath]];
                             [self.tableView reloadData];
                             if (storeArray.count==0) {
                                 self.firstShareBottom.hidden = NO;
                             }
                             [[NSNotificationCenter defaultCenter] postNotificationName:HFRemoveStoreToFavorite object:store userInfo:nil];
                             
                             // Hide bottom mask if the user already have their favourite store
                             //
                             if (! self.storesArray.count) {
                                 self.firstShareBottom.hidden = NO;
                             }
                             
                             NSLog(@"Store Removed From Local");
                         } failure:^(NSError *error) {
                             NSLog(@"%@", error);
                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
