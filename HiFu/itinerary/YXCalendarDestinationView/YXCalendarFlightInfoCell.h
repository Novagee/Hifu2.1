//
//  YXCalendarFlightInfoCell.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/16/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXCalendarFlightInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *flightImageView;
@property (nonatomic, weak) IBOutlet UITextField *tripTextField;

+ (float)heightForCell;
+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

@end
