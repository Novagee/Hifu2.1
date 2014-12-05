//
//  HFOpenCouponDiscountViewController.m
//  HiFu
//
//  Created by Paul on 12/5/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFOpenCouponDiscountViewController.h"
#import "HFOpenCouponDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface HFOpenCouponDiscountViewController ()

@property (weak, nonatomic) IBOutlet UIView *storeAddressViewSection;
@property (weak, nonatomic) IBOutlet UIView *storeInfoViewSection;

@end

@implementation HFOpenCouponDiscountViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self configureStoreAddressViewSection];
    
    [SVProgressHUD show];
    [self.couponImage setImageWithURL:[NSURL URLWithString:_counponImageURLString]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                if (image && !error) {
                                    self.couponImage.image = image;
                                    [SVProgressHUD dismiss];
                                }
                            }];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureStoreAddressViewSection {
    
    _counponImageURLString = self.openCoupon.brandPicUrl;
    _couponTitle.text = [NSString stringWithFormat:@"%@ %@",self.openCoupon.brand, self.openCoupon.brandCN];
    _couponDiscount.text = self.openCoupon.titleCN;
    _couponExpiration.text = [NSString stringWithFormat:@"%@",self.openCoupon.expireDateDisplay];
    _storeAddress.text = self.openCoupon.itemDescription;
    
    
    [_storeAddress sizeToFit];
    
    _storeAddressViewSection.size = CGSizeMake(self.storeAddressViewSection.bounds.size.width, self.storeAddressViewSection.bounds.size.height + self.storeAddress.bounds.size.height);
    
    // Configure main bottom's content size
    //
    _mainBottom.contentSize = CGSizeMake(self.mainBottom.bounds.size.width, self.couponImage.size.height + self.storeInfoViewSection.bounds.size.height + self.storeAddressViewSection.bounds.size.height + 50);
    
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkDicount:(id)sender {
    
    HFOpenCouponDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"openCouponDetail"];
    detailViewController.coupon = self.openCoupon;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
