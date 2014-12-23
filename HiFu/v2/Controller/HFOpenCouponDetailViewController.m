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
#import "HFShareView.h"
#import "CouponObject.h"
#import "HFShareHelpers.h"
#import "BaseObject.h"
#import "HFUIHelpers.h"

@interface HFOpenCouponDetailViewController ()<UIScrollViewDelegate, HFShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *discountImage;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomView;

@property (strong, nonatomic) HFShareView *shareView;

@end

@implementation HFOpenCouponDetailViewController

@synthesize shareView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    
    self.navigationItem.title = (self.coupon.brandCN&&self.coupon.brandCN.length>1)?self.coupon.brandCN:self.coupon.brand;
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemTapped)];
    leftBarButtonItem.tintColor = [UIColor colorWithRed:255/255.0f green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    // Configure Right Bar Button Item
    //
    UIImage *buttonImage = [UIImage imageNamed:@"share"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];;
    
    _bottomView.delegate = self;
    
    __weak __typeof(self) weakSelf = self;
    [self.discountImage setImageWithURL:[NSURL URLWithString:self.coupon.couponPicUrl]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                if (image && !error) {
                                    weakSelf.discountImage.image = image;
                                    
                                    [weakSelf.discountImage setFrame:CGRectMake(weakSelf.discountImage.layer.frame.origin.x, weakSelf.discountImage.layer.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * (image.size.height/image.size.width))];
                                }
                                
                                _bottomView.frame = CGRectMake(0, 35, self.view.width, self.view.height - 35);
                                
                                NSLog(@"Image Size : %f vs %f", self.discountImage.size.height, self.view.size.height - 35 - 64 - 50);
                                _bottomView.contentSize = (self.discountImage.size.height >= (self.view.height - 35 - 64 - 50))? self.discountImage.size : CGSizeZero;
                                
                                [SVProgressHUD dismiss];
                                
                            }];
    
}

- (void)viewWillAppear:(BOOL)animate {
    
    [super viewWillAppear:animate];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)leftBarButtonItemTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonTapped {
    
    if (!shareView) {
        shareView = [[NSBundle mainBundle] loadNibNamed:@"HFShareView" owner:self options:nil][0];
        shareView.delegate = self;
    }
    
    shareView.alpha = 0.0;
    //    shareView.shareWrapperView.frame = CGRectMake(0, HF_DEVICE_HEIGHT, 320, shareView.shareWrapperView.height);
    
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        shareView.alpha = 1.0;
        [shareView runShowAnimation];
    } completion:nil];
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

#pragma mark - Share Stack

- (void)sharedBySinaWeibo
{
    if (!self.discountImage.image) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.discountImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.couponPicUrl]]];
    }
    
    [HFShareHelpers sharedBySinaWeiboOnViewController:self
                                        andSharedText:[NSString stringWithFormat:@"%@", self.coupon.descriptionCN]
                                          sharedImage:self.discountImage.image];
}
- (void)sharedByWechatMessage
{
    [self actualShareOnWechat:NO];
}

- (void)sharedByWechatMoment
{
    [self actualShareOnWechat:YES];
}

- (void)actualShareOnWechat:(BOOL) isMoment
{
    if (!self.discountImage.image) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.discountImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.couponPicUrl]]];
    }
    
    [HFShareHelpers shareByWechat:isMoment
                   andSharedTitle:self.coupon.titleCN
                       sharedBody:[NSString stringWithFormat:@"活动详情: %@", self.coupon.descriptionCN]
                       thumbImage:[UIImage imageNamed:@"HiFu_App_Icon"]
                      sharedImage:self.discountImage.image
                          success:^{
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                                              message:isMoment ? @"朋友圈发送成功!" : @"微信发送成功!"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"返回"
                                                                    otherButtonTitles: nil];
                              [alert show];
                          } failure:^{
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                              message:isMoment ? @"朋友圈发送失败，请稍微尝试。" : @"微信发送失败，请稍后尝试。"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"好的"
                                                                    otherButtonTitles: nil];
                              [alert show];
                          }];
}

- (void)dismissShareView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        shareView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        shareView = nil;
    }];
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
