//
//  HFTransactionRecordsViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "HFTransactionRecordsViewController.h"

//cell
#import "HFTransactionRecordCell.h"

//Apis
#import "TransactionRecordApi.h"
#import "UserServerApi.h"

//Objects
#import "UserObject.h"
#import "CouponObject.h"
#import "TransactionRecordObject.h"
#import "MerchantObject.h"

@interface HFTransactionRecordsViewController ()
{
    NSMutableArray *transactionRecordsArray;
}

@end

@implementation HFTransactionRecordsViewController

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
    self.navigationItem.title = @"兑换记录";
    [self.tableView registerNib:[HFTransactionRecordCell cellNib] forCellReuseIdentifier:[HFTransactionRecordCell reuseIdentifier]];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [self getTransactionRecords];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Api calls
- (void)getTransactionRecords
{
    [SVProgressHUD show];
    transactionRecordsArray = [NSMutableArray new];
    [TransactionRecordApi getTransactionRecordsForUser:[UserServerApi sharedInstance].currentUser.itemId
                                               success:^(id transactionRecords) {
                                                   if ([transactionRecords count] > 0) {
                                                       self.noRecordImageView.hidden = YES;
                                                       self.tableView.hidden = NO;
                                                       
                                                       for (NSDictionary *dict in transactionRecords) {
                                                           TransactionRecordObject *t = [[TransactionRecordObject alloc] initWithDictionary:dict];
                                                           [transactionRecordsArray addObject:t];
                                                       }
                                                       [self.tableView reloadData];
                                                   }
                                                   else
                                                   {
                                                       self.noRecordImageView.hidden = NO;
                                                       self.tableView.hidden = YES;
                                                   }
                                                   [SVProgressHUD dismiss];
                                               } failure:^(NSError *error) {
                                                   NSLog(@"%@", error);
                                               }];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionRecordsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HFTransactionRecordCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFTransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[HFTransactionRecordCell reuseIdentifier]];
    cell.transactionRecord = [transactionRecordsArray objectAtIndex:indexPath.row];
    
    [cell.logoImageView setImageWithURL:[NSURL URLWithString:cell.transactionRecord.coupon.merchant.logoPictureUrl]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       if (image && !error) {
                                           cell.logoImageView.image = image;
                                           cell.logoImageView.clipsToBounds = YES;
                                           
                                       }
                                   }];
    
    [cell.couponImageView setImageWithURL:[NSURL URLWithString:cell.transactionRecord.coupon.merchant.coverPictureUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (image && !error) {
                                      cell.couponImageView.image = image;
                                      cell.couponImageView.clipsToBounds = YES;
                                      
                                  }
                              }];
    cell.couponTitleLabel.text = cell.transactionRecord.coupon.shortTitleCN;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    cell.transactionTimeLabel.text = [formatter stringFromDate:cell.transactionRecord.transactionTime];
    
    if (!cell.transactionRecord.coupon.isAvailable) {
        cell.expireDateLabel.text = @"已过期";
        cell.colorLabel.backgroundColor = [UIColor colorWithWhite:0.533 alpha:1.000];
    }
    else
    {
        cell.expireDateLabel.text =[HFGeneralHelpers getExpireTimeStringFrom:cell.transactionRecord.coupon.expiredAt];
        cell.colorLabel.backgroundColor = [UIColor colorWithRed:0.325 green:0.843 blue:0.412 alpha:1.000];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
