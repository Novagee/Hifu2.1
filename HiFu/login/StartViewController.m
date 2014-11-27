//
//  StartViewController.m
//  HiFu
//
//  Created by Rich on 5/16/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "StartViewController.h"
#import "EasyData.h"
#import "UIImageView+WebCache.h"
#import "ServerModel.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "UserServerApi.h"


static const int secondsForLoggedTime = 200;

@interface StartViewController ()

@end

@implementation StartViewController

#pragma mark - localization
-(void)ibViewLocalization{
    [self.enterButton setTitle:NSLocalizedString(@"start_enter_but", @"立刻加入")
                      forState:UIControlStateNormal];
}

#pragma mark -

-(void)checkLastLogged{
    if ([UserServerApi sharedInstance].currentUser) {
        [self skipToEndWithAnimation:NO];
    }
    NSDate *lastLog = [EasyData getDataWithKey:@"lastLogged"];
    if (lastLog) {
        if (fabs([lastLog timeIntervalSinceNow]) < secondsForLoggedTime) {
            [EasyData setData:[NSDate date] forKey:@"lastLogged"];
            [self skipToEndWithAnimation:YES];
        }
    }
    else{
        return;
    }
}



#pragma mark - load/unload methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addIntroImages{
    int i =1;
    UIImage * img;
    while (i<5) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"splash_%i",i]];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        [imgView setFrame:self.introImages.frame];
        [imgView setFrameX:_introImages.frame.size.width  * (i-1)];
        [imgView setFrameY:-20];
        
        if (HF_IS_IPHONE4) {
            [imgView shiftFrameHeight:-60];
            [imgView shiftFrameWidth :-60];
            [imgView shiftFrameX:30];
            [imgView shiftFrameY:27];
        }
        
        [self.introImages addSubview:imgView];
        i++;
    }

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    // a page is the width of the scroll view
    _introImages.pagingEnabled = YES;
    _introImages.contentSize = CGSizeMake(_introImages.frame.size.width * 5, self.view.frame.size.height);
    _introImages.showsHorizontalScrollIndicator = NO;
    _introImages.showsVerticalScrollIndicator = NO;
    _introImages.scrollsToTop = NO;
    _introImages.delegate = self;
	
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
//    [self.pageControl setPageIndicatorTintColor:regGrayColor];
//    [self.pageControl setCurrentPageIndicatorTintColor:HFThemePink];
    
    [self.enterButton.titleLabel setTextColor:[UIColor whiteColor]];

    [self addIntroImages];
//    [self preloadImagesToCache];
    
    if (HF_IS_IPHONE4) {
        [_introImages freeAutoLayout];
        [_introImages centerInsideFrame:self.view.frame];
        [_introImages setFrameY:-63];
        [_introImages.superview sendSubviewToBack:_introImages];
        
        [_pageControl freeAutoLayout];
        [_pageControl setFrameY:self.enterButton.frame.origin.y-35];
    }
//    [self.hiImage.superview bringSubviewToFront:self.hiImage];
    
    [_introImages setContentSize:CGSizeMake(_introImages.contentSize.width,
                                            5)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated{
    [self currentView:@"注册"];
    [self.navigationController setNavigationBarHidden:YES];
    
//    [HFUIHelpers roundCornerToHFDefaultRadius:self.enterButton];
//    [self.enterButton setBackgroundColor:HFThemePink];
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"but_back"]];
    [self checkLastLogged];
    _hasPushedSegue =NO;
    
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}


// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (self.pageControlUsed) {
        return;
    }
    int page = sender.contentOffset.x / sender.frame.size.width;
    if (page > 3 ) {
        if (self.hasPushedSegue) {
            return;
        }
        [self pushToIdentifier:@"inputNumber"];
        _hasPushedSegue = YES;
    }
    self.pageControl.currentPage = page;
}
-(void)viewDidDisappear:(BOOL)animated{
    //return to Hi - 3rd image show, incase clicked back button.
    if (self.pageControl.currentPage >=3) {
        [self.introImages setContentOffset: CGPointMake(_introImages.frame.size.width * (3), 0) animated:NO];
    };

}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}


- (IBAction)enter:(id)sender {
    [self pushToIdentifier:@"inputNumber"];

}


- (IBAction)pageClicked:(UIPageControl*)sender {
    int i = sender.currentPage;
    NSLog(@"page %i", i);
    [self.introImages setContentOffset: CGPointMake(_introImages.frame.size.width * (i), 0) animated:YES];
    self.pageControlUsed = YES;
}

/*
-(void)preloadImagesToCache{
    BOOL hasNetwork = [[[ServerModel sharedManager] lowLayer]  checkNetorkConnectionWithPopup:NO];
    
    if (hasNetwork && ![[ServerModel sharedManager] userId]) {
        [[ServerModel sharedManager]couponsForLocationLatitude:self.locationManager.location.coordinate.latitude
                                                    Longitutde:self.locationManager.location.coordinate.longitude
                                                    Completion:
         ^(NSDictionary *rawData, bool success) {
             
             
             NSArray *coupons = [NSArray arrayWithArray: rawData [@"returnedCoupons"]];
             coupons = [NetResults resultsDeNull:coupons];
             [EasyData setData:coupons forKey:@"lastDataCouponList"];
             
             
             for(NSDictionary *entry in coupons) {

                 NSString* key1 = entry[@"merchant"][@"coverPictureUrl"];
                 NSURL* url1    = [NSURL URLWithString:key1];
                 [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url1
                                                                       options:SDWebImageDownloaderUseNSURLCache
                                                                      progress:nil
                                                                     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {

                                                                         [[SDImageCache sharedImageCache] storeImage:image forKey:key1 toDisk:YES];
//                                                                         NSLog(@"download beforehand");
                 }];

                 NSString *key2 = entry[@"merchant"][@"logoPictureUrl"];
                 NSURL *url2    = [NSURL URLWithString:key2];
                 [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url2
                                                                       options:SDWebImageDownloaderUseNSURLCache
                                                                      progress:nil
                                                                     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                         
                                                                         [[SDImageCache sharedImageCache] storeImage:image forKey:key2 toDisk:YES];
//                                                                         NSLog(@"download beforehand");
                 }];
                 NSString *key3 = entry[@"redeemCodePic"];
                 NSURL *url3    = [NSURL URLWithString:key3];
                 [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url3
                                                                       options:SDWebImageDownloaderUseNSURLCache
                                                                      progress:nil
                                                                     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                         
                                                                         [[SDImageCache sharedImageCache] storeImage:image forKey:key3 toDisk:YES];
//                                                                         NSLog(@"download beforehand");
                 }];
             }
         }];
    }
    
   // NSString*key = [url absoluteString];
    
    //storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
}
*/

@end
