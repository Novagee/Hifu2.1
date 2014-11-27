//
//  HFShareHelpers.h
//  HiFu
//
//  Created by Yin Xu on 9/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "TencentRequest.h"

@interface HFShareHelpers : NSObject<QQApiInterfaceDelegate,TencentRequestDelegate>

/**
 *  Share Text and Image on Sina Weibo
 *
 *  @param viewController the view controller that's going to present the compose view
 *  @param shareText      share text
 *  @param shareImage     share image
 */
+ (void)sharedBySinaWeiboOnViewController:(UIViewController *)viewController
                            andSharedText:(NSString *)shareText
                              sharedImage:(UIImage *)shareImage;



/**
 *  Share Text and Image on QQ
 *
 *  @param shareTitle   title
 *  @param sharedBody   body
 *  @param shareImage   share image
 *  @param successBlock success call back
 *  @param failureBlock failure call back
 */
+ (void)sharedByQQOnViewController:(UIViewController *)viewController
                     andShareTitle:(NSString *)shareTitle
                         shareBody:(NSString *)shareBody
                       sharedImage:(UIImage *)shareImage
                           success:(void(^)())successBlock
                           failure:(void(^)())failureBlock;



#warning airdrop not finished yet
+ (void)sharedByAirDropOnViewController:(UIViewController *)viewController andSharedText:(NSString *)shareText andSharedImage:(UIImage *)shareImage;

/**
 *  Share On Wechat message or moment
 *
 *  @param isMoment     determine if that's a message share or moment share
 *  @param shareTitle   title
 *  @param sharedBody   body
 *  @param thumbImage   thumb image
 *  @param shareImage   share image
 *  @param successBlock success call back
 *  @param failureBlock failure call back
 */
+ (void)shareByWechat:(BOOL)isMoment
       andSharedTitle:(NSString *)shareTitle
           sharedBody:(NSString *)sharedBody
           thumbImage:(UIImage *)thumbImage
          sharedImage:(UIImage *)shareImage
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock;

/**
 *  share by Email
 *
 *  @param viewController  the view controller that's going to present the compose view
 *  @param delegate        view controller's delegate
 *  @param sharedSubject   email subject
 *  @param sharedBody      email body
 *  @param shareImage      shared image
 *  @param completionBlock completion block
 */
+ (void)shareByEmailOnViewController:(UIViewController *)viewController
                         andDelegate:(id)delegate
                       sharedSubject:(NSString *)sharedSubject
                          sharedBody:(NSString *)sharedBody
                         sharedImage:(UIImage *)shareImage
                   presentCompletion:(void(^)())completionBlock;

/**
 *  share by Message
 *
 *  @param viewController  the view controller that's going to present the compose view
 *  @param delegate        view controller's delegate
 *  @param sharedSubject   message subject
 *  @param sharedBody      message body
 *  @param shareImage      shared image
 *  @param completionBlock completion block
 */
+ (void)shareByMessageOnViewController:(UIViewController *)viewController
                           andDelegate:(id)delegate
                         sharedSubject:(NSString *)sharedSubject
                            sharedBody:(NSString *)sharedBody
                           sharedImage:(UIImage *)shareImage
                     presentCompletion:(void(^)())completionBlock;
@end
