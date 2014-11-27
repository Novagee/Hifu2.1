//
//  ItineraryServerApi.m
//  HiFu
//
//  Created by Yin Xu on 6/28/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "ItineraryServerApi.h"
#import "itineraryObject.h"
#import "HFBaseApi.h"

@implementation ItineraryServerApi


//Itinerary
+ (void)getItineraryForUser:(NSString *)userId
                    success:(void (^)(id itineraries))successBlock
                    failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/trip/destinations/%@", HF_API_PATH, userId];
    
    [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                         parameters:nil
                                            success:^(id responseObject) {
                                                successBlock(responseObject);
                                            } failure:^(NSError *error) {
                                                failureBlock(error);
                                            }];
}

+ (void)deleteItineraryForId:(NSString *)itinerayId
                     success:(void (^)())successBlock
                     failure:(void (^)(NSError * error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/trip/destination/%@", HF_API_PATH, itinerayId];
    [[HFBaseApi sharedInstance] HFRequestDELETEWithURL:path
                                            parameters:nil
                                               success:^(id responseObject) {
                                                   successBlock();
                                               } failure:^(NSError *error) {
                                                   failureBlock(error);
                                               }];
}

+ (void)saveItineraries:(NSArray *)itinerariesArray
             withUserId:(NSString *)userId
                success:(void (^)(NSArray *idArray))successBlock
                failure:(void (^)(NSError * error))failureBlock
{
    
    NSMutableArray *parameters = [NSMutableArray new];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];

    for (ItineraryObject *it in itinerariesArray) {
        NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"userId" : userId,
                                                                                         @"cityId" : it.cityId,
                                                                                         @"startDate" : [df stringFromDate:it.startDate],
                                                                                         @"endDate" : [df stringFromDate:it.endDate]}];
        
        if (it.itemId && ![it.itemId isEqualToString:@""]) {
            [parameter setObject:it.itemId forKey:@"id"];
        }
        
        [parameters addObject:parameter];
    }
    NSString *postPath = [NSString stringWithFormat:@"%@/trip/destinations", HF_API_PATH];
    
    [[HFBaseApi sharedInstance] HFRequestPOSTWithURL:postPath
                                          parameters:parameters
                                             success:^(id responseObject) {
                                                 successBlock([responseObject objectForKey:@"message"]);
                                             } failure:^(NSError *error) {
                                                 failureBlock(error);
                                             }];
}

+ (void)getWeathersForZipcodes:(NSArray *)zipcodesArray
                       success:(void (^)(id weathers))successBlock
                       failure:(void (^)(NSError * error))failureBlock
{
    NSString *zipcodes = @"";
    for (NSString *z in zipcodesArray) {
        zipcodes = [zipcodes isEqualToString:@""] ? z : [NSString stringWithFormat:@"%@,%@",zipcodes,z];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/weather/patch/?zipcodes=%@", HF_API_PATH, zipcodes];
    [[HFBaseApi sharedInstance] HFRequestGETWithURL:path
                                         parameters:nil
                                            success:^(id responseObject) {
                                                successBlock(responseObject);
                                            } failure:^(NSError *error) {
                                                failureBlock(error);
                                            }];
}

@end
