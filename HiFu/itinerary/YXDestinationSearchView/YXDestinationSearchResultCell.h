//
//  YXDestinationSearchResultCell.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/15/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CityObject.h"

@interface YXDestinationSearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *destinationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationStateNameLabel;

@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) CityObject *city;

+ (float)heightForCell;
+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

- (void)highlightDestinationNameWithColor:(UIColor *)color;

@end
