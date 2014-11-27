//
//  YXMeInfoSettingViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeInfoSettingViewController.h"
#import "RegisterViewController.h"

//cells
#import "YXMeSettingAvatarCell.h"
#import "YXMeSettingNameCell.h"
#import "YXMeSettingPhoneCell.h"
#import "YXMeSettingGenderCell.h"
#import "YXMeSettingLocationCell.h"

//objects
#import "UserObject.h"
#import "YXMeCellTypeEnum.h"

//Apis
#import "UserServerApi.h"

//Helpers
#import "HFGeneralHelpers.h"


@interface YXMeInfoSettingViewController ()
{
    NSArray *infoSettingCellsArray;
    NSNumber *userAvatarNum;
    NSString *userAlias, *userGender, *userCountry;
}

@end

@implementation YXMeInfoSettingViewController

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
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];
    infoSettingCellsArray = [NSArray arrayWithObjects:@(AvatarSettingCell), @(NameSettingCell), @(PhoneNumberSettingCell), @(GenderSettingCell), @(CountrySettingCell), nil];
    
    [self.tableView registerNib:[YXMeSettingAvatarCell   cellNib] forCellReuseIdentifier:[YXMeSettingAvatarCell   reuseIdentifier]];
    [self.tableView registerNib:[YXMeSettingNameCell     cellNib] forCellReuseIdentifier:[YXMeSettingNameCell     reuseIdentifier]];
    [self.tableView registerNib:[YXMeSettingPhoneCell    cellNib] forCellReuseIdentifier:[YXMeSettingPhoneCell    reuseIdentifier]];
    [self.tableView registerNib:[YXMeSettingGenderCell   cellNib] forCellReuseIdentifier:[YXMeSettingGenderCell   reuseIdentifier]];
    [self.tableView registerNib:[YXMeSettingLocationCell cellNib] forCellReuseIdentifier:[YXMeSettingLocationCell reuseIdentifier]];
    
    if (self.currentUser.avatarNum)
        userAvatarNum = self.currentUser.avatarNum;
    
    if (self.currentUser.alias)
        userAlias = self.currentUser.alias;
    
    if (self.currentUser.gender)
        userGender = self.currentUser.gender;
    
    if (self.currentUser.countryName)
        userCountry = self.currentUser.countryName;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userGenderValueChanged:) name:@"userGenderValueChanged" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCountryValueChanged:) name:@"userCountryValueChanged" object:nil];
}

- (void)userGenderValueChanged:(NSNotification *)notification
{
    userGender = [notification object];
}

- (void)userCountryValueChanged:(NSNotification *)notification
{
    userCountry = [notification object];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoSettingCellsArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMeInfoSettingCellType cellType = [[infoSettingCellsArray objectAtIndex:indexPath.row] intValue];
    
    switch (cellType) {
        case AvatarSettingCell:
            return [YXMeSettingAvatarCell heightForCell];
            break;
        case NameSettingCell:
            return [YXMeSettingNameCell heightForCell];
            break;
        case PhoneNumberSettingCell:
            return [YXMeSettingPhoneCell heightForCell];
            break;
        case GenderSettingCell:
            return [YXMeSettingGenderCell heightForCell];
            break;
        case CountrySettingCell:
            return [YXMeSettingLocationCell heightForCell];
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMeInfoSettingCellType cellType = [[infoSettingCellsArray objectAtIndex:indexPath.row] intValue];
    
    switch (cellType) {
        case AvatarSettingCell:
        {
            YXMeSettingAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeSettingAvatarCell reuseIdentifier] forIndexPath:indexPath];
            cell.userAvatarImageView.image = [UIImage imageNamed: [self.currentUser.avatarNum stringValue]];
            return cell;
        }
            break;
        case NameSettingCell:
        {
            YXMeSettingNameCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeSettingNameCell reuseIdentifier] forIndexPath:indexPath];
            cell.userNameTextField.delegate = self;
            if (self.currentUser && self.currentUser.alias) {
                cell.userNameTextField.text = self.currentUser.alias;
            }
            return cell;
        }
            break;
        case PhoneNumberSettingCell:
        {
            YXMeSettingPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeSettingPhoneCell reuseIdentifier] forIndexPath:indexPath];
            if (self.currentUser && self.currentUser.phoneNum) {
                cell.cellTitleLabel.text = @"手机";
                cell.userPhoneNumberLabel.hidden = NO;
                cell.userPhoneNumberLabel.text = self.currentUser.phoneNum;
            }
            else
            {
                cell.cellTitleLabel.text = @"点击绑定手机";
                cell.userPhoneNumberLabel.hidden = YES;
            }
            
            return cell;
        }
            break;
        case GenderSettingCell:
        {
            YXMeSettingGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeSettingGenderCell reuseIdentifier] forIndexPath:indexPath];
            if (userGender) {
                if ([userGender isEqualToString:@"Male"]) {
                    [cell.genderSegmentedControl setSelectedSegmentIndex:0];
                }
                else
                {
                    [cell.genderSegmentedControl setSelectedSegmentIndex:1];
                }
            }
            return cell;
        }
            break;
        case CountrySettingCell:
        {
            YXMeSettingLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXMeSettingLocationCell reuseIdentifier] forIndexPath:indexPath];
            if (userCountry) {
                if ([userCountry isEqualToString:@"China"]) {
                    [cell.countrySegmentedControl setSelectedSegmentIndex:0];
                }
                else
                {
                    [cell.countrySegmentedControl setSelectedSegmentIndex:1];
                }
            }
            return cell;
        }
            break;
    }

    return nil;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMeInfoSettingCellType cellType = [[infoSettingCellsArray objectAtIndex:indexPath.row] intValue];
    
    switch (cellType) {
        case AvatarSettingCell:
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAvatarSelected:) name:@"userAvatarSelected" object:nil];
            [self performSegueWithIdentifier:@"pushToAvatarSetting" sender:self];
            break;
        case GenderSettingCell:
        case NameSettingCell:
        case CountrySettingCell:
            //do nothing
            break;
        case PhoneNumberSettingCell:
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPhoneNumberLinked) name:@"userPhoneNumberLinked" object:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RegisterViewController *storeView = (RegisterViewController *)[storyboard instantiateViewControllerWithIdentifier:@"inputNumber"];
//            storeView.isFromUserSettings = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:storeView];
            [self presentViewController:nav animated:YES completion:nil];
//            [self.navigationController pushViewController:storeView animated:YES];
            //dont know what to do yet
        }
            break;
    }
}

- (void)userPhoneNumberLinked
{
    self.currentUser = [UserServerApi sharedInstance].currentUser;
    YXMeSettingPhoneCell *cell = (YXMeSettingPhoneCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (self.currentUser && self.currentUser.phoneNum) {
        cell.cellTitleLabel.text = @"手机";
        cell.userPhoneNumberLabel.hidden = NO;
        cell.userPhoneNumberLabel.text = self.currentUser.phoneNum;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userPhoneNumberLinked" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    userAlias = textField.text;
}



- (void)userAvatarSelected:(NSNotification *)notification
{
    
    YXMeSettingAvatarCell *cell = (YXMeSettingAvatarCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.userAvatarImageView.image = [UIImage imageNamed:[[notification object] stringValue]];
    
    NSLog(@"AVATAR IMAGE: %@",[notification object]);
    
    
    if (![[notification object] isKindOfClass:NSNumber.class]) {
        NSLog(@"wrong kind not NSNUMBER for avatarImage");
    }
    
    userAvatarNum = [notification object];
}



- (IBAction)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.currentUser.itemId forKey:@"id"];
    [params setObject:userAvatarNum forKey:@"avatarNum"];
    
    if (userAlias)
        [params setObject:userAlias forKey:@"alias"];
    
    if (userGender)
        [params setObject:userGender forKey:@"gender"];
    
    if (userCountry)
        [params setObject:userCountry forKey:@"countryName"];

    [[UserServerApi sharedInstance] updateCurrentUserWithParams:params
                                           success:^(id userInfo) {
                                               [self.navigationController popViewControllerAnimated:YES];
                                           } failure:^(NSError *error) {
                                               [HFGeneralHelpers showErrorAlertViewBasedOn:error];
                                           }];
}

@end


