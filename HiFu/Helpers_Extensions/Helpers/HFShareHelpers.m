//
//  HFShareHelpers.m
//  HiFu
//
//  Created by Yin Xu on 9/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFShareHelpers.h"
#import "Social/Social.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <MessageUI/MessageUI.h>
#import "HFTencentService.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <objc/runtime.h>
#import "UserServerApi.h"
#import "UserObject.h"

@implementation HFShareHelpers

+ (void)sharedBySinaWeiboOnViewController:(UIViewController *)viewController
                            andSharedText:(NSString *)shareText
                              sharedImage:(UIImage *)shareImage
{
    SLComposeViewController *weiboCompose=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [weiboCompose dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                    NSLog(@"sharedBySinaWeibo Cancelled.....");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"sharedBySinaWeibo Posted....");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:[NSString stringWithFormat:@"已成功分享到新浪微博"]
                                                                   delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
                    [alert show];
                    break;
            }
        };
        
        [weiboCompose addImage:shareImage];
        [weiboCompose setInitialText:shareText];
        [weiboCompose addURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id882865513"]];
        [weiboCompose setCompletionHandler:completionHandler];
        [viewController presentViewController:weiboCompose animated:YES completion:nil];
    }
    else
    {
        WBMessageObject *message = [WBMessageObject message];
        message.text = shareText;
        WBImageObject *image = [[WBImageObject alloc] init];
        image.imageData = UIImageJPEGRepresentation(shareImage, 1);
        message.imageObject = image;
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }
}



+ (void)sharedByAirDropOnViewController:(UIViewController *)viewController andSharedText:(NSString *)shareText andSharedImage:(UIImage *)shareImage
{
    NSArray *objectsToShare = @[shareImage];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    [viewController presentViewController:controller animated:YES completion:nil];
}

+ (void)sharedByQQOnViewController:(UIViewController *)viewController
                     andShareTitle:(NSString *)shareTitle
                         shareBody:(NSString *)shareBody
                       sharedImage:(UIImage *)shareImage
                           success:(void(^)())successBlock
                           failure:(void(^)())failureBlock
{
    if(![UserServerApi sharedInstance].currentUser.tencentOAuth){
        [[HFTencentService getInstance] initTencent];
        [[UserServerApi sharedInstance].currentUser.tencentOAuth authorize:[UserServerApi sharedInstance].currentUser.tencentPermissions inSafari:NO];
    }
    if (nil == shareTitle
        || 0 == [shareTitle length])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"标题不能为空"]
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    } else {
        NSData *imgData = UIImageJPEGRepresentation(shareImage, 1);
        NSData *previewImgData = UIImageJPEGRepresentation(shareImage, 0.2);
        
        if ([imgData length] > 5 * 1024 * 1024) {
            NSLog(@"image Size beyond 5M");
            float ratio = floorf( [imgData length] / (5 * 1024 * 1024) );
            imgData = UIImageJPEGRepresentation(shareImage, ratio);
            previewImgData = UIImageJPEGRepresentation(shareImage, ratio * 0.2);
        }
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                                   previewImageData:previewImgData
                                                              title:shareTitle ? : @""
                                                        description:shareBody ? : @""];
        UINavigationController *navCtrl = [viewController navigationController];
        NSMutableDictionary *context = objc_getAssociatedObject(navCtrl, objc_unretainedPointer(@"currentNavContext"));
        if (nil == context)
        {
            context = [NSMutableDictionary dictionaryWithCapacity:3];
            objc_setAssociatedObject(navCtrl, objc_unretainedPointer(@"currentNavContext"), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        __block uint64_t cflag = 0;
        [context enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSNumber class]] &&
                [key isKindOfClass:[NSString class]] &&
                [key hasPrefix:@"kQQAPICtrlFlag"])
            {
                cflag |= [obj unsignedIntValue];
            }
        }];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if (sent == EQQAPISENDSUCESS)
        {
            if (successBlock)
                successBlock();
        } else {
            if (failureBlock)
                failureBlock();
        }
    }
}

+ (void)shareByWechat:(BOOL) isMoment
       andSharedTitle:(NSString *)shareTitle
           sharedBody:(NSString *)sharedBody
           thumbImage:(UIImage *)thumbImage
          sharedImage:(UIImage *)shareImage
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    //if the Weixin app is not installed, show alert
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"无法找到微信App,请检查是否安装微信" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    req.message = WXMediaMessage.message;
    req.message.title = shareTitle;
    req.message.description = sharedBody;
    
    WXImageObject *imageObject = WXImageObject.object;
    [req.message setThumbImage:thumbImage];
    imageObject.imageData = UIImageJPEGRepresentation(shareImage, 1);
    req.message.mediaObject = imageObject;
    req.scene = isMoment ? WXSceneTimeline : WXSceneSession;
    
    if ([WXApi sendReq:req])
    {
        if (successBlock)
            successBlock();
    }
    else
    {
        if (failureBlock)
            failureBlock();
    }
}

+ (void)shareByEmailOnViewController:(UIViewController *)viewController
                         andDelegate:(id)delegate
                       sharedSubject:(NSString *)sharedSubject
                          sharedBody:(NSString *)sharedBody
                         sharedImage:(UIImage *)shareImage
                   presentCompletion:(void(^)())completionBlock
{
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    mailComposeVC.mailComposeDelegate = delegate;
    [mailComposeVC setSubject:sharedSubject];
    [mailComposeVC setMessageBody:sharedBody isHTML:NO];
    NSData *couponData = UIImageJPEGRepresentation(shareImage, 1);
    [mailComposeVC addAttachmentData:couponData mimeType:@"image/jpg" fileName:@"hifu_coupon.jpg"];
    [viewController presentViewController:mailComposeVC animated:YES completion:^{
        if (completionBlock)
            completionBlock();
    }];
}

+ (void)shareByMessageOnViewController:(UIViewController *)viewController
                           andDelegate:(id)delegate
                         sharedSubject:(NSString *)sharedSubject
                            sharedBody:(NSString *)sharedBody
                           sharedImage:(UIImage *)shareImage
                     presentCompletion:(void(^)())completionBlock
{
    MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
    messageComposeVC.messageComposeDelegate =delegate;
    [messageComposeVC setSubject:sharedSubject];
    [messageComposeVC setBody:sharedBody];
    NSData *couponData = UIImageJPEGRepresentation(shareImage, 1);
    [messageComposeVC addAttachmentData:couponData typeIdentifier:@"image/jpg" filename:@"hifu_coupon.jpg"];
    [viewController presentViewController:messageComposeVC animated:YES completion:^{
        if (completionBlock)
            completionBlock();
    }];
}

#pragma mark - TencentRequestDelegate
- (void)request:(TencentRequest *)request didFailWithError:(NSError *)error
{
}

- (void)request:(TencentRequest *)request didLoad:(id)result dat:(NSData *)data
{
}


#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req
{
}


- (void)onResp:(QQBaseResp *)resp
{
}


- (void)isOnlineResponse:(NSDictionary *)response
{
}

@end
