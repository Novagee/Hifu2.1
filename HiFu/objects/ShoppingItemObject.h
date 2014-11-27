//
//  ShoppingItemObject.h
//  HiFu
//
//  Created by Yin Xu on 6/29/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "BaseObject.h"

@interface ShoppingItemObject : BaseObject

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *priceInUSD;
@property (nonatomic, strong) NSString *forWhom;
@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSNumber *bought;

@end
