//
//  YXShoppingListTagView.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/19/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXShoppingListTypeEnum.h"

@interface YXShoppingListTagView : UIView

@property (nonatomic, weak) IBOutlet UILabel *roundLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftSideColorLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *priceWrapperView;
@property (nonatomic, weak) IBOutlet UITextField *rmbTextField;
@property (nonatomic, weak) IBOutlet UITextField *usdTextField;

@property (nonatomic, assign) YXShoppingListTagViewType tagType;
@property (nonatomic, assign) float defaultWidth;

- (id)initWithTagType:(YXShoppingListTagViewType)type withTextViewKeyobardType:(UIKeyboardType)keyboardType;
@end
