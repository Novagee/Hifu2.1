//
//  ItineraryServerApi.h
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItineraryServerApi : NSObject

//Itinerary
+ (void)getItineraryForUser:(NSString *)userId
                    success:(void (^)(id itineraries))successBlock
                    failure:(void (^)(NSError * error))failureBlock;

+ (void)deleteItineraryForId:(NSString *)itineraryId
                     success:(void (^)())successBlock
                     failure:(void (^)(NSError * error))failureBlock;

+ (void)saveItineraries:(NSArray *)itinerariesArray
             withUserId:(NSString *)userId
                success:(void (^)(NSArray *idArray))successBlock
                failure:(void (^)(NSError * error))failureBlock;

+ (void)getWeathersForZipcodes:(NSArray *)zipcodesArray
                       success:(void (^)(id weathers))successBlock
                       failure:(void (^)(NSError * error))failureBlocks;
@end
