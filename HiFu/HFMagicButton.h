//
//  HFMagicButton.h
//  HiFu
//
//  Created by Peng Wan on 10/12/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFMagicButtonDelegate <NSObject>

- (void)magicButtonTapped:(UIButton *)magicButton;

@end

@interface HFMagicButton : UIView

- (id)initWithImage:(UIImage *)image;

@property (weak, nonatomic) id<HFMagicButtonDelegate> delegate;

@end
