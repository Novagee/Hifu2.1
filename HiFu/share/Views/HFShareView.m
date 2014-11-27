//
//  HFShareView.m
//  HiFu
//
//  Created by Yin Xu on 8/25/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFShareView.h"
#import <pop/POP.h>


@implementation HFShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.buttonsArray = @[self.wechatMessageShareButton, self.wechatMomentShareButton, self.sinaWeiboShareButton, self.tencentWeiboShareButton, self.messageShareButton, self.emailShareButton];
    self.labesArray = @[self.wechatMomentShareLabel, self.wechatMomentShareLabel, self.sinaWeiboShareLabel, self.tencentWeiboShareLabel, self.messageShareLabel, self.emailShareLabel];
    for (UIButton *b in self.buttonsArray) {
        b.alpha = 0.0;
    }
    
    for (UILabel *l in self.labesArray) {
        l.alpha = 0.0;
    }
    
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
    [self addGestureRecognizer:tapToDismiss];
}

- (void)runShowAnimation
{
    for (int i = 0; i < [self.buttonsArray count]; i++) {
        UIButton *b = [self.buttonsArray objectAtIndex:i];
        POPBasicAnimation *buttonAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        buttonAlphaAnimation.fromValue = @(0.0);
        buttonAlphaAnimation.toValue = @(1);
        buttonAlphaAnimation.beginTime = CACurrentMediaTime() + 0.15 * i;
        [b pop_addAnimation:buttonAlphaAnimation forKey:@"POPButtonAlpha"];
        
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
        scaleAnimation.springBounciness = 20.0f;
        scaleAnimation.springSpeed = 6.0f;
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.15 * i;
        [b pop_addAnimation:scaleAnimation forKey:@"POPViewScale"];
        
        UILabel *l = [self.labesArray objectAtIndex:i];
        POPBasicAnimation *labelAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        labelAlphaAnimation.fromValue = @(0.0);
        labelAlphaAnimation.toValue = @(1);
        labelAlphaAnimation.beginTime = CACurrentMediaTime() + 0.15 * i;
        [l pop_addAnimation:labelAlphaAnimation forKey:@"POPLabelAlpha"];
    }
}

- (void)dismissShareView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissShareView)]) {
        [self.delegate dismissShareView];
    }
}

- (IBAction)messageShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedByMessage)]) {
        [self.delegate sharedByMessage];
    }
}

- (IBAction)emailShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedByEmail)]) {
        [self.delegate sharedByEmail];
    }
}

- (IBAction)sinaWeiboShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedBySinaWeibo)]) {
        [self.delegate sharedBySinaWeibo];
    }
}

- (IBAction)airDropShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedByAirDrop)]) {
        [self.delegate sharedByAirDrop];
    }
}

- (IBAction)wechatMessageShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedByWechatMessage)]) {
        [self.delegate sharedByWechatMessage];
    }
}

- (IBAction)wechatMomentShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedByWechatMoment)]) {
        [self.delegate sharedByWechatMoment];
    }
}

- (IBAction)qqShareButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedByQQ)]) {
        [self.delegate sharedByQQ];
    }
}



@end
