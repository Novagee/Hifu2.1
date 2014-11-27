//
//  MFieldDelegator.h
//  HiFu
//
//  Created by Rich on 5/30/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileField.h"
#import "MFieldDelegator.h"

@interface MFieldDelegator : NSObject <UITextFieldDelegate>
@property (weak, nonatomic) MobileField *mobileField;
@property (assign, nonatomic) int num_length;
@property (assign, nonatomic) BOOL isCCChina;
@end
