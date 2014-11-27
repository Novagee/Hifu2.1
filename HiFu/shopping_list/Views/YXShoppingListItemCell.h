//
//  YXShoppingListItemCell.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/21/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

#import "ShoppingItemObject.h"

@interface YXShoppingListItemCell : SWTableViewCell

@property (nonatomic, weak) IBOutlet UIView *innerView;
@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, strong) ShoppingItemObject *shoppingItem;

+ (float)heightForCell;
+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

@end
