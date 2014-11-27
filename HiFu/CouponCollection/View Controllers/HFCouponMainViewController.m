//
//  HFCouponCollectionViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/21/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFCouponMainViewController.h"
#import "HFCouponDetailViewController.h"

//Cell
#import "HFCouponCell.h"
//#import "HFCouponShortCell.h"
#import "HFAlertView.h"

//Apis
#import "CouponServerApi.h"
#import "UserServerApi.h"

//Objects
#import "CouponObject.h"

//Helper
#import "HFGeneralHelpers.h"
#import "HFLocationManager.h"
#import "HFCouponRelatedTypeEnum.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"

@interface HFCouponMainViewController ()
{
    NSMutableArray *couponsArray, *favoriteCouponsArray;
    BOOL hasMoreToLoad, shouldFilp;
    int currentPageNumber;
    CGPoint allCouponContentOffset, favoriteCouponContentOffset;
    id getNewCouponeRequest;
}

@end

@implementation HFCouponMainViewController

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
    couponsArray = [NSMutableArray new];
    favoriteCouponsArray = [NSMutableArray new];
    currentPageNumber = 0;
    [[HFLocationManager sharedInstance] startUpdatingLocation];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0.5, 0, 0, 0)];
    [self.collectionView registerNib:[HFCouponCell cellNib] forCellWithReuseIdentifier:[HFCouponCell reuseIdentifier]];
    
    [self setupLoadingMoreView];
    if ([HFGeneralHelpers isInternetReachable])
    {
        self.segmentedControl.selectedSegmentIndex = 0;
        shouldFilp = NO;
        [self getNewCoupons];
    }
    else
    {
        self.segmentedControl.selectedSegmentIndex = 1;
        [self getUserFavoriteCoupons];
    }
    
    [self setupNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupViewComponents];
    [self setupPullToRefresh];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViewComponents
{
    self.navigationItem.title = @"优惠券";
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponAddedToFavorite:) name:HFAddCouponToFavorite object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponRemovedToFavorite:) name:HFRemoveCouponFromFavorite object:nil];
}

- (void)setupLoadingMoreView
{
    self.loadingMoreView.hidden = YES;
    
    self.loadingMoreImageView.layer.zPosition = MAXFLOAT;
    self.loadingMoreImageView.animationDuration = 1.4;
    self.loadingMoreImageView.animationRepeatCount = MAXFLOAT;
    
    NSMutableArray *animationImages = [NSMutableArray new];
    for (int i = 0 ; i < 11; i++) {
        [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"couponLoadMore_%d",i]]];
    }
    
    self.loadingMoreImageView.animationImages = animationImages;
}

-(void)setupPullToRefresh
{
    [self.collectionView addPullToRefreshActionHandler:^{
        if (self.segmentedControl.selectedSegmentIndex == 0)
        {
            currentPageNumber = 0;
            shouldFilp = NO;
            [getNewCouponeRequest cancel];
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(getNewCoupons)
                                           userInfo:nil
                                            repeats:NO];
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self.collectionView
                                           selector:@selector(stopRefreshAnimation)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
                                   ProgressImagesGifName:@"loadingA.gif"
                                    LoadingImagesGifName:@"loadingA.gif"
                                 ProgressScrollThreshold:40
                                   LoadingImageFrameRate:60];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToCouponDetailPage"]) {
        HFCouponDetailViewController *vc = segue.destinationViewController;
        HFCouponCell *cell = sender;
        vc.coupon = cell.coupon;
        vc.isFavorite = [favoriteCouponsArray containsObject:cell.coupon];
        vc.couponLogoImage = cell.logoImageView.image;
    }
}

#pragma mark - API Calls
- (void)getNewCoupons
{
    currentPageNumber ++;
    getNewCouponeRequest = [CouponServerApi getCouponsForLocation:[HFLocationManager sharedInstance].currentLocation
                                pageNumber:currentPageNumber
                             couponPerPage:10
                                   success:^(id coupons) {
                                       if (currentPageNumber == 1) {
                                           [couponsArray removeAllObjects];
                                       }
                                       for (NSDictionary *dict in coupons) {
                                           CouponObject *coupon = [[CouponObject alloc] initWithDictionary:dict];
                                           [couponsArray addObject:coupon];
                                       }
                                       hasMoreToLoad = ([coupons count] == 10);
                                       [self hideLoadMore];
                                       [self.collectionView stopRefreshAnimation];
                                       if (shouldFilp) {
                                           [self flipToAllCoupons];
                                       }
                                       [self.collectionView reloadData];
                                   } failure:^(NSError *error) {
                                       NSLog(@"%@", error);
                                       if (error.code == 9999) {
                                           //this is when internet is not reachable, we check if there is any downloaded coupon
                                       }
                                   }];
}

- (void)getUserFavoriteCoupons
{
    //我们直接读取用户存于本地的Coupon,在UserDefaults里面有一个id array,对应的每个id在本地都有一个archived file
    if([[NSUserDefaults standardUserDefaults] objectForKey:HFDownloadedCoupons])
    {
        hasMoreToLoad = NO;
        for (NSString *couponId in [[NSUserDefaults standardUserDefaults] objectForKey:HFDownloadedCoupons]) {
            CouponObject *coupon = [HFGeneralHelpers getDataForFilePath:[HFGeneralHelpers dataFilePath:HFCouponPathWithId(couponId)]];
            [favoriteCouponsArray addObject:coupon];
        }
        [self hideLoadMore];
        [self.collectionView stopRefreshAnimation];
        [self.collectionView reloadData];
    }
}

#pragma mark - Action Methods
- (IBAction)segmentedControlValueChanged:(id)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        if ([HFGeneralHelpers isInternetReachable]) {
            if (couponsArray && [couponsArray count] > 0) {
                [self flipToAllCoupons];
                [self.collectionView reloadData];
            }
            else
            {
                shouldFilp = YES;
                [self getNewCoupons];
            }
        }
        else
        {
            [HFAlertView show];
            self.segmentedControl.selectedSegmentIndex = 1;
        }
    }
    else {
        if (!favoriteCouponsArray || [favoriteCouponsArray count] == 0) {
            [self getUserFavoriteCoupons];
        }
        [self.collectionView reloadData];
        [self flipToFavoriteCoupons];
    }
}

- (void)flipToAllCoupons
{
    favoriteCouponContentOffset = self.collectionView.contentOffset;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.collectionView cache:NO];
    [UIView commitAnimations];
    [self.collectionView setContentOffset:allCouponContentOffset animated:NO];
}

- (void)flipToFavoriteCoupons
{
    allCouponContentOffset = self.collectionView.contentOffset;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.collectionView cache:NO];
    [UIView commitAnimations];
    [self.collectionView setContentOffset:favoriteCouponContentOffset animated:NO];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.segmentedControl.selectedSegmentIndex == 0 ? [couponsArray count] : [favoriteCouponsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [couponsArray count]-1 &&hasMoreToLoad && self.loadingMoreView.hidden) {
        [self showLoadMore];
    }
    
    HFCouponCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HFCouponCell reuseIdentifier] forIndexPath:indexPath];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        cell.coupon = [couponsArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.coupon = [favoriteCouponsArray objectAtIndex:indexPath.row];
    }
    
    cell.hifuRibbonImageView.hidden = !cell.coupon.isContractor;

    cell.wrappViewLeftSpaceConstraint.constant = indexPath.row % 2 ? 4 : 5;
    cell.wrappViewRightSpaceConstraint.constant = indexPath.row % 2 ? 5 : 4;
    [cell constructCellBasedOnCoupon:cell.coupon];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(RBCollectionViewBalancedColumnLayout*)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row % 2 ? 262 : 244;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(RBCollectionViewBalancedColumnLayout*)collectionViewLayout
 heightForFooterInSection:(NSInteger)section
{
	return 50.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(RBCollectionViewBalancedColumnLayout *)collectionViewLayout
   widthForCellsInSection:(NSInteger)section
{
    return 160;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [couponsArray count]-1 && hasMoreToLoad && self.loadingMoreView.hidden)
        return; //that's load more cell do nothing
    else
        [self performSegueWithIdentifier:@"pushToCouponDetailPage" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark - Load More Helpers
- (void)showLoadMore
{
    self.loadingMoreView.hidden = NO;
    [self.loadingMoreImageView startAnimating];
    shouldFilp = NO;
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(getNewCoupons)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)hideLoadMore
{
    self.loadingMoreView.hidden = YES;
    [self.loadingMoreImageView stopAnimating];
}

#pragma mark - Helper Methods
- (void)couponAddedToFavorite:(NSNotification *)notification
{
    CouponObject *coupon = notification.object;
    if (![favoriteCouponsArray containsObject:coupon]) {
        [favoriteCouponsArray addObject:coupon];
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.collectionView reloadData];
    }
}

- (void)couponRemovedToFavorite:(NSNotification *)notification
{
    CouponObject *coupon = notification.object;
    if ([favoriteCouponsArray containsObject:coupon]) {
        [favoriteCouponsArray removeObject:coupon];
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.collectionView reloadData];
    }
}


@end
