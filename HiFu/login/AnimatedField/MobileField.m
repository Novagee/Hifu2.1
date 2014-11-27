//
//  MobileField.m
//  HiFu
//
//  Created by Rich on 5/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "MobileField.h"
#import "MFieldDelegator.h"

@implementation MobileField{
    MFieldDelegator* _mFieldEngine;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    _mFieldEngine = [[MFieldDelegator alloc]init];
     self.delegate = _mFieldEngine;
    _mFieldEngine.mobileField = self;
}



#pragma mark - trackCursorPos
- (int)cursorPos {
    
    // Get the selected text range
    UITextRange *selectedRange = [self selectedTextRange];
    
    //Calculate the existing position, relative to the beginning of the field
    int pos = [self offsetFromPosition : self.beginningOfDocument
                            toPosition : selectedRange.end];
    
    NSLog(@"pos : %i", pos);
    
    return pos;
    //select it to move cursor
    
}




-(void)shiftCursorForLocation:(int)len{
    
    float newX  = 0;
    float space = 7;
    float startPos = 130.5f;
    
    len = [self cursorPos]-1;
    
    //adjust spacing if US/ChinaNumber
    int secondSpace = 7;
    if (!_mFieldEngine.isCCChina) {
        secondSpace--;
    }
    
    if   (len > 2) {
        newX -= space;
    }
    
    if   (len > secondSpace) {
        newX -= space;
    }
    

    NSLog(@"LEN POS : %i",len);
    newX += startPos + (13.833333f*len);
    
    [self.cursorNum setFrameX:newX];
}




-(void)fadeOutCursor:(NSRange)range{
    
    float speed = 0.75f;
    
    if (range.location>=12) {
        speed= speed/2;
    }
    
    [UIView animateWithDuration:speed animations:^{
        [self.cursorNum setAlpha:0.0];
    }];
}

@end
