//
//  HFCustomPageControl.m
//  HiFu
//
//  Created by Yin Xu on 9/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFCustomPageControl.h"

@implementation HFCustomPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.activeImage = [UIImage imageNamed:@"pip_selected"] ;
    self.inactiveImage = [UIImage imageNamed:@"pip_not_selected"];
    
    return self;
    
}

-(id)initWithActiveImage: (UIImage *)acitveImage andInactiveImage: (UIImage *)inactiveImage andDotSize: (CGSize)size
{
    self = [super init];
    
    self.activeImage = acitveImage ;
    self.inactiveImage = inactiveImage;
    self.dotSize = size;
    
    return self;
}

-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        dot.image = i == self.currentPage ? [UIImage imageNamed:@"pip_selected"] : [UIImage imageNamed:@"pip_not_selected"];
    }
}

- (UIImageView *)imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            
            if (self.dotSize.height == 0) {
                dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10, 10)];
            }
            else
                dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.dotSize.width, self.dotSize.height)];
            
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}


@end
