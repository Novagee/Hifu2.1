//
//  MFieldDelegator.m
//  HiFu
//
//  Created by Rich on 5/30/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "MFieldDelegator.h"
#import "ServerModel.h"
#import "UserServerApi.h"

static const int us_num_length = 10;
static const int china_num_length = 11;


@implementation MFieldDelegator

-(int)num_length{
    if ([[UserServerApi sharedInstance].userCountryCode isEqualToString:@"86"]) {
        return china_num_length;
    }else{
        return us_num_length;
    }
}


//-(BOOL)isCCChina{
//    if ([[[ServerModel sharedManager] countryCode] isEqualToString:@"86"]){
//        return YES;
//    }else{
//        return NO;
//    }
//}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.mobileField.parent textFieldShouldBeginEditing:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.mobileField.parent textFieldDidBeginEditing:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.mobileField.parent textFieldDidEndEditing:textField];
}



- (void)selectTextInTextField:(UITextField *)textField range:(NSRange)range {
    
    UITextPosition *from = [textField positionFromPosition : [textField beginningOfDocument]
                                                    offset : range.location];
    
    UITextPosition *to   = [textField positionFromPosition : from
                                                    offset : range.length];
    
    [textField setSelectedTextRange:[textField textRangeFromPosition : from
                                                          toPosition : to]];
    [self.mobileField shiftCursorForLocation    :   (int)range.location];
}



- (BOOL)                textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string{

    [self.mobileField.parent textField:textField
         shouldChangeCharactersInRange:range
                     replacementString:string];
    
    NSLog(@"shouldChangeCharactersInRange");
    if (range.location > textField.text.length) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    
    
    
    [self.mobileField shiftCursorForLocation    :   (int)range.location];
    
    if (![self.mobileField.cursorNum.text isEqualToString:@""]) {
         [self.mobileField.cursorNum setAlpha:1.0];
    }
    
    [self.mobileField fadeOutCursor:(NSRange)range];
    
    
    
    if ([string isEqualToString: @""]) {
        
        
        if ([[textField.text substringFromIndex:textField.text.length-1] isEqualToString:@" "]) {
            
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        
        if (range.location == (newString.length-1)) {
            [self.mobileField shiftCursorForLocation:(int)range.location-1];
        }
        
        [self.mobileField fadeOutCursor:(NSRange)range];
        
        int pos = (int)range.location;
        
        //CALL TO DELEGATE
        self.mobileField.text = [HFPhoneNumberHelpers formatNumberForSpaces:newString];
        
        NSLog(@"pos%i, str%lu",pos,(unsigned long)self.mobileField.text.length);
        
        if (pos < self.mobileField.text.length) {
            [self selectTextInTextField:self.mobileField
                                  range:NSMakeRange(pos, 0)];
        }
        
        return NO;
    }
    int secondSpace = 7;
    if (![HFGeneralHelpers isChinaCountryCode:[UserServerApi sharedInstance].userCountryCode]) {
        secondSpace--;
    }
    
    
    if (textField.text.length==3 || textField.text.length == secondSpace+1) {
        if (range.location == (newString.length-1)) {
            [self.mobileField shiftCursorForLocation:(int)range.location+1];
        }
    }
    
    if (textField.text.length==2) {
        textField.text = [newString stringByAppendingString:@" "];
        [self.mobileField fadeOutCursor:(NSRange)range];
        return NO;
    }
    

    
    if (textField.text.length==secondSpace) {
        
        textField.text = [newString stringByAppendingString:@" "];
        [self.mobileField fadeOutCursor:(NSRange)range];
        return NO;
    }
    
    if (textField.text.length>self.num_length+1) {
        if (range.location>self.num_length+1) {
            textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(self.num_length+1, string.length)
                                                                     withString:string];
        }
        else{
            
        }
        [self.mobileField fadeOutCursor:(NSRange)range];
        return NO;
    }
    
    else{
        
        int pos = (int)range.location;
        
        //ADD DELEGATE
        self.mobileField.text = [HFPhoneNumberHelpers formatNumberForSpaces:newString];
        
        NSLog(@"pos%i, str%i",pos,(int)self.mobileField.text.length);
        
        if (pos < (self.mobileField.text.length-1)) {
            
            [self selectTextInTextField:self.mobileField range:NSMakeRange(pos+1, 0)];
        }
        
        if (self.mobileField.text.length == self.num_length+2 ) {
            
            [self.mobileField.parent completedNumber];
        }
        return NO;
    }
}


@end
