//
//  DCNetworkReactor.h
//  DCNetworkReactor
//
//  Created by Peng Wan on 10/14/14.
//  Copyright (c) 2014 Peng Wan. All rights reserved.
//


@import UIKit;
@import Foundation;

@class AFHTTPRequestOperation;

@interface DCNetworkReactor : NSObject

typedef void (^responseBlock)(id responseObject);
typedef void (^errorBlock)(NSError *error);

/**
 @brief Send a POST request
 
 @param url An URL for the post request
 @param keyAndValues A dictionary store the parameters for the POST request
 @param responseBlock A block for receiving the POST result
 @param errorBlock A block for handle the error once the request failed
 
 @return A request that you can cancel it or restart it.
 @discussion You don't need to ensure the space character in the _key_ or _value_, whole the special character will be encoded. This request will start automatically
 */
- (AFHTTPRequestOperation *)responsePOSTRequestWithURL:(NSURL *)url withKeyAndValues:(NSDictionary *)keyAndValues finished:(responseBlock)responseBlock error:(errorBlock)errorBlock;

/**
 @brief Send a http request
 
 @param request A http request for fetch the data from the server
 @param responseBlock A block for receiving the data from the server
 @param errorBlock A block for handled the error once the request failed
 
 @return A request that you can cancel it or restart it.
 @discussion You should use encodeURL:withKeyAndValues: method to encode the URL first.
 */
- (AFHTTPRequestOperation *)responseHTTPRequest:(NSURLRequest *)request finished:(responseBlock)responseBlock error:(errorBlock)errorBlock;

/**
 @brief Encode a url which have a value with some special character.
 
 @param url A url which point to your server's address, this argument should not be nil.
 @param keyAndValues A dictionary to store you keys and values, all special character in this dictionary will be encoded.
 
 @return An NSURL with encoded arguments.
 @discussion You should invoke the method to encode your URL before you send a http request to your *Server*. You may send a invalid URL request if you ignore this.
 */
- (NSURL *)encodeURL:(NSURL *)url withKeyAndValues:(NSDictionary *)keyAndValues;

/**
 @brief Generate a path in the App's directory and store the response object into the path.
 
 @param encryptedURL An encoded URL, you can use encodeURL:withKeyAndValues: method to encode an URL.

 @discussion The existed file will generate a `No` result, use this in a right time.
 
 @return `YES` when the directory create and response object store success, otherwise `No`
 */
- (BOOL)generateDirectoryWithMD5:(NSURL *)encryptedURL;

/**
 @brief Encode a URL which has some special character through the *Regular Expression*. I suggest to use the encodeURL:withKeyAndValues: method instead.
 
 @param urlString An URL string that you wanna to encode.
 @discussion The advantage of this method is that you type an *url string*, then you get an *encoded url string*, you don't need to construct an NSDictionary to store the arguments in a URL request.
 @bug It may contain some unknown bug in this method.
 */
- (NSString *)encodeURLWithURLString:(NSString *)urlString;

@end
