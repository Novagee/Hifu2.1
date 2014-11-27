//
//  MobileField.h
//  HiFu
//
//  Created by Rich on 5/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPhoneNumberHelpers.h"

/******************
*  NOTE: For UITextFieldDelegate METHODS
*  SEE MFieldDelegator* _mFieldEngine
*  OBJECT DECLARED IN MobileField.m
******************/

@protocol echoDelegate <NSObject>
    @property (nonatomic) HFPhoneNumberHelpers *numOperator;
    -(void)completedNumber;
@optional
    -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
    -(void)textFieldDidBeginEditing:(UITextField *)textField;
    -(void)textFieldDidEndEditing:(UITextField *)textField;
    -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end



@interface MobileField : UITextField <UITextFieldDelegate>

@property (weak, nonatomic) id<echoDelegate> parent;
@property (weak, nonatomic) UILabel *cursorNum;



-(void)shiftCursorForLocation:(int)len;
-(void)fadeOutCursor:(NSRange)range;
@end
