//
//  HFOpenCouponDetailViewController.m
//  HiFu
//
//  Created by Peng Wan on 11/15/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFOpenCouponDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HFUIHelpers.h"
#import "UIView+EasyFrames.h"
#import "SVProgressHUD.h"

@interface HFOpenCouponDetailViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *discountImage;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomView;

@end

@implementation HFOpenCouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    
    self.navigationItem.title = self.coupon.brandCN;
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    _bottomView.delegate = self;
    
    __weak __typeof(self) weakSelf = self;
    [self.discountImage setImageWithURL:[NSURL URLWithString:self.coupon.couponPicUrl]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                if (image && !error) {
                                    weakSelf.discountImage.image = image;
                                    
                                    [weakSelf.discountImage setFrame:CGRectMake(weakSelf.discountImage.layer.frame.origin.x, weakSelf.discountImage.layer.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * (image.size.height/image.size.width))];
                                }
                                
                                _bottomView.frame = CGRectMake(0, 35, self.view.width, self.view.height - 35 - 50);
                                
                                NSLog(@"Image Size : %f vs %f", self.discountImage.size.height, self.view.size.height - 35 - 64 - 50);
                                _bottomView.contentSize = (self.discountImage.size.height >= (self.view.height - 35 - 64 - 50))? self.discountImage.size : CGSizeZero;
                                
                                [SVProgressHUD dismiss];
                                
                            }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    
}

- (void)leftBarButtonItemTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.discountImage;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat width = scrollView.contentSize.width/2;
    width -= width/scrollView.zoomScale;
    
    CGFloat height = scrollView.contentSize.height/2;
    height =height-height/scrollView.zoomScale;
    
    scrollView.contentOffset = CGPointMake(width, height);
    
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
