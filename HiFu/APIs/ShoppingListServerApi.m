//
//  ShoppingListServerApis.m
//  HiFu
//
//  Created by Yin Xu on 6/29/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "ShoppingListServerApi.h"
#import "HFBaseApi.h"
#import "ShoppingItemObject.h"

@implementation ShoppingListServerApi

+ (void)getShoppingListForUser:(NSString *)userId
                      isBought:(NSNumber *)isBought
                       success:(void (^)(id shoppingItems))successBlock
                       failure:(void (^)(NSError * error))failureBlock
{
    //isBought 用NSNumber的原因是因为可能是1可能是0，也可能是不要加，不要加的情况为-1
    NSString *path;
    if ([isBought integerValue] == -1)
         path = [NSString stringWithFormat:@"%@/shopping/item/%@", HF_API_PATH_OLD, userId];
    else
        path = [NSString stringWithFormat:@"%@/shopping/item/%@/%@", HF_API_PATH_OLD, isBought ? @"bought" : @"notbought", userId];
    
    [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                         parameters:nil
                                            success:^(id responseObject) {
                                                successBlock(responseObject);
                                            } failure:^(NSError *error) {
                                                failureBlock(nil);
                                            }];
}

+ (void)saveShoppingListItemWithParams:(NSDictionary *)params
                              andImage:(UIImage *)image
                               success:(void (^)(id shoppingItems))successBlock
                               failure:(void (^)(NSError * error))failureBlock
{
    NSString *postPath = [NSString stringWithFormat:@"%@/shopping/item", HF_API_PATH_OLD];
    CGSize originalSize = image.size;
    CGSize newSize = CGSizeMake(originalSize.width * 0.3, originalSize.height * 0.3);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData;
    float compressRate = 1.0;
    if (compressedImage) {
        imageData = UIImageJPEGRepresentation(compressedImage, compressRate);
        while (imageData.length/1024.0f > 120) {
            compressRate = compressRate - 0.15;
            imageData = UIImageJPEGRepresentation(compressedImage, compressRate);
        }
    }
    
    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:postPath
                                       withImageData:imageData ? imageData : nil
                                          parameters:params
                                             success:^(id responseObject) {
                                                 successBlock(responseObject);
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];
}

+ (void)deleteShoppingListItemWithId:(NSString *)itemId
                             success:(void (^)())successBlock
                             failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/shopping/item/%@", HF_API_PATH_OLD, itemId];
    [[HFBaseApi sharedInstance] HFRequestDELETEWithURL:path
                                            parameters:nil
                                               success:^(id responseObject) {
                                                   successBlock();
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];
}

+ (void)updateShoppingListItemWithParams:(NSMutableDictionary *)params
                          didImageChange:(BOOL)isImageChanged
                                andImage:(UIImage *)image
                                 success:(void (^)())successBlock
                                 failure:(void (^)(NSError * error))failureBlock
{
    NSString *postPath = [NSString stringWithFormat:@"%@/shopping/item", HF_API_PATH_OLD];
    
    if (isImageChanged && !image) {
        [params setObject:@"" forKey:@"pictureUrl"];
    }
    
    CGSize originalSize = image.size;
    CGSize newSize = CGSizeMake(originalSize.width * 0.3, originalSize.height * 0.3);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData;
    float compressRate = 1.0;
    if (compressedImage) {
        imageData = UIImageJPEGRepresentation(compressedImage, compressRate);
        while (imageData.length/1024.0f > 120) {
            compressRate = compressRate - 0.15;
            imageData = UIImageJPEGRepresentation(compressedImage, compressRate);
        }
    }

    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:postPath
                                       withImageData:imageData ? imageData : nil
                                          parameters:params
                                             success:^(id responseObject) {
                                                 successBlock(responseObject);
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];
}

@end
