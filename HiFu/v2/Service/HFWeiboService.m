//
//  HFWeiboService.m
//  HiFu
//
//  Created by Peng Wan on 9/24/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "HFWeiboService.h"
#import "HFThirdPartyApi.h"
#import "UserServerApi.h"
#import "UserObject.h"
#import "SVProgressHUD.h"

@implementation HFWeiboService

+ (HFWeiboService *)getInstance {
    static HFWeiboService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HFWeiboService alloc] init];
    });
    return _sharedInstance;
}

- (void) initWeiboLoginAuthorizeRequest
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WEIBO_APP_RedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"HFWeiboService",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void) doReceiveLoginResponse:(WBBaseResponse *)response
{
    WBAuthorizeResponse *weiboOAuth = (WBAuthorizeResponse *)response;
    if (weiboOAuth.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
        [SVProgressHUD dismiss];
        return;
    }
    [UserServerApi sharedInstance].currentUser.weiboOAuth = weiboOAuth;
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    AFHTTPSessionManager *urlSession = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
    [urlSession setRequestSerializer:[AFJSONRequestSerializer new]];
    if ([NSURLSession class]){
        [[NSNotificationCenter defaultCenter] postNotificationName:HFLOGINSHOWMASK object:nil userInfo:nil];
        if ([weiboOAuth userID] && [weiboOAuth accessToken]) {
            NSDictionary* params = @{
                                     @"access_token": [weiboOAuth accessToken],
                                     @"uid":[weiboOAuth userID]
                                     };
            [urlSession
             GET:url
             parameters:params
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSNumber *weiboVerified = [NSNumber numberWithBool:[responseObject[@"verified"] boolValue]];
                [HFThirdPartyApi
                    registerWeiboWithId:responseObject[@"id"]
                              weiboName:responseObject[@"name"]
                        weiboScreenName:responseObject[@"screen_name"]
                          weiboLocation:responseObject[@"location"]
                     weiboProfileImgUrl:responseObject[@"profile_image_url"]
                          weiboVerified:weiboVerified
                                success:^(id success) {
                                    NSLog(@"Registered weibo successfully.");
                                    
                                    if (success&&success[@"data"]&&success[@"data"][@"id"]) {
                                        
                                        //should save oath info
                                        UserObject *user = [[UserObject alloc]initWithDictionary:success[@"data"]];
                                        user.loginChannel = @"LOGIN_CHANNEL_WEIBO";
                                        user.displayName = success[@"data"][@"weiboName"];
                                        user.imageUrl = success[@"data"][@"weiboProfileImgUrl"];
                                        [[UserServerApi sharedInstance] setCurrentUser:user];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:HFLOGINHIDEMASKANDENTER object:nil userInfo:nil];
                                        NSLog(@"Saved To Sesion");
                                    }
                                }
                                failure:^(NSError *error) {
                                    NSLog(@"Registered weibo unsuccessfully.");
                                    [[NSNotificationCenter defaultCenter] postNotificationName:HFLOGINHIDEMASK object:nil userInfo:nil];
                                }];
             }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取用户信息结果"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 [alert show];
             }];
        }
    }

}

- (void)ssoOutButtonPressed
{
    [WeiboSDK logOutWithToken:[[UserServerApi sharedInstance].currentUser.weiboOAuth accessToken] delegate:self withTag:@"user1"];
}

- (void)inviteFriendButtonPressed
{
    NSString *title = @"请输入被邀请人的UID";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
    
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *jsonData = @"{\"text\": \"新浪新闻是新浪网官方出品的新闻客户端，用户可以第一时间获取新浪网提供的高品质的全球资讯新闻，随时随地享受专业的资讯服务，加入一起吧\",\"url\": \"http://app.sina.com.cn/appdetail.php?appID=84475\",\"invite_logo\":\"http://sinastorage.com/appimage/iconapk/1b/75/76a9bb371f7848d2a7270b1c6fcf751b.png\"}";
    
    [WeiboSDK inviteFriend:jsonData withUid:[[UserServerApi sharedInstance].currentUser.weiboOAuth userID] withToken:[[UserServerApi sharedInstance].currentUser.weiboOAuth accessToken] delegate:self withTag:@"invite1"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

//Share to weibo with different type: text/image/media
- (WBMessageObject *)buildWeiboMessage:(NSString *)messageType
{
    WBMessageObject *message = [WBMessageObject message];
    
    if ([messageType isEqualToString:@"text"])
    {
        message.text = @"测试通过WeiboSDK发送文字到微博!";
    }
    
    if ([messageType isEqualToString:@"image"])
    {
        WBImageObject *image = [WBImageObject object];
        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
        message.imageObject = image;
    }
    
    if ([messageType isEqualToString:@"media"])
    {
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = @"分享网页标题";
        webpage.description = [NSString stringWithFormat:@"分享网页内容简介-%.0f", [[NSDate date] timeIntervalSince1970]];
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
        webpage.webpageUrl = @"http://sina.cn?a=1";
        message.mediaObject = webpage;
    }
    
    return message;
}


- (void)shareMessage:(WBMessageObject *)message
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}


@end
