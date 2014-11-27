//
//  HFGeneralCellProtocol.h
//  HiFu
//
//  Created by Yin Xu on 7/15/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HFGeneralCellProtocol <NSObject>

@optional

+ (float) heightForCell;
+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

@end
