//
//  HFShareView.h
//  HiFu
//
//  Created by Yin Xu on 8/25/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFShareViewDelegate;
@interface HFShareView : UIView

@property (nonatomic, weak) IBOutlet UIView *shareWrapperView;
@property (nonatomic, weak) IBOutlet UIButton *messageShareButton;
@property (nonatomic, weak) IBOutlet UIButton *emailShareButton;
@property (nonatomic, weak) IBOutlet UIButton *sinaWeiboShareButton;
@property (nonatomic, weak) IBOutlet UIButton *tencentWeiboShareButton;
@property (nonatomic, weak) IBOutlet UIButton *wechatMessageShareButton;
@property (nonatomic, weak) IBOutlet UIButton *wechatMomentShareButton;

@property (nonatomic, weak) IBOutlet UILabel *messageShareLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailShareLabel;
@property (nonatomic, weak) IBOutlet UILabel *sinaWeiboShareLabel;
@property (nonatomic, weak) IBOutlet UILabel *tencentWeiboShareLabel;
@property (nonatomic, weak) IBOutlet UILabel *wechatMessageShareLabel;
@property (nonatomic, weak) IBOutlet UILabel *wechatMomentShareLabel;

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) NSArray *labesArray;

@property (nonatomic, assign) id<HFShareViewDelegate> delegate;

- (IBAction)messageShareButtonTapped:(id)sender;
- (IBAction)emailShareButtonTapped:(id)sender;
- (IBAction)sinaWeiboShareButtonTapped:(id)sender;
- (IBAction)airDropShareButtonTapped:(id)sender;
- (IBAction)wechatMessageShareButtonTapped:(id)sender;
- (IBAction)wechatMomentShareButtonTapped:(id)sender;

- (void)runShowAnimation;

@end

@protocol HFShareViewDelegate <NSObject>

- (void)sharedByMessage;
- (void)sharedByEmail;
- (void)sharedBySinaWeibo;
- (void)sharedByAirDrop;
- (void)sharedByWechatMessage;
- (void)sharedByWechatMoment;
- (void)dismissShareView;

@end
