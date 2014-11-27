//
//  YXAvatarCollectionCell.h
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXAvatarCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) UIImage *avatarImage;

+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;

@end
