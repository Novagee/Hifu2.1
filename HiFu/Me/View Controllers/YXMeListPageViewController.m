//
//  YXMeListPageViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/1/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeListPageViewController.h"
#import "YXMeInfoSettingViewController.h"
#import "HFFavoriteBrandsViewController.h"

#import "YXMeUserInfoCell.h"
#import "YXMeRegularCell.h"

#import "YXMeCellTypeEnum.h"
#import "UserObject.h"
#import "UserServerApi.h"

#import "HFBindingTableViewCell.h"
#import "HFGenderTableViewCell.h"
#import "HFAgeTableViewCell.h"


#import "HFTermsViewController.h"
#import "HFWeiboService.h"
#import "HFWeixinService.h"
#import "HFMEUserLoginCell.h"

#import "EasyData.h"
#import "UserObject.h"
#import "RegisterViewController.h"

#import "YXCalendarViewController.h"


@interface YXMeListPageViewController ()
{
    NSArray *mePageCellsArray;
    UserObject *currentUser;
}

// Just use for test
//
@property (assign, nonatomic) BOOL islogined;

@end

@implementation YXMeListPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;

}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    [HFUIHelpers removeBottomBorderFromNavBar:self.navigationController.navigationBar];
    mePageCellsArray = [NSArray arrayWithObjects:
                        @(MeInfoTitleCell),
                        @(MeInfoCell),
                        @(MeSpacingCell),
                        @(MeSpacingCell),
                        @(MeSpacingCell),
                        @(MeCalendarCell),
                        @(MeSpacingCell),
//                        @(MeBindingTitleCell),
//                        @(MeBindingWechatCell),
//                        @(MeBindingWeiboCell),
//                        @(MeBindingQQCell),
//                        @(MeBindingMobileCell),
//                        @(MeTermsCell),
//                        @(MeSpacingCell),
                        @(MeMoreTitleCell),
//                        @(MeMoreGenderCell),
//                        @(MeMoreAgeCell),
                        @(MeSpacingCell),
                        @(MeLikeUsCell),
//                        @(MEUserLogin),
                        nil];
    
    [self.tableView registerNib:[YXMeUserInfoCell cellNib] forCellReuseIdentifier:[YXMeUserInfoCell reuseIdentifier]];
    [self.tableView registerNib:[YXMeRegularCell  cellNib] forCellReuseIdentifier:[YXMeRegularCell  reuseIdentifier]];
    [self.tableView registerNib:[HFBindingTableViewCell cellNib] forCellReuseIdentifier:[HFBindingTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[HFGenderTableViewCell cellNib] forCellReuseIdentifier:[HFGenderTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[HFAgeTableViewCell cellNib] forCellReuseIdentifier:[HFAgeTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[HFLikeusTableViewCell cellNib] forCellReuseIdentifier:[HFLikeusTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[HFMEUserLoginCell cellNib] forCellReuseIdentifier:[HFMEUserLoginCell reuseIdentifier]];
    
//    if (HF_DEVICE_HEIGHT < 568) {
//        self.hifuServiceImageView.frame = CGRectMake(self.hifuServiceImageView.frame.origin.x,
//                                                     400,
//                                                     self.hifuServiceImageView.frame.size.width,
//                                                     self.hifuServiceImageView.frame.size.height);
//    }
    
    //changes tint color of back chevron arrow
//    [[self.navigationController.navigationBar.subviews lastObject] setTintColor:[UIColor whiteColor]];
    self.islogined = ([UserServerApi sharedInstance].currentUserId != nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    currentUser = [UserServerApi sharedInstance].currentUser;
    NSLog(@"%@", currentUser);
    [self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToUserInfoSetting"]) {
        YXMeInfoSettingViewController *vc = (YXMeInfoSettingViewController *)[segue destinationViewController];
        vc.currentUser = currentUser;
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mePageCellsArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMeCellType cellType = [[mePageCellsArray objectAtIndex:indexPath.row] intValue];
    
    switch (cellType) {
        case MeInfoCell:
            
            // The same to the BOOL value bolow, just for test
            //
            
            if (self.islogined) {
                return [YXMeUserInfoCell heightForCell];
            }
            else {
                return [HFMEUserLoginCell heightForCell];
            }
    
            break;
        case MeSpacingCell:
            return 10;
        case MeLikeUsCell:
            return 60;
        default:
            return [YXMeRegularCell heightForCell];
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMeCellType cellType = [[mePageCellsArray objectAtIndex:indexPath.row] intValue];
    
    switch (cellType) {
        case MeInfoTitleCell:
        {
            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
            cell.cellIconImageView.hidden = YES;
            cell.cellTitleLabel   .text = @"账号信息";
            cell.comingSoonLabel  .hidden = YES;
            cell.arrowImageView   .hidden = YES;
            return cell;
        }
            break;
        case MeInfoCell:
        {
            
            // I can't find out which code handle the user's login status
            // So I set a temporary BOOL value for test
            //
            if (self.islogined) {
                YXMeUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeUserInfoCell reuseIdentifier] forIndexPath:indexPath];
                cell.userNameLabel.text = [UserServerApi sharedInstance].currentUser.displayName;
                if ([UserServerApi sharedInstance].currentUser.imageUrl) {
                    cell.userAvatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserServerApi sharedInstance].currentUser.imageUrl]]];
                }else{
                cell.userAvatarImageView.image = [UIImage imageNamed:@"3"];
                }
//                [cell.userAvatarImageView setFrame:CGRectMake(cell.userAvatarImageView.frame.origin.x
//                                                                , cell.userAvatarImageView.frame.origin.y, 44, 44)];
                cell.userAvatarImageView.layer.cornerRadius = 22;
                cell.userAvatarImageView.clipsToBounds = YES;
//                cell.userAvatarImageView.image = [UIImage imageNamed:[currentUser.avatarNum stringValue]];
                [cell.logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            else {
                HFMEUserLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFMEUserLoginCell reuseIdentifier] forIndexPath:indexPath];
                return cell;
                
            }
            
//            if (currentUser.alias && currentUser.phoneNum) {
//                cell.hintLabel.hidden = YES;
//                cell.userNameLabel.hidden = cell.userPhoneNumberLabel.hidden = NO;
//                cell.userNameLabel.text = currentUser.alias;
//                cell.userPhoneNumberLabel.text = currentUser.phoneNum;
//            }
//            else if (currentUser.alias && !currentUser.phoneNum) {
//                cell.hintLabel.hidden = cell.userPhoneNumberLabel.hidden = YES;
//                cell.userNameLabel.hidden = NO;
//                cell.userNameLabel.text = currentUser.alias;
//                cell.userNameLabel.center = CGPointMake(cell.userNameLabel.center.x, cell.center.y);
//            }
//            else if (!currentUser.alias && currentUser.phoneNum) {
//                cell.hintLabel.hidden = cell.userNameLabel.hidden = YES;
//                cell.userPhoneNumberLabel.hidden = NO;
//                cell.userPhoneNumberLabel.text = currentUser.phoneNum;
//                cell.userPhoneNumberLabel.center = CGPointMake(cell.userPhoneNumberLabel.center.x, cell.center.y);
//            }
//            else {
//                cell.userPhoneNumberLabel.hidden = cell.userNameLabel.hidden = YES;
//                cell.hintLabel.hidden = NO;
//            }
        }
            break;
        case MeCalendarCell:
        {
            HFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFBindingTableViewCell reuseIdentifier] forIndexPath:indexPath];
            cell.bindingImage.image = [UIImage imageNamed:@"calendar_v2"];
            cell.bindingLabel.text = @"我的行程";
            cell.topSeparatorImageView.hidden = NO;
            cell.bindingSwitch.hidden = YES;
            return cell;
        }
        case MeSpacingCell:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.000];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
//        case MeNotificationCell:
//        {
//            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
//            cell.cellIconImageView.image = [UIImage imageNamed:@"notification"];
//            cell.cellTitleLabel.text = @"通知";
//            cell.bottomSeparatorImageView.hidden = YES;
//            cell.comingSoonLabel.hidden = NO;
//            cell.arrowImageView.hidden = YES;
//            return cell;
//        }
//            break;
//        case MeUsedCouponCell:
//        {
//            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
//            cell.cellIconImageView.image = [UIImage imageNamed:@"record"];
//            cell.cellTitleLabel.text = @"兑换记录";
//            cell.bottomSeparatorImageView.hidden = YES;
//            cell.comingSoonLabel.hidden = YES;
//            cell.arrowImageView.hidden = NO;
//            return cell;
//        }
//            break;
//        case MeFavoriteBrandsCell:
//        {
//            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
//            cell.cellIconImageView.image = [UIImage imageNamed:@"brands"];
//            cell.cellTitleLabel.text = @"偏好品牌";
//            cell.bottomSeparatorImageView.hidden = NO;
//            cell.comingSoonLabel.hidden = YES;
//            cell.arrowImageView.hidden = NO;
//            return cell;
//        }
//            break;
//        case MeRateUsCell:
//        {
//            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
//            cell.cellIconImageView.image = [UIImage imageNamed:@"rate"];
//            cell.cellTitleLabel   .text = @"评分";
//            cell.comingSoonLabel  .hidden = YES;
//            cell.arrowImageView   .hidden = NO;
//            return cell;
//        }
//            break;
        case MeBindingTitleCell:
            {
                YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
                cell.cellTitleLabel   .text = @"绑定账号，让分享更轻松。";
                cell.bottomSeparatorImageView.hidden = NO;
                return cell;
            }
            break;
        case MeBindingWechatCell:
        {
            HFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFBindingTableViewCell reuseIdentifier] forIndexPath:indexPath];
            cell.bindingImage.image = [UIImage imageNamed:@"wechat-friend"];
            cell.bindingLabel.text = @"绑定微信朋友圈";
            cell.topSeparatorImageView.hidden = NO;
            [cell.bindingSwitch setOn:NO];
            [cell.bindingSwitch addTarget:self action:@selector(bindWechat:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
            break;
        case MeBindingWeiboCell:
        {
            HFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFBindingTableViewCell reuseIdentifier] forIndexPath:indexPath];
            cell.bindingImage.image = [UIImage imageNamed:@"sina-weibo"];
            cell.bindingLabel.text = @"绑定新浪微博";
            [cell.bindingSwitch setOn:NO];
            [cell.bindingSwitch addTarget:self action:@selector(bindSinaWeibo:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
            break;
        case MeBindingQQCell:
        {
            HFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFBindingTableViewCell reuseIdentifier] forIndexPath:indexPath];
            cell.bindingImage.image = [UIImage imageNamed:@"qq"];
            cell.bindingLabel.text = @"绑定QQ账号";
            [cell.bindingSwitch setOn:NO];
            [cell.bindingSwitch addTarget:self action:@selector(bindQQ:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
           break;
        
        case MeBindingMobileCell:
        {
            HFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFBindingTableViewCell reuseIdentifier] forIndexPath:indexPath];
            cell.bindingImage.image = [UIImage imageNamed:@"phone"];
            cell.bindingLabel.text = @"绑定手机号码";
            [cell.bindingSwitch setOn:NO];
            return cell;
        }
            break;
//        case MeTermsCell:
//        {
//            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
//            cell.cellIconImageView.hidden = YES;
//            cell.cellTitleLabel   .text = @"使用条款及说明";
//            cell.comingSoonLabel  .hidden = YES;
//            cell.arrowImageView   .hidden = NO;
//            return cell;
//        }
//            break;
        case MeMoreTitleCell:
        {
            YXMeRegularCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeRegularCell reuseIdentifier] forIndexPath:indexPath];
            cell.cellIconImageView.hidden = YES;
            cell.cellTitleLabel   .text = @"了解您，我们会做的更好";
            cell.comingSoonLabel  .hidden = YES;
            cell.arrowImageView   .hidden = YES;
            return cell;
        }
        case MeMoreGenderCell:
        {
            HFGenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFGenderTableViewCell reuseIdentifier] forIndexPath:indexPath];
            return cell;
        }
            break;
        case MeMoreAgeCell:
        {
            HFAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFAgeTableViewCell reuseIdentifier] forIndexPath:indexPath];
            return cell;
        }
            break;
        case MeLikeUsCell:
        {
            HFLikeusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFLikeusTableViewCell reuseIdentifier] forIndexPath:indexPath];
            [cell.feedbackButton addTarget:self action:@selector(handleFeedbackButton:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMeCellType cellType = [[mePageCellsArray objectAtIndex:indexPath.row] intValue];
    
    
    
    switch (cellType) {

        case MeInfoCell:
        {
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(userUpdatedSuccess:)
//                                                         name:@"userUpdatedSuccess" object:nil];
//            
//            [self performSegueWithIdentifier:@"pushToUserInfoSetting"
//                                      sender:self];
            
            if (!self.islogined) {
                
                RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inputNumber"];
                [self.navigationController pushViewController:registerViewController animated:YES];
                
                break;
            }
            else {
                
//                _islogined = NO;
//                [tableView reloadData];
//                break;
            }
            
        }
            break;
        case MeCalendarCell:
        {
            YXCalendarViewController* calender = [self.storyboard instantiateViewControllerWithIdentifier:@"calenderViewXY"];
            [self.navigationController pushViewController:calender animated:YES];
        }
            break;
//
//        case MeFavoriteBrandsCell:
//        {
//            [self performSegueWithIdentifier:@"pushToFavoriteBrands"
//                                      sender:self];
//        }
//            break;
//        case MeUsedCouponCell:
//        {
//            [self performSegueWithIdentifier:@"pushToTransactionRecords"
//                                      sender:self];
//        }
//            break;
//        case MeRateUsCell:
//        {
//            // Open the app store
//            NSString *url = @"itms-apps://itunes.apple.com/app/id882865513";
//            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
//        }
//            break;

        case MeTermsCell:
            {
                HFTermsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HFTermsViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            break;
        default:
            //Coming soon or space cell, don't need to do anything for now
            break;
    }
}

- (void)userUpdatedSuccess: (NSNotification *)notification
{
    UserObject *user = [[UserObject alloc] initWithDictionary:[[notification object] objectForKey:@"user"]];
    [[UserServerApi sharedInstance] setCurrentUser:user];
     currentUser = user;
    
    NSLog(@"Mark - %@", user);    
    
    [self.tableView reloadData];
}

- (IBAction)bindSinaWeibo:(id)sender
{
    UISwitch *swch = (UISwitch *)sender;
    if (swch.isOn) {
        [[HFWeiboService getInstance] initWeiboLoginAuthorizeRequest];
    }else{
        UIAlertView *resendAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要取消绑定？" delegate:self cancelButtonTitle:@"保持绑定" otherButtonTitles:@"取消绑定", nil];
        [resendAlert show];
    }
    
}

- (IBAction)bindWechat:(id)sender {
    UISwitch *swch = (UISwitch *)sender;
    if (swch.isOn) {
        [[HFWeixinService getInstance] sendWechatAuthRequest];
    }else{
        UIAlertView *resendAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要取消绑定？" delegate:self cancelButtonTitle:@"保持绑定" otherButtonTitles:@"取消绑定", nil];
        [resendAlert show];
    }
}

- (IBAction)bindQQ:(id)sender {
    UISwitch *swch = (UISwitch *)sender;
    if (swch.isOn) {
        [[UserServerApi sharedInstance].currentUser.tencentOAuth authorize:[UserServerApi sharedInstance].currentUser.tencentPermissions inSafari:NO];
    }else{
        UIAlertView *resendAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要取消绑定？" delegate:self cancelButtonTitle:@"保持绑定" otherButtonTitles:@"取消绑定", nil];
        [resendAlert show];
    }
}


- (IBAction)handleFeedbackButton:(id)sender {
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    mailComposeVC.mailComposeDelegate = self;
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    
    NSArray *usersTo = [NSArray arrayWithObject: @"feedback@hifu.co "];
    [mailComposeVC setToRecipients:usersTo];
    [mailComposeVC setSubject:@"意见反馈"];
    
    
//    [mailComposeVC setMessageBody:@"body" isHTML:NO];
    [self presentViewController:mailComposeVC animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutButtonClicked:(id)sender {
    UIAlertView *resendAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要退出登录？" delegate:self cancelButtonTitle:@"保持登录" otherButtonTitles:@"退出登录", nil];
    [resendAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[UserServerApi sharedInstance] logoutUser];
        self.islogined = NO;
        [self.tableView reloadData];
    }
}

@end
