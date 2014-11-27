//
//  HFCouponDetailViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/31/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import <POP.h>


#import "HFCouponDetailViewController.h"
#import "HFCouponAddCommentViewController.h"
#import "HFCouponRedeemViewController.h"
#import "HFCouponMapViewController.h"

//Cells
#import "HFCouponDetailCommentCell.h"
#import "HFCouponDetailAddCommentCell.h"
#import "HFCouponDetailMoreCommentCell.h"

//Objects
#import "CouponObject.h"
#import "CommentObject.h"

//Apis
#import "CommentServerApi.h"
#import "CouponServerApi.h"
#import "UserServerApi.h"

//Helpers
#import "HFGeneralHelpers.h"
#import "HFShareHelpers.h"


@interface HFCouponDetailViewController ()
{
    BOOL couponDescriptionExpanded, hasMoreCommentsToShow,
         isShowingAllComments, isDownloaded;
    NSMutableArray *commentsArray;
    NSInteger numberOfCommentsShouldShow;
    HFShareView *shareView;
}

@end

@implementation HFCouponDetailViewController

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
    couponDescriptionExpanded = NO;
    [HFUIHelpers removeBottomBorderFromNavBar:self.navigationController.navigationBar];
    [self setupViewComponents];
    [self setupTableViewCells];
    [self setupNotifications];
    [self getComments];
    [self getShareImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)setupTableViewCells
{
    [self.tableView registerNib:[HFCouponDetailCommentCell cellNib] forCellReuseIdentifier:[HFCouponDetailCommentCell reuseIdentifier]];
    [self.tableView registerNib:[HFCouponDetailInfoCell cellNib] forCellReuseIdentifier:[HFCouponDetailInfoCell reuseIdentifier]];
    [self.tableView registerNib:[HFCouponDetailAddCommentCell cellNib] forCellReuseIdentifier:[HFCouponDetailAddCommentCell reuseIdentifier]];
    [self.tableView registerNib:[HFCouponDetailMoreCommentCell cellNib] forCellReuseIdentifier:[HFCouponDetailMoreCommentCell reuseIdentifier]];
}

- (void)setupViewComponents
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];
    
    self.navigationItem.title = @"添加清单";
    [HFUIHelpers roundCornerToHFDefaultRadius:self.useCouponButton];
    commentsArray = [NSMutableArray new];
    
    self.couponLogoImageView.layer.borderColor = [[UIColor colorWithWhite:0.824 alpha:1.000] CGColor];
    self.couponLogoImageView.layer.borderWidth = 0.5;
    
    if (self.coupon.promotionImage) {
        self.couponCoverImageView.image = self.coupon.promotionImage;
    }
    else
    {
        [self.couponCoverImageView setImageWithURL:[NSURL URLWithString:self.coupon.promotionPic]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                             if (image && !error) {
                                                 self.coupon.promotionImage = image;
                                                 self.couponCoverImageView.image = image;
                                                 self.couponCoverImageView.clipsToBounds = YES;
                                             }
                                         }];
    }
    if (self.couponLogoImage) {
        self.couponLogoImageView.image = self.couponLogoImage;
    }
    
    [self.tableView setContentInset:UIEdgeInsetsMake(240, 0, 120, 0)];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:HFDownloadedCoupons]) {
        NSArray *downloadedCouponIdArray = [[NSUserDefaults standardUserDefaults] objectForKey:HFDownloadedCoupons];
        if ([downloadedCouponIdArray containsObject:self.coupon.itemId]) {
            isDownloaded = YES;
        }
    }
    
    self.downloadingView.hidden = YES;
    self.downloadingView.backgroundColor = HFThemePink;
    self.downloadingView.frame = CGRectMake(0, -self.downloadingView.height, self.downloadingView.width, self.downloadingView.height);
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentButtonTapped) name:HFCouponDetailAddComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreCommentButtonTapped:) name:HFCouponDetailMoreComment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentSucessfully:) name:HFAddCommentSuccessfully object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToAddComment"]) {
        HFCouponAddCommentViewController *vc = segue.destinationViewController;
        vc.coupon = self.coupon;
    }
    else if ([segue.identifier isEqualToString:@"pushToRedeem"])
    {
        HFCouponRedeemViewController *vc = segue.destinationViewController;
        vc.coupon = self.coupon;
    }
    else if ([segue.identifier isEqualToString:@"pushToCouponMap"])
    {
        HFCouponMapViewController *vc = segue.destinationViewController;
        vc.coupon = self.coupon;
        vc.logoImage = self.couponLogoImage;
    }
}

#pragma mark - APIs
- (void)getComments
{
    [CommentServerApi getCommentsForCouponId:self.coupon.itemId
                                  pageNumber:0
                             commentsPerPage:5
                                     success:^(id comments) {
                                         for (NSDictionary *dict in comments) {
                                             CommentObject *c = [[CommentObject alloc] initWithDictionary:dict];
                                             [commentsArray addObject:c];
                                         }
                                         if ([commentsArray count] > 3) {
                                             numberOfCommentsShouldShow = 3;
                                             hasMoreCommentsToShow = YES;
                                         }
                                         else
                                         {
                                             numberOfCommentsShouldShow = [commentsArray count];
                                             hasMoreCommentsToShow = NO;
                                         }
                                         [self.tableView reloadData];
                                     } failure:^(NSError *error) {
                                     }];
}

- (void)addCouponToUserFavorite
{
    [CouponServerApi addFavoriteCoupon:self.coupon.itemId
                               forUser:[UserServerApi sharedInstance].currentUserId success:^{
                                   NSLog(@"Remove %@ from User Favorite Success", self.coupon.itemId);
                               } failure:^(NSError *error) {
                                   NSLog(@"%@", error);
                               }];
}

- (void)removeCouponFromUserFavorite
{
    [CouponServerApi removeFavoriteCoupon:self.coupon.itemId
                                  forUser:[UserServerApi sharedInstance].currentUserId success:^{
                                      NSLog(@"Remove %@ from User Favorite Success", self.coupon.itemId);
                                  } failure:^(NSError *error) {
                                      NSLog(@"%@", error);
                                  }];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfCommentsShouldShow + (hasMoreCommentsToShow ? 3 : 2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [HFCouponDetailInfoCell cellHeightForCoupon:self.coupon isExpanded:couponDescriptionExpanded];
    }
    else if ((!hasMoreCommentsToShow && indexPath.row == numberOfCommentsShouldShow + 1) || (hasMoreCommentsToShow && indexPath.row == numberOfCommentsShouldShow + 2))
    {
        return [HFCouponDetailAddCommentCell heightForCell];
    }
    else if ((hasMoreCommentsToShow && indexPath.row == numberOfCommentsShouldShow + 1))
    {
        return [HFCouponDetailMoreCommentCell heightForCell];
    }
    else
    {
        return [HFCouponDetailCommentCell cellHeightForComment:[commentsArray objectAtIndex:indexPath.row - 1]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HFCouponDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFCouponDetailInfoCell reuseIdentifier] forIndexPath:indexPath];
        cell.delegate = self;
        //        cell.isFavorite = self.isFavorite;
        cell.isFavorite = isDownloaded;
        int couponDescriptionHeight = [HFCouponDetailInfoCell cellHeightForCoupon:self.coupon isExpanded:YES];
        
        //如果Description的长度长于70，那说明可以展开。我们应该显示更多BUTTON
        if (couponDescriptionHeight > 150) {
            cell.canExpand = YES;
            cell.moreButton.hidden = NO;
            cell.moreImageView.hidden = NO;
        }
        else
        {
            cell.canExpand = NO;
            cell.moreButton.hidden = YES;
            cell.moreImageView.hidden = YES;
        }
        
        [cell.moreButton setTitle:couponDescriptionExpanded ? @"显示更少" : @"显示更多" forState:UIControlStateNormal];
        cell.moreImageView.image = couponDescriptionExpanded ? [UIImage imageNamed:@"more_arrow_up"] :[UIImage imageNamed:@"more_arrow_down"];
        
        if (self.coupon.descriptionCN) {
            cell.couponDescriptionTextView.attributedText = [HFGeneralHelpers generateAttributedString:self.coupon.descriptionCN withFont:HeitiSC_Medium(13) andColor:[UIColor colorWithRed:0.643 green:0.643 blue:0.643 alpha:1.000] andLineSpace:4.0];
        }
        else
        {
            cell.couponDescriptionTextView.attributedText = [HFGeneralHelpers generateAttributedString:@"无条件" withFont:HeitiSC_Medium(13) andColor:[UIColor colorWithRed:0.643 green:0.643 blue:0.643 alpha:1.000] andLineSpace:4.0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if ((!hasMoreCommentsToShow && indexPath.row == numberOfCommentsShouldShow + 1) || (hasMoreCommentsToShow && indexPath.row == numberOfCommentsShouldShow + 2))
    {
        HFCouponDetailAddCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFCouponDetailAddCommentCell reuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if ((hasMoreCommentsToShow && indexPath.row == numberOfCommentsShouldShow + 1))
    {
        HFCouponDetailMoreCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFCouponDetailMoreCommentCell reuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        HFCouponDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFCouponDetailCommentCell reuseIdentifier] forIndexPath:indexPath];
        cell.comment = [commentsArray objectAtIndex:indexPath.row - 1];
        cell.commentContentLabel.attributedText = [HFGeneralHelpers generateAttributedString:cell.comment.content withFont:HeitiSC_Medium(13) andColor:[UIColor colorWithRed:0.643 green:0.643 blue:0.643 alpha:1.000] andLineSpace:4.0];;
        //comment cell的default高度是78
        //如果comment cell的高度超过78，我们就要把comment label 和bubble的底部space去掉高出来的部分，最多去掉20px
        if (cell.height - 78 >= 0 && cell.height - 78 <= 20) {
            cell.commentContentBottomSpaceConstraint.constant = 29 - (cell.height - 78);
            cell.commentBubbleBottomSpaceConstraint.constant = 29 - (cell.height - 78);
        }
        else if (cell.height < 78) {
            cell.commentContentBottomSpaceConstraint.constant = 29;
            cell.commentBubbleBottomSpaceConstraint.constant = 29;
        }
        else
        {
            cell.commentContentBottomSpaceConstraint.constant = 9;
            cell.commentBubbleBottomSpaceConstraint.constant = 6;
        }
        
        if (cell.comment.userAlias) {
            cell.userNameLabel.text = cell.comment.userAlias;
            cell.userNameLabel.hidden = NO;
        }
        else
            cell.userNameLabel.hidden = YES;
        
        cell.userAvatarImageView.image = [UIImage imageNamed:[cell.comment.avatarNum stringValue]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


#pragma mark - UITableView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //起始是-240，最低拉到-280，因为图片会根据下拉的距离变大，超过40PX会有点过大
    if (scrollView.contentOffset.y < -280) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -280);
    }
    
    float delta = scrollView.contentOffset.y - (-240.0);
    
    if(scrollView.contentOffset.y < -240)
    {
        float ourScale = 1 + ((scrollView.contentOffset.y /240)*2);
        self.couponCoverImageView.transform = CGAffineTransformMakeScale(-ourScale, -ourScale);
    }
    else
    {
        self.couponCoverImageView.frame = CGRectMake(self.couponCoverImageView.origin.x, 0 - delta*0.3, self.couponCoverImageView.width, self.couponCoverImageView.height);
    }
    
    self.couponLogoImageView.frame = CGRectMake(self.couponLogoImageView.origin.x, 220 - delta, self.couponLogoImageView.width, self.couponLogoImageView.height);
    
}

#pragma mark - Action Methods
- (IBAction)redeemCoupon:(id)sender
{
    [self performSegueWithIdentifier:@"pushToRedeem" sender:self];
}

#pragma mark - HFCouponDetailInfoCell Delegate

- (void)couponDetailInfoCellShareButtonTapped
{
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

- (void)couponDetailInfoCellMoreButtonTapped
{
    couponDescriptionExpanded = !couponDescriptionExpanded;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)couponDetailInfoCellHeartButtonTapped
{
    if (isDownloaded) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            [self removeCouponFromUserFavorite];
            [self deleteArchivedCurrentCoupon];
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            [self addCouponToUserFavorite];
        });
        
        self.downloadingView.hidden = NO;
        if (self.coupon.redeemImage || !self.coupon.redeemCodePic) {
            
            self.downloadSuccessLabel.hidden = NO;
            self.downloadingProgressView.hidden = YES;
            self.downloadingLabel.hidden = YES;

            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.downloadingView.frame = CGRectMake(0, 0, self.downloadingView.width, self.downloadingView.height);
                             } completion:^(BOOL finished) {
                                 [self showDownloadingSuccessAndHide];
                             }];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
                [self archiveCurrentCoupon];
            });
        }
        else
        {
            self.downloadSuccessLabel.hidden = YES;
            self.downloadingProgressView.hidden = NO;
            self.downloadingLabel.hidden = NO;
            
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                self.downloadingView.frame = CGRectMake(0, 0, self.downloadingView.width, self.downloadingView.height);
            } completion:^(BOOL finished) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.coupon.redeemCodePic]
                                                                              options:SDWebImageDownloaderUseNSURLCache
                                                                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                                 // progression tracking code
                                                                                 CGFloat rSize = receivedSize;
                                                                                 CGFloat eSize = expectedSize;
                                                                                 self.downloadingProgressView.progress = rSize/eSize;
                                                                             }
                                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                                if (finished && image) {
                                                                                    [self showDownloadingSuccessAndHide];
                                                                                    self.coupon.redeemImage = image;
                                                                                    [self archiveCurrentCoupon];
                                                                                }
                                                                            }];
                });
            }];
        }
    }
    isDownloaded = !isDownloaded;
}

- (void)showDownloadingSuccessAndHide
{
    self.downloadSuccessLabel.hidden = NO;
    self.downloadingProgressView.hidden = YES;
    self.downloadingLabel.hidden = YES;
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.downloadingView.frame = CGRectMake(0, -self.downloadingView.height, self.downloadingView.width, self.downloadingView.height);
    } completion:^(BOOL finished) {
        self.downloadingView.hidden = YES;
    }];
}

- (void)deleteArchivedCurrentCoupon
{
    [HFGeneralHelpers deleteDataFileAtPath:[HFGeneralHelpers dataFilePath:HFCouponPathWithId(self.coupon.itemId)]];
    NSMutableArray *downloadedCouponArray = [[[NSUserDefaults standardUserDefaults] objectForKey:HFDownloadedCoupons] mutableCopy];
    if ([downloadedCouponArray containsObject:self.coupon.itemId]) {
        [downloadedCouponArray removeObject:self.coupon.itemId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:downloadedCouponArray forKey:HFDownloadedCoupons];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:HFRemoveCouponFromFavorite object:self.coupon];
}

- (void)archiveCurrentCoupon
{
    [HFGeneralHelpers saveData:self.coupon toFileAtPath:[HFGeneralHelpers dataFilePath:HFCouponPathWithId(self.coupon.itemId)]];
    NSMutableArray *downloadedCouponArray = [[[NSUserDefaults standardUserDefaults] objectForKey:HFDownloadedCoupons] mutableCopy];
    if (!downloadedCouponArray)
        downloadedCouponArray = [NSMutableArray new];
    [downloadedCouponArray addObject:self.coupon.itemId];
    [[NSUserDefaults standardUserDefaults] setObject:downloadedCouponArray forKey:HFDownloadedCoupons];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:HFAddCouponToFavorite object:self.coupon];
}

#pragma mark - HFShareView Delegate
- (void)sharedByMessage
{
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers shareByMessageOnViewController:self
                                       andDelegate:self
                                     sharedSubject:self.coupon.shareTitle
                                        sharedBody:[NSString stringWithFormat:@"%@ 活动详情:\n %@", self.coupon.shareContent, self.coupon.shareTitle]
                                       sharedImage:self.coupon.shareImage
                                 presentCompletion:^{
                                     [self dismissShareView];
                                     
                                 }];
}

- (void)sharedByEmail
{
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers shareByEmailOnViewController:self
                                     andDelegate:self
                                   sharedSubject:self.coupon.shareTitle
                                      sharedBody:[NSString stringWithFormat:@"%@ 活动详情:\n %@", self.coupon.shareContent, self.coupon.shareTitle]
                                     sharedImage:self.coupon.shareImage
                               presentCompletion:^{
                                   [self dismissShareView];
                                   
                               }];
}

- (void)sharedBySinaWeibo
{
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers sharedBySinaWeiboOnViewController:self
                                        andSharedText:[NSString stringWithFormat:@"%@ %@", self.coupon.shareContent, self.coupon.shareLink]
                                          sharedImage:self.coupon.shareImage];
}

- (void)sharedByAirDrop
{
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }
    
    [HFShareHelpers sharedByAirDropOnViewController:self andSharedText:[NSString stringWithFormat:@"%@ %@", self.coupon.shareContent, self.coupon.shareLink] andSharedImage:self.coupon.shareImage];
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
    if (!self.coupon.shareImage) {
        //just in case if shareImage is not loaded yet, there should be a better solution, such as a run loop check, for the time sake, i put this for now
        self.coupon.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.sharePictureURL]]];
    }

    [HFShareHelpers shareByWechat:isMoment
                   andSharedTitle:self.coupon.shareTitle
                       sharedBody:[NSString stringWithFormat:@"%@ 活动详情:\n %@", self.coupon.shareContent, self.coupon.shareTitle]
                       thumbImage:[UIImage imageNamed:@"HiFu_App_Icon"]
                      sharedImage:self.coupon.shareImage
                          success:^{
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                                              message:isMoment ? @"朋友圈发送成功!" : @"微信发送成功!"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"继续分享"
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

- (void)getShareImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.coupon.sharePictureURL]
                                                              options:SDWebImageDownloaderUseNSURLCache
                                                             progress:nil
                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                if (finished && image) {
                                                                    self.coupon.shareImage = image;
                                                                }
                                                            }];
    });
}

#pragma mark - Mail Compose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送失败" message:@"邮件发送失败，请再次尝试" delegate:self cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送成功" message:@"邮件发送成功，感谢分享！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信发送失败" message:@"短信发送失败，请再次尝试" delegate:self cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (result == MessageComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信发送成功" message:@"短信发送成功，感谢分享！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSNotification Selector Methods
- (void)addCommentButtonTapped
{
    [self performSegueWithIdentifier:@"pushToAddComment" sender:self];
}

- (void)moreCommentButtonTapped:(NSNotification *)notification
{
    UIButton *moreButton = notification.object;
    isShowingAllComments = !isShowingAllComments;
    if (isShowingAllComments) {
        numberOfCommentsShouldShow = [commentsArray count];
        [moreButton setTitle:@"隐藏全部评论" forState:UIControlStateNormal];
    }
    else
    {
        numberOfCommentsShouldShow = 3;
        [moreButton setTitle:@"显示全部评论" forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}

- (void)addCommentSucessfully:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    CommentObject *comment = notification.object;
    if (commentsArray) {
        [commentsArray insertObject:comment atIndex:0];
    }
    
    if (isShowingAllComments) {
        numberOfCommentsShouldShow = [commentsArray count];
    }
    else
    {
        numberOfCommentsShouldShow = [commentsArray count] >= 3 ? 3 : [commentsArray count];
    }
    
    [self.tableView reloadData];
}

@end
