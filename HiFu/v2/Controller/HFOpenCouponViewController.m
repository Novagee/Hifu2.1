//
//  HFOpenCouponViewController.m
//  HiFu
//
//  Created by Peng Wan on 11/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFOpenCouponViewController.h"
#import "HFOpenCouponTableViewCell.h"
#import "HFOpenCouponDiscountViewController.h"
#import "HFOpenCouponDetailViewController.h"
#import "HFCouponApi.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "HFOpenCoupon.h"
#import <Appsee/Appsee.h>

@interface HFOpenCouponViewController (){
    int currentPageNumber;
    id getCouponRequest;
    NSMutableArray *couponArray;
    BOOL hasMoreToLoad;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *loadingMoreView;
@property (nonatomic, weak) IBOutlet UIImageView *loadingMoreImageView;


@end

@implementation HFOpenCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerCustomCellsFromNibs];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    couponArray = [NSMutableArray new];
    [self setupLoadingMoreView];
    [self getCoupones];
    
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 50 - 64);
}

- (void) viewWillAppear:(BOOL)animated{
    [self setupPullToRefresh];
    [Appsee addEvent:@"Open Coupon List Tab Clicked"];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = YES;

}

-(void)setupPullToRefresh {
    NSLog(@"Setup pull refresh");
    
    [self.tableView addPullToRefreshActionHandler:^{
        currentPageNumber = 0;
        [getCouponRequest cancel];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(getCoupones)
                                       userInfo:nil
                                        repeats:NO];
    }
                            ProgressImagesGifName:@"loadingA.gif"
                             LoadingImagesGifName:@"loadingA.gif"
                          ProgressScrollThreshold:40
                            LoadingImageFrameRate:60];
}

- (void)setupLoadingMoreView {
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


-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HFOpenCouponTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HFOpenCouponTableViewCell"];
}

- (void)getCoupones {
    
//    currentPageNumber ++;
    getCouponRequest = [HFCouponApi getCouponsByPageNumber:1//currentPageNumber
                                               couponPerPage:200
                                                     success:^(id stores) {
                                                         
//                                                         if (currentPageNumber == 1) {
                                                             [couponArray removeAllObjects];
//                                                         }
                                                         for (NSDictionary *dict in stores) {
                                                             HFOpenCoupon *openCoupon = [[HFOpenCoupon alloc]initWithDictionary:dict];
                                                             [couponArray addObject:openCoupon];
                                                         }
                                                         hasMoreToLoad = ([couponArray count] == 10);
                                                         [self hideLoadMore];
                                                         [self.tableView stopRefreshAnimation];
                                                         [self.tableView reloadData];
                                                     } failure:^(NSError *error) {
                                                         NSLog(@"%@", error);
                                                         if (error.code == 9999) {
                                                             //this is when internet is not reachable, we check if there is any downloaded coupon
                                                         }
                                                     }];
    
}

- (void)hideLoadMore {
    self.loadingMoreView.hidden = YES;
    [self.loadingMoreImageView stopAnimating];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return [couponArray count];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 181;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HFOpenCouponTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HFOpenCouponTableViewCell" forIndexPath:indexPath];
    HFOpenCoupon *coupon = couponArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setUpCoupon:coupon];
    [cell.couponDetailButton addTarget:self action:@selector(clickForDetails:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)clickForDetails:(id)sender
{
    
    UIButton *detailButton = (UIButton *)sender;
    UIView *view = detailButton;
    while (! [view isKindOfClass:[HFOpenCouponTableViewCell class]]) {
        view = view.superview;
    }
    HFOpenCouponTableViewCell *cell = (HFOpenCouponTableViewCell *)view;
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFOpenCouponDiscountViewController *openCouponDiscountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"openCouponDiscount"];

    HFOpenCoupon *openCoupon = couponArray[indexPath.row];
    openCouponDiscountViewController.openCoupon = openCoupon;
    
    [self.navigationController pushViewController:openCouponDiscountViewController animated:YES];
    
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
