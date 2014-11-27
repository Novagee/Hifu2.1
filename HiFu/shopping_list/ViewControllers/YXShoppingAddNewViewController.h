//
//  YXShoppingListViewController.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/18/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingItemObject;
@interface YXShoppingAddNewViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, NSLayoutManagerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIView *buttonWrapperView;
@property (nonatomic, weak) IBOutlet UIView *tagsWrapperView;
@property (nonatomic, weak) IBOutlet UIView *enterColorButtonView;
@property (nonatomic, weak) IBOutlet UIView *enterQuantityButtonView;
@property (nonatomic, weak) IBOutlet UIView *enterPriceButtonView;
@property (nonatomic, weak) IBOutlet UIView *enterUserNameButtonView;
@property (nonatomic, weak) IBOutlet UITextView *noteTextView;
@property (nonatomic, weak) IBOutlet UILabel *hintLabel;
@property (nonatomic, weak) IBOutlet UIView *activitySheetView;
@property (nonatomic, weak) IBOutlet UIView *activitySheetWrapperView;

@property (nonatomic, strong) ShoppingItemObject *shoppingItem;

- (IBAction)enterColor:(id)sender;
- (IBAction)enterQuantity:(id)sender;
- (IBAction)enterPrice:(id)sender;
- (IBAction)enterUserName:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)addImage:(id)sender;
- (IBAction)dismissActivitySheet:(id)sender;
- (IBAction)deleteImage:(id)sender;
- (IBAction)readdImage:(id)sender;

@end
