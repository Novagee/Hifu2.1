//
//  HFFavoriteBrandCell.m
//  HiFu
//
//  Created by Yin Xu on 7/15/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFFavoriteBrandCell.h"
#import <POP/POP.h>

@implementation HFFavoriteBrandCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)heightForCell
{
    return 50;
}

+ (NSString *)reuseIdentifier
{
    return @"HFFavoriteBrandCell";
}

+ (UINib *) cellNib
{
    return [UINib nibWithNibName:@"HFFavoriteBrandCell" bundle:nil];
}

- (IBAction)favoriteButtonClicked:(id)sender
{
    self.isFavorite = !self.isFavorite;
    [self runHeartAnimation];
    
    [self.favoriteButton setImage:self.isFavorite ? [UIImage imageNamed:@"heart_button_selected"] : [UIImage imageNamed:@"heart_button"]
                         forState:UIControlStateNormal];
    
    if (self.isFavorite && self.delegate && [self.delegate respondsToSelector:@selector(didFavoriteBrand:forCell:)])
    {
        [self.delegate didFavoriteBrand:self.merchant forCell:self];
    }
    else if (!self.isFavorite && self.delegate && [self.delegate respondsToSelector:@selector(didUnfavoriteBrand:forCell:)]) {
        [self.delegate didUnfavoriteBrand:self.merchant forCell:self];
    }
}

- (void)runHeartAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 6.0f;
    [self.favoriteButton pop_addAnimation:scaleAnimation forKey:@"POPViewScale"];
}

@end
