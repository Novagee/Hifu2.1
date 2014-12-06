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
    
    self.navigationItem.title=(self.openCoupon.brandCN&&self.openCoupon.brandCN.length>1)?self.openCoupon.brandCN:self.openCoupon.brand;
    
    _counponImageURLString = self.openCoupon.brandPicUrl;
    _couponTitle.text = [NSString stringWithFormat:@"%@ %@",self.openCoupon.brand, self.openCoupon.brandCN];
    _couponDiscount.text = self.openCoupon.titleCN;
    _couponExpiration.text = [NSString stringWithFormat:@"%@",self.openCoupon.expireDateDisplay];
    _storeAddress.text = self.openCoupon.itemDescription;
    _descriptionCN.text = self.openCoupon.descriptionCN;
    if (!self.openCoupon.descriptionCN||self.openCoupon.descriptionCN.length<1) {
        _storeInfoViewSection.hidden = YES;
    }
    if (!self.openCoupon.itemDescription||self.openCoupon.itemDescription.length<1) {
        _storeAddressViewSection.hidden = YES;
    }

    [SVProgressHUD show];
    [self.couponImage setImageWithURL:[NSURL URLWithString:_counponImageURLString]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                if (image && !error) {
                                    self.couponImage.image = image;
                                    [SVProgressHUD dismiss];
                                }
                            }];
    
    [self configureStoreInfoViewSection];
    [self configureStoreAddressViewSection];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Left item
    //
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureStoreInfoViewSection {
    
    [_descriptionCN sizeToFit];
    
    _storeInfoViewSection.size = CGSizeMake(self.storeInfoViewSection.bounds.size.width, self.storeInfoViewSection.bounds.size.height + self.descriptionCN.bounds.size.height);
    
}

- (void)configureStoreAddressViewSection {
    
    [_storeAddress sizeToFit];
    
    _storeAddressViewSection.size = CGSizeMake(self.storeAddressViewSection.bounds.size.width, self.storeAddressViewSection.bounds.size.height + self.storeAddress.bounds.size.height);

    _storeAddressViewSection.center = CGPointMake(self.storeAddressViewSection.center.x, self.couponImage.height + self.storeInfoViewSection.height + self.storeAddressViewSection.height/2 + 20 + 64);

    // Configure main bottom's content size
    //
    _mainBottom.contentSize = CGSizeMake(self.mainBottom.bounds.size.width, self.couponImage.size.height + self.storeInfoViewSection.bounds.size.height + self.storeAddressViewSection.bounds.size.height + 50);

}

- (void)leftBarButtonItemTapped {
    [self.navigationController popViewControllerAnimated:YES];
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
