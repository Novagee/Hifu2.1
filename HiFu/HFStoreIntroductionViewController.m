//
//  HFStoreIntroductionViewController.m
//  HiFu
//
//  Created by Peng Wan on 11/8/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "HFStoreIntroductionViewController.h"
#import <AFNetworking/AFNetworking.h>

@implementation HFStoreIntroductionViewController

- (void)viewDidLoad {
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapped)];
    leftBarButton.tintColor = [UIColor colorWithRed:255/255 green:99/255.0f blue:104/255.0f alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"品牌介绍";
    
    self.detailIntroduction.text = self.detailText;
    
    NSURLRequest *logoRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.storeLogoURL]];
    [self fetchImageWithRequest:logoRequest finished:^(id responseObject) {
        self.storeLogo.image = [[UIImage alloc]initWithData:responseObject];
    }];
}

- (void)leftBarButtonTapped {
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)fetchImageWithRequest:(NSURLRequest *)request finished:(void(^)(id responseObject))success {
    
    // Fetch image
    //
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    httpRequestOperation.responseSerializer.acceptableContentTypes = nil;
    
    [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [httpRequestOperation start];
    
    
    
}

@end
