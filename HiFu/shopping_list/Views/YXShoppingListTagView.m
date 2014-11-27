//
//  YXShoppingListTagView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/19/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXShoppingListTagView.h"

@implementation YXShoppingListTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTagType:(YXShoppingListTagViewType)type withTextViewKeyobardType:(UIKeyboardType)keyboardType
{
    self = [[UINib nibWithNibName:@"YXShoppingListTagView" bundle:nil] instantiateWithOwner:nil options:NULL][0];
    if (self) {
        self.tagType = type;
        [HFUIHelpers roundCornerToHFDefaultRadius:self];
        self.roundLabel.layer.cornerRadius = self.roundLabel.frame.size.width / 2;
        self.roundLabel.layer.borderWidth = self.layer.borderWidth = 1;
        self.textView.keyboardType = keyboardType;
        self.priceWrapperView.hidden = YES;
        switch (type) {
            case YXShoppingListBrandTag:
                self.leftSideColorLabel.backgroundColor = HFShoppingListBrandTagColor;
                self.roundLabel.layer.borderColor = self.layer.borderColor = [HFShoppingListBrandTagColor CGColor];
                self.textView.textColor = HFShoppingListBrandTagColor;
                break;
            case YXShoppingListColorTag:
                self.leftSideColorLabel.backgroundColor = HFShoppingListColorTagColor;
                self.roundLabel.layer.borderColor = self.layer.borderColor = [HFShoppingListColorTagColor CGColor];
                self.textView.textColor = HFShoppingListColorTagColor;
                break;
            case YXShoppingListPriceTag:
                self.leftSideColorLabel.backgroundColor = HFShoppingListPriceTagColor;
                self.roundLabel.layer.borderColor = self.layer.borderColor = [HFShoppingListPriceTagColor CGColor];
                self.textView.textColor = HFShoppingListPriceTagColor;
                self.priceWrapperView.hidden = NO;
                self.textView.hidden = YES;
                self.rmbTextField.keyboardType = keyboardType;
                self.usdTextField.keyboardType = keyboardType;
                break;
            case YXShoppingListQuantityTag:
                self.leftSideColorLabel.backgroundColor = HFShoppingListQuantityTagColor;
                self.roundLabel.layer.borderColor = self.layer.borderColor = [HFShoppingListQuantityTagColor CGColor];
                self.textView.textColor = HFShoppingListQuantityTagColor;
                break;
            case YXShoppingListUserNameTag:
                self.leftSideColorLabel.backgroundColor = HFShoppingListUserNameTagColor;
                self.roundLabel.layer.borderColor = self.layer.borderColor = [HFShoppingListUserNameTagColor CGColor];
                self.textView.textColor = HFShoppingListUserNameTagColor;
                break;
            default:
                break;
        }
    }
    return self;
}

@end
