//
//  HFTransactionRecordCell.h
//  HiFu
//
//  Created by Yin Xu on 7/19/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGeneralCellProtocol.h"
@class TransactionRecordObject;
@interface HFTransactionRecordCell : UITableViewCell <HFGeneralCellProtocol>

@property (nonatomic, weak) IBOutlet UIView *innerView;
@property (nonatomic, weak) IBOutlet UIImageView *couponImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *couponTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *transactionTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *expireDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *colorLabel;

@property (nonatomic, strong) TransactionRecordObject *transactionRecord;

@end
