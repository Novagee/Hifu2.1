//
//  YXShoppingListViewController.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/18/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "YXShoppingAddNewViewController.h"
#import "YXShoppingListAddedImageView.h"
#import "YXShoppingListTagView.h"
#import "YXShoppingListTypeEnum.h"

//Apis
#import "ShoppingListServerApi.h"
#import "ServerModel.h"

//Object
#import "ShoppingItemObject.h"

#define brandTagDefaultWidth 250
#define colorTagDefaultWidht 80
#define quantityTagDefaultWidth 80
#define userNameTagDefaultWidth 120
#define priceTagDefaultWidth 210

@interface YXShoppingAddNewViewController ()
{
    NSMutableArray *imageArray, *buttonsArray;
    NSMutableArray *tagViewsArray;
    YXShoppingListTagView *currentEditingTagView, *brandTagView, *quantityTagView, *priceTagView, *colorTagView, *userNameTagView;
    NSString *brand, *color, *quantity, *userName, *note;
    float heightChanged, priceRMB, priceUSD;
    UILabel *fakeStatusBarBackground;
    BOOL isEditingItem, isPictureChanged, hasImage;
    UIImage *selectImage;
}

@end

@implementation YXShoppingAddNewViewController

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
    imageArray = [NSMutableArray new];
    tagViewsArray = [NSMutableArray new];
    buttonsArray = [[NSMutableArray alloc]initWithObjects:self.enterColorButtonView, self.enterQuantityButtonView, self.enterPriceButtonView, self.enterUserNameButtonView, nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];    self.activitySheetView.frame = CGRectMake(0, self.activitySheetWrapperView.frame.size.height, 320, self.activitySheetView.frame.size.height);
    self.activitySheetWrapperView.alpha = 0.0;
    self.activitySheetWrapperView.hidden = YES;
    
    [self initialTagViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)initialTagViews
{
    self.noteTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.noteTextView.layer.borderWidth = 0.5;
    self.noteTextView.delegate = self;
    [HFUIHelpers roundCornerToHFDefaultRadius:self.noteTextView];
    self.noteTextView.hidden = YES;

    brandTagView = [self generateTagViewForType:YXShoppingListBrandTag andDefaultWidth:brandTagDefaultWidth andKeyboardType:UIKeyboardTypeDefault];
    
    if (self.shoppingItem) {
        isEditingItem = YES;
        if (self.shoppingItem.brand) {
            [self setTagView:brandTagView forText:self.shoppingItem.brand];
            brandTagView.textView.text = self.shoppingItem.brand;
        }
        
        if (self.shoppingItem.color) {
            colorTagView = [self generateTagViewForType:YXShoppingListColorTag
                                        andDefaultWidth:colorTagDefaultWidht
                                        andKeyboardType:UIKeyboardTypeDefault];
            [self setTagView:colorTagView forText:self.shoppingItem.color];
            colorTagView.textView.text = self.shoppingItem.color;
            self.enterColorButtonView.alpha = 0.0;
            [buttonsArray removeObject:self.enterColorButtonView];
        }
        
        if (self.shoppingItem.quantity) {
            quantityTagView = [self generateTagViewForType:YXShoppingListQuantityTag
                                           andDefaultWidth:quantityTagDefaultWidth
                                           andKeyboardType:UIKeyboardTypeNumberPad];
            [self setTagView:quantityTagView forText:[self.shoppingItem.quantity stringValue]];
            quantityTagView.textView.text = [self.shoppingItem.quantity stringValue];
            self.enterQuantityButtonView.alpha = 0.0;
            [buttonsArray removeObject:self.enterQuantityButtonView];
        }
        
        if (self.shoppingItem.forWhom) {
            userNameTagView = [self generateTagViewForType:YXShoppingListUserNameTag
                                           andDefaultWidth:userNameTagDefaultWidth
                                           andKeyboardType:UIKeyboardTypeDefault];
            [self setTagView:userNameTagView forText:self.shoppingItem.forWhom];
            userNameTagView.textView.text = self.shoppingItem.forWhom;
            self.enterUserNameButtonView.alpha = 0.0;
            [buttonsArray removeObject:self.enterUserNameButtonView];
        }
        
        if (self.shoppingItem.priceInUSD) {
            priceTagView = [self generateTagViewForType:YXShoppingListPriceTag
                                        andDefaultWidth:priceTagDefaultWidth
                                        andKeyboardType:UIKeyboardTypeDecimalPad];
            float rmb = [self.shoppingItem.priceInUSD floatValue] * 6.23;
            priceTagView.rmbTextField.delegate = self;
            priceTagView.usdTextField.delegate = self;
            priceTagView.rmbTextField.text = [NSString stringWithFormat:@"%.0f", rmb];
            priceRMB = rmb;
            priceTagView.usdTextField.text = [NSString stringWithFormat:@"%.0f", [self.shoppingItem.priceInUSD floatValue]];
            priceUSD = [self.shoppingItem.priceInUSD floatValue];
            self.enterPriceButtonView.alpha = 0.0;
            [buttonsArray removeObject:self.enterPriceButtonView];
        }

        if (self.shoppingItem.notes) {
            self.noteTextView.text = self.shoppingItem.notes;
        }
        
        if (self.shoppingItem.picture) {
            hasImage = YES;
            self.photoImageView.image = self.shoppingItem.picture;
        }
        else if (self.shoppingItem.pictureUrl && ![self.shoppingItem.pictureUrl isEqualToString:@""])
        {
            hasImage = YES;
            [self.photoImageView setImageWithURL:[NSURL URLWithString:self.shoppingItem.pictureUrl]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                           if (image && !error) {
                                               self.photoImageView.image = image;
                                           }
            }];
        }
        else
        {
            hasImage = NO;
            self.photoImageView.image = [UIImage imageNamed:@"default-pic"];
        }
        
    }
    else
    {
        isEditingItem = NO;
        brandTagView.textView.text = @"品牌型号";
        brandTagView.textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"添加清单";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeTheNavBarToHide:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - NSLayoutManager Delegate 

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return HFShoppingListTagTextViewLineSpace; // For line space in text view
}

#pragma mark - Action Methods
- (IBAction)enterColor:(id)sender
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self animationForRemovingButtonView:self.enterColorButtonView];
    } completion:^(BOOL finished) {
        [self moveViewUpForEnterData];
        colorTagView = [self generateTagViewForType:YXShoppingListColorTag
                                    andDefaultWidth:colorTagDefaultWidht
                                    andKeyboardType:UIKeyboardTypeDefault];
        currentEditingTagView = colorTagView;
        [colorTagView.textView becomeFirstResponder];
    }];
}

- (IBAction)enterQuantity:(id)sender
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self animationForRemovingButtonView:self.enterQuantityButtonView];
    } completion:^(BOOL finished) {
        [self moveViewUpForEnterData];
        quantityTagView = [self generateTagViewForType:YXShoppingListQuantityTag
                                       andDefaultWidth:quantityTagDefaultWidth
                                       andKeyboardType:UIKeyboardTypeNumberPad];
        quantityTagView.textView.text = @"数量";
        quantityTagView.textView.textColor = [UIColor lightGrayColor];
        [quantityTagView.textView becomeFirstResponder];
    }];

  }

- (IBAction)enterPrice:(id)sender
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self animationForRemovingButtonView:self.enterPriceButtonView];
    } completion:^(BOOL finished) {
        [self moveViewUpForEnterData];
        priceTagView = [self generateTagViewForType:YXShoppingListPriceTag
                                    andDefaultWidth:priceTagDefaultWidth
                                    andKeyboardType:UIKeyboardTypeDecimalPad];
        currentEditingTagView = priceTagView;
        priceTagView.rmbTextField.delegate = self;
        priceTagView.usdTextField.delegate = self;
        [priceTagView.rmbTextField becomeFirstResponder];
    }];
}

- (IBAction)enterUserName:(id)sender
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self animationForRemovingButtonView:self.enterUserNameButtonView];
    } completion:^(BOOL finished) {
        [self moveViewUpForEnterData];
        userNameTagView = [self generateTagViewForType:YXShoppingListUserNameTag
                                       andDefaultWidth:userNameTagDefaultWidth
                                       andKeyboardType:UIKeyboardTypeDefault];
        currentEditingTagView = userNameTagView;
        [userNameTagView.textView becomeFirstResponder];
    }];
}

- (IBAction)doneButtonClicked:(id)sender
{
    if (!self.shoppingItem) {
        //creating item
        if (!brand || [brand isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"品牌名称" message:@"请输入品牌名称" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [self acutalCreateItem];
        }
    }
    else//updating item
    {
        [self actualUpdateItem];
    }
}

- (IBAction)addImage:(id)sender
{
    if (!hasImage) {
        [self goToPhotoLibrary];
    }
    else
    {
        self.activitySheetWrapperView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            self.activitySheetWrapperView.alpha = 1.0;
            self.activitySheetView.frame = CGRectMake(0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.activitySheetView.frame.size.height, 320, self.activitySheetView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)dismissActivitySheet:(id)sender
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activitySheetWrapperView.alpha = 0.0;
        self.activitySheetView.frame = CGRectMake(0, self.activitySheetWrapperView.frame.size.height, 320, self.activitySheetView.frame.size.height);
    } completion:^(BOOL finished) {
        self.activitySheetWrapperView.hidden = NO;
    }];
}

- (IBAction)deleteImage:(id)sender
{
    selectImage = nil;
    self.photoImageView.image = [UIImage imageNamed:@"default-pic"];
    hasImage = NO;
    [self dismissActivitySheet:nil];
}

- (IBAction)readdImage:(id)sender
{
    [self dismissActivitySheet:nil];
    [self goToPhotoLibrary];
}

- (void)goToPhotoLibrary
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageAdded:) name:HFFinishPickingPhotos object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPictureTaken:) name:HFFinishTakingPicture object:nil];
    [self performSegueWithIdentifier:HFSeguePushToPhotoLibrary sender:nil];
}

#pragma mark - Apis
- (void)acutalCreateItem
{
    [SVProgressHUD show];
    
    NSMutableDictionary *params = [self constructItemParameters];
    
    [ShoppingListServerApi saveShoppingListItemWithParams:params
                                                   andImage:hasImage ? self.photoImageView.image : nil
                                                    success:^(id shoppingItems) {
                                                        self.shoppingItem.itemId = [[shoppingItems objectForKey:@"id"] stringValue];
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:HFFinishAddingNewShoppingItem object:self.shoppingItem];
                                                        [SVProgressHUD dismiss];
                                                    } failure:^(NSError *error) {
                                                        NSLog(@"save shopping list item failed");
                                                        [SVProgressHUD dismiss];
                                                    }];
}

- (void)actualUpdateItem
{
    [SVProgressHUD show];
    
    NSMutableDictionary *params = [self constructItemParameters];
    
    [ShoppingListServerApi updateShoppingListItemWithParams:params
                                               didImageChange:isPictureChanged
                                                     andImage:self.photoImageView.image
                                                      success:^{
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:HFFinishEditingShoppingItem object:self.shoppingItem];
                                                          [SVProgressHUD dismiss];
                                                          
                                                      } failure:^(NSError *error) {
                                                          NSLog(@"save shopping list item failed");
                                                          [SVProgressHUD dismiss];
                                                      }];
}

- (NSMutableDictionary *)constructItemParameters
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[ServerModel sharedManager].userInfo.itemId forKey:@"userId"];
    [params setObject:@(0) forKey:@"bought"];
    
    if (!isEditingItem) {
        self.shoppingItem = [[ShoppingItemObject alloc] init];
    }
    else
    {
        [params setObject:self.shoppingItem.itemId forKey:@"itemId"];
    }
    
    self.shoppingItem.picture = hasImage ? self.photoImageView.image : nil;
    
    if (brand) {
        self.shoppingItem.brand = brand;
        [params setObject:brand forKey:@"brand"];
    }
    
    if (color) {
        self.shoppingItem.color = color;
        [params setObject:color forKey:@"color"];
    }
    
    if (color) {
        self.shoppingItem.color = color;
        [params setObject:color forKey:@"color"];
    }
    
    
    if (quantity) {
        self.shoppingItem.quantity = @([quantity intValue]);
        [params setObject:@([quantity intValue]) forKey:@"quantity"];
    }
    
    if (priceUSD) {
        self.shoppingItem.priceInUSD = @(priceUSD);
        [params setObject:@(priceUSD) forKey:@"priceInUSD"];
    }
    
    
    if (userName) {
        self.shoppingItem.forWhom = userName;
        [params setObject:userName forKey:@"forWhom"];
    }
    
    
    if (note) {
        self.shoppingItem.notes = note;
        [params setObject:note forKey:@"notes"];
    }
    
    return params;
}


#pragma mark - Text View Delegate
- (void)changeTheNavBarToHide:(BOOL)isHide
{
    if (!fakeStatusBarBackground) {
        fakeStatusBarBackground = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        fakeStatusBarBackground.backgroundColor = [UIColor colorWithRed:0.980 green:0.392 blue:0.420 alpha:1.000];
    }
    
    if (isHide) {
        [[UIApplication sharedApplication].keyWindow addSubview:fakeStatusBarBackground];
    }
    else
    {
        [fakeStatusBarBackground removeFromSuperview];
        fakeStatusBarBackground = nil;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         CGRect rect = self.navigationController.navigationBar.frame;
         rect.origin = CGPointMake(0, isHide ? -self.navigationController.navigationBar.frame.size.height : 20);
         self.navigationController.navigationBar.frame = rect;
         self.view.frame = CGRectMake(0, isHide ? -self.navigationController.navigationBar.frame.size.height : 64, 320, self.view.frame.size.height);
     }
                     completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self changeTheNavBarToHide:YES];
    if ([textView isEqual:self.noteTextView] &&
        [textView.text isEqualToString:@"点这里输入备注"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        [self.mainScrollView setContentOffset:CGPointMake(0, 180) animated:YES];
        self.mainScrollView.contentSize = CGSizeMake(320, 568);
        [self.mainScrollView setScrollEnabled:YES];

        if (self.noteTextView.frame.size.height > (self.view.frame.size.height - HF_KEYBOARD_HEIGHT)) {
            self.noteTextView.frame = CGRectMake(self.noteTextView.frame.origin.x,
                                                 self.noteTextView.frame.origin.y,
                                                 self.noteTextView.frame.size.width,
                                                 (self.view.frame.size.height - HF_KEYBOARD_HEIGHT));
        }
    }
    else
    {
        [self moveViewUpForEnterData];
        if ([textView isEqual:brandTagView.textView] && [textView.text isEqualToString:@"品牌型号"])
        {
            textView.text = @"";
            textView.textColor = HFShoppingListBrandTagColor;
        }
        else if ([textView isEqual:quantityTagView.textView] && [textView.text isEqualToString:@"数量"])
        {
            textView.text = @"";
            textView.textColor = HFShoppingListQuantityTagColor;
        }
        else if ([textView isEqual:colorTagView.textView] && [textView.text isEqualToString:@"颜色"])
        {
            textView.text = @"";
            textView.textColor = HFShoppingListColorTagColor;
        }
        currentEditingTagView = (YXShoppingListTagView *)textView.superview;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (![textView isEqual:self.noteTextView]) {
        [textView setScrollEnabled:NO];
        //we want to dynamically enlarge the text view, so user can see the entire text view
        YXShoppingListTagView *view = (YXShoppingListTagView *)textView.superview;
        [self setTagView:view forText:textView.text];
    }
    else
    {
        note = self.noteTextView.text;
    }
}

- (void)setTagView:(YXShoppingListTagView *)view forText:(NSString *)text
{
    switch (view.tagType) {
        case YXShoppingListBrandTag:
            brand = text;
            break;
        case YXShoppingListColorTag:
            color = text;
            break;
        case YXShoppingListQuantityTag:
            quantity = text;
            break;
        case YXShoppingListUserNameTag:
            userName = text;
            break;
        default:
            break;
    }
    
    //rest the height change back to 0
    heightChanged = 0;
    
    NSInteger indexOfView = [tagViewsArray indexOfObject:view];
    float currentViewHeight = view.frame.size.height;
    float targetHeight = view.frame.size.height;
    float lastViewBottom = 0.0f;
    float lastViewRight = 0.0f;
    
    if ([tagViewsArray count] > 1 && indexOfView != 0) {
        YXShoppingListTagView *lastView = [tagViewsArray objectAtIndex:indexOfView- 1];
        lastViewRight= lastView.frame.origin.x + lastView.frame.size.width;
        lastViewBottom = lastView.frame.origin.y + lastView.frame.size.height;
    }
    
    //get the width for text with 20 pixel extra margin
    int textWidth = [HFGeneralHelpers getTextWidth:text andFont:view.textView.font andHeight:HFShoppingListTagViewDefaultTextViewHeight] + 20;
    
    //if width is longer than the default width but shorter than the maxWidth, so we only need to change the width
    if (textWidth >= view.defaultWidth - HFShoppingListTagViewHorizontalSpace && textWidth <= (HFShoppingListTagViewMaxWidth - HFShoppingListTagViewHorizontalSpace)) {
        float newOriginY = view.frame.origin.y;
        float newOriginX = view.frame.origin.x;
        //if the remain space is not enough, move to next line
        if (textWidth + HFShoppingListTagViewHorizontalSpace > HFShoppingListTagViewMaxWidth - lastViewRight) {
            newOriginY = lastViewBottom + HFShoppingListHorizontalSpaceBetweenTagViews;
            newOriginX = 0;
        }
        [self changeTagView:view
                   ToOrigin:CGPointMake(newOriginX, newOriginY)
                   andWidth:textWidth + HFShoppingListTagViewHorizontalSpace
                  andHeight:targetHeight];
    }
    else if (textWidth > (HFShoppingListTagViewMaxWidth - HFShoppingListTagViewHorizontalSpace))//if it gets the max width, we need to enlarge the height
    {
        //get the height for text with 20 pixel margin
        int textHeight = [HFGeneralHelpers getTextHeight:text andFont:view.textView.font andWidth:(HFShoppingListTagViewMaxWidth - HFShoppingListTagViewHorizontalSpace)] + 20;
        
        //if height is longer then the default, but shorter than the max, we change the height accordingly
        if (textHeight > HFShoppingListTagViewDefaultTextViewHeight && textHeight <HFShoppingListTagViewMaxTextViewHeight) {
            int lineCount = [HFGeneralHelpers getTextLineCount:text andFont:view.textView.font andWidth:(HFShoppingListTagViewMaxWidth - HFShoppingListTagViewHorizontalSpace)];
            targetHeight = textHeight + HFShoppingListTagViewVerticalSpace + lineCount * HFShoppingListTagTextViewLineSpace;
            heightChanged = targetHeight - currentViewHeight;
            [self changeTagView:view
                       ToOrigin:view.frame.origin
                       andWidth:HFShoppingListTagViewMaxWidth
                      andHeight:targetHeight];
        }
        else if (textHeight <= HFShoppingListTagViewDefaultTextViewHeight)//if the height is shorter than default, just set it back to default
        {
            targetHeight = HFShoppingListTagViewDefaultTextViewHeight + HFShoppingListTagViewVerticalSpace;
            heightChanged = targetHeight - currentViewHeight;
            [self changeTagView:view
                       ToOrigin:view.frame.origin
                       andWidth:HFShoppingListTagViewMaxWidth
                      andHeight:targetHeight];
        }
        else
        {
            [view.textView setScrollEnabled:YES];
        }
    }
    else if (textWidth < view.defaultWidth - HFShoppingListTagViewHorizontalSpace)
    {
        targetHeight = HFShoppingListTagViewDefaultTextViewHeight + HFShoppingListTagViewVerticalSpace;
        heightChanged = targetHeight - currentViewHeight;
        [self changeTagView:view
                   ToOrigin:view.frame.origin
                   andWidth:view.defaultWidth
                  andHeight:targetHeight];
    }
    
    //update all the following tag views
    [self updateAllTagViewsBasedOnIndex:indexOfView];
    //update the size of note text view
    [self changeNoteTextViewFrameBasedOnView:[tagViewsArray lastObject]];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return NO;
    }else{
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.mainScrollView.contentSize = CGSizeMake(320, 568);
    [self.mainScrollView setScrollEnabled:NO];
    [self changeTheNavBarToHide:NO];
    if ([textView isEqual:brandTagView.textView] && [brandTagView.textView.text isEqualToString:@""])
    {
        textView.text = @"品牌型号";
        textView.textColor = [UIColor lightGrayColor];
    }
    else if ([textView isEqual:quantityTagView.textView] && [textView.text isEqualToString:@""])
    {
        textView.text = @"数量";
        textView.textColor =  [UIColor lightGrayColor];
    }
    else if ([textView isEqual:colorTagView.textView] && [textView.text isEqualToString:@""])
    {
        textView.text = @"颜色";
        textView.textColor =  [UIColor lightGrayColor];
    }
    else if ([textView isEqual:userNameTagView.textView] && [textView.text isEqualToString:@""])
    {
        textView.text = @"替谁买";
        textView.textColor =  [UIColor lightGrayColor];
    }
    else if ([textView isEqual:self.noteTextView] &&
        [textView.text isEqualToString:@""])
    {
        textView.text = @"点这里输入备注";
        textView.textColor = [UIColor blackColor];
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self changeTheNavBarToHide:YES];
    [self moveViewUpForEnterData];
    currentEditingTagView = (YXShoppingListTagView *)textField.superview.superview;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.mainScrollView.contentSize = CGSizeMake(320, 568);
    [self.mainScrollView setScrollEnabled:NO];
    [self changeTheNavBarToHide:NO];
    if (([textField isEqual:priceTagView.usdTextField] || [textField isEqual:priceTagView.rmbTextField]) && [textField.text isEqualToString:@""])
    {
        priceTagView.usdTextField.text = @"";
        priceTagView.rmbTextField.text = @"";
    }
    else
    {
        if (![priceTagView.rmbTextField.text isEqualToString:@""])
        {
            priceRMB = [priceTagView.rmbTextField.text floatValue];
            priceUSD = priceRMB / 6.23;
            priceTagView.usdTextField.text = [NSString stringWithFormat:@"%.0f", priceUSD];
        }
        else
        {
            priceUSD = [priceTagView.usdTextField.text floatValue];
            priceRMB = priceUSD * 6.23;
            priceTagView.rmbTextField.text = [NSString stringWithFormat:@"%.0f", priceRMB];
        }
    }

    return YES;
}

#pragma mark - UIScroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    currentEditingTagView = nil;
    if (self.mainScrollView.contentOffset.y != 0) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - Helper Methods

- (void)animationForRemovingButtonView:(UIView *)view
{
    view.transform = CGAffineTransformMakeScale(1.5, 1.5);
    view.alpha = 0.0;
    [buttonsArray removeObject:view];
    for (int i = 0; i < [buttonsArray count]; i ++) {
        UIView *buttonView = [buttonsArray objectAtIndex:i];
        buttonView.frame = CGRectMake(0, 5+i*55, 50, 50);
    }
}

- (void)moveViewUpForEnterData
{
    self.mainScrollView.contentSize = CGSizeMake(320, 568);
    [self.mainScrollView setScrollEnabled:YES];
    [self.mainScrollView setContentOffset:CGPointMake(0, self.photoImageView.frame.size.height - 64) animated:YES];
}

- (YXShoppingListTagView *)generateTagViewForType:(YXShoppingListTagViewType)type andDefaultWidth:(float)width andKeyboardType:(UIKeyboardType)keyboardType
{
    YXShoppingListTagView *view = [[YXShoppingListTagView alloc] initWithTagType:type withTextViewKeyobardType:keyboardType];
    view.defaultWidth = width;
    CGPoint o = [self getNewTagViewOriginForView:view];
    view.frame = CGRectMake(o.x, o.y, width, HFShoppingListTagViewDefaultHeight);
    [self.tagsWrapperView addSubview:view];
    [self changeNoteTextViewFrameBasedOnView:view];
    self.noteTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.noteTextView.layer.borderWidth = 0.5;
    [tagViewsArray addObject:view];
    view.textView.delegate = self;
    view.textView.layoutManager.delegate = self;
    if (self.noteTextView.hidden) {
        self.noteTextView.hidden = NO;
        self.hintLabel.hidden = YES;
    }
    return view;
}

- (CGPoint)getNewTagViewOriginForView: (YXShoppingListTagView *)View
{
    YXShoppingListTagView *lastView = [tagViewsArray lastObject];
    if (!lastView) {
        return CGPointZero;
    }
    else
    {
        if(lastView.frame.origin.x + lastView.frame.size.width + View.defaultWidth + 4 >= 250)
            return CGPointMake(0, lastView.frame.origin.y + lastView.frame.size.height + HFShoppingListHorizontalSpaceBetweenTagViews);
        else
            return CGPointMake(lastView.frame.origin.x + lastView.frame.size.width + 4, lastView.frame.origin.y);
    }
}

- (void)changeTagView:(YXShoppingListTagView *)view ToOrigin:(CGPoint)origin andWidth:(float)width andHeight:(float)height
{
    [UIView animateWithDuration:0.1 animations:^{
        view.frame = CGRectMake(origin.x, origin.y, width, height);
        [view layoutIfNeeded];
    }];
    
}

- (void)updateAllTagViewsBasedOnIndex:(int)index
{
    YXShoppingListTagView *baseView = [tagViewsArray objectAtIndex:index];

    if (heightChanged == 0) {
        //if no height change, that means only need to push the rest view to the right line
        for (int i = index + 1; i < [tagViewsArray count]; i++) {
            YXShoppingListTagView *view = [tagViewsArray objectAtIndex:i];
            [self changeOriginForTagView:view basedOnTagView:baseView];
            if (view.frame.origin.y == currentEditingTagView.frame.origin.y) {
                [self changeOriginForTagView:view basedOnTagView:baseView];
            }
            else
            {
                YXShoppingListTagView *previousView = [tagViewsArray objectAtIndex:i - 1];
                [self changeOriginForTagView:view basedOnTagView:previousView];
            }
        }
    }
    else
    {
        //if height changed is more than 0, that means all the rest views only need to change their y accordingly
        for (int i = index + 1; i < [tagViewsArray count]; i++) {
            YXShoppingListTagView *view = [tagViewsArray objectAtIndex:i];
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + heightChanged, view.frame.size.width, view.frame.size.height);
        }
    }
}

- (void)changeOriginForTagView:(YXShoppingListTagView *)view basedOnTagView:(YXShoppingListTagView *)baseView
{
    if (view.frame.origin.y == baseView.frame.origin.y &&
        view.frame.size.width <= HFShoppingListTagViewMaxWidth - baseView.frame.origin.x - baseView.frame.size.width - HFShoppingListHorizontalSpaceBetweenTagViews)
    {
        view.frame = CGRectMake(baseView.frame.origin.x + baseView.frame.size.width + HFShoppingListHorizontalSpaceBetweenTagViews, view.frame.origin.y , view.frame.size.width, view.frame.size.height);
    }
    else if (view.frame.origin.y == baseView.frame.origin.y &&
             view.frame.size.width > HFShoppingListTagViewMaxWidth - baseView.frame.origin.x - baseView.frame.size.width - HFShoppingListHorizontalSpaceBetweenTagViews)
    {
        view.frame = CGRectMake(0, baseView.frame.origin.y + baseView.frame.size.height+HFShoppingListHorizontalSpaceBetweenTagViews, view.frame.size.width, view.frame.size.height);
    }
}

- (void)changeNoteTextViewFrameBasedOnView: (YXShoppingListTagView *)view
{
    self.noteTextView.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height + HFShoppingListHorizontalSpaceBetweenTagViews + 5,
                                         self.tagsWrapperView.frame.size.width,
                                         self.tagsWrapperView.frame.size.height - view.frame.origin.y - view.frame.size.height - HFShoppingListHorizontalSpaceBetweenTagViews);
}

- (void)newImageAdded:(NSNotification *)notification
{
    selectImage = [notification object];
    self.photoImageView.image = selectImage;
    isPictureChanged = YES;
    hasImage = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HFFinishPickingPhotos object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HFFinishTakingPicture object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)newPictureTaken:(NSNotification *)notification
{
    selectImage = [notification object];
    self.photoImageView.image = selectImage;
    isPictureChanged = YES;
    hasImage = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HFFinishPickingPhotos object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HFFinishTakingPicture object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
