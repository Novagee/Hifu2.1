//
//  GBImageCollectionItemCell.h
//  Gogobot-iOS
//
//  Created by Yin Xu on 11/12/13.
//  Copyright (c) 2013 Gogobot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXImageCollectionItemCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pictureImageView;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;
@property (nonatomic, assign) BOOL isImageSelected;
@property (nonatomic, strong) UIImage *originalImage;

- (void)checkImage;
+ (NSString *)reuseIdentifier;
+ (UINib *) cellNib;
@end
