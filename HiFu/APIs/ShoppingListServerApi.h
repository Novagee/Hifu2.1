//
//  ShoppingListServerApi.h
//  HiFu
//
//  Created by Yin Xu on 6/29/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListServerApi : NSObject

+ (void)getShoppingListForUser:(NSString *)userId
                      isBought:(NSNumber *)isBought
                       success:(void (^)(id shoppingItems))successBlock
                       failure:(void (^)(NSError * error))failureBlock;

+ (void)saveShoppingListItemWithParams:(NSDictionary *)params
                              andImage:(UIImage *)image
                               success:(void (^)(id shoppingItems))successBlock
                               failure:(void (^)(NSError * error))failureBlock;

+ (void)deleteShoppingListItemWithId:(NSString *)itemId
                             success:(void (^)())successBlock
                             failure:(void (^)(NSError * error))failureBlock;

+ (void)updateShoppingListItemWithParams:(NSMutableDictionary *)params
                          didImageChange:(BOOL)isImageChanged
                                andImage:(UIImage *)image
                                 success:(void (^)())successBlock
                                 failure:(void (^)(NSError * error))failureBlock;
@end
