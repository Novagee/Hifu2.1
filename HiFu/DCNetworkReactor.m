//
//  DCNetworkReactor.m
//  DCNetworkReactor
//
//  Created by Peng Wan on 10/14/14.
//  Copyright (c) 2014 Peng Wan. All rights reserved.
//

#import "DCNetworkReactor.h"

#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

@interface DCNetworkReactor ()

@property (strong, nonatomic) NSArray *userFileDirectoryPath;

@end

@implementation DCNetworkReactor

#pragma mark - Initialization

- (instancetype)init {
    
    if (self == [super init]) {
        _userFileDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    }
    return self;
    
}

#pragma mark - Request Method

- (AFHTTPRequestOperation *)responseHTTPRequest:(NSURLRequest *)request finished:(responseBlock)responseBlock error:(errorBlock)errorBlock{
    
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    httpRequestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpRequestOperation.responseSerializer.acceptableContentTypes = nil;
    
    [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        errorBlock(error);
        
    }];
    [httpRequestOperation start];
    
    return httpRequestOperation;
}

- (AFHTTPRequestOperation *)responsePOSTRequestWithURL:(NSURL *)url withKeyAndValues:(NSDictionary *)keyAndValues finished:(responseBlock)responseBlock error:(errorBlock)errorBlock {

    // Encode the keyAndValues
    //
    NSMutableDictionary *encodedKeyAndValues = [[NSMutableDictionary alloc]init];
    
    for (NSString *key in keyAndValues.allKeys) {
        
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedValue = [keyAndValues[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [encodedKeyAndValues setValue:encodedValue forKey:encodedKey];
    }
    
    // Use a operation manager to send a post request
    //
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *httpRequestOperation = [httpRequestOperationManager POST:url.absoluteString
                           parameters:encodedKeyAndValues
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  responseBlock(responseObject);
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  errorBlock(error);
                              
                              }];
    httpRequestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpRequestOperation.responseSerializer.acceptableContentTypes = nil;
    
    return httpRequestOperation;
}

#pragma mark - Encode Method

- (NSURL *)encodeURL:(NSURL *)url withKeyAndValues:(NSDictionary *)keyAndValues {
    
    // Convert the URL into string
    //
    NSString *urlString = url.absoluteString;

    
    for (NSString *key in keyAndValues.allKeys) {
        // Endcode the key
        //
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Encode the value
        //
        NSString *encodedValue = [keyAndValues[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Append the value to the key
        //
        NSString *encodedKeyAndValue = [encodedKey stringByAppendingFormat:@"=%@&", encodedValue];
        
        // Append the kayAndValue to the url
        //
        urlString = [urlString stringByAppendingString:encodedKeyAndValue];
    }
    
    // Remove the last charcter, aka "&"
    //
    NSRange lastCharacterRange = NSMakeRange(urlString.length - 1, 1);
    
    urlString = [urlString stringByReplacingCharactersInRange:lastCharacterRange withString:@""];
    
    return [NSURL URLWithString:urlString];
}

- (NSString *)encryptURLWithMD5:(NSURL *)url{
    
    NSString *urlString = url.absoluteString;
    
    // Convert to c string for encryption
    //
    const char *urlChar = [urlString UTF8String];
    unsigned char digest[16];
    CC_MD5( urlChar, (CC_LONG)strlen(urlChar), digest );
    
    // Add a mutable string for storing the encrypted string
    //
    NSMutableString *encryptedString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    // Encrypting ...
    //
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [encryptedString appendFormat:@"%02x", digest[i]];
    }
    
    return encryptedString;
    
}

#pragma mark - File Manager

- (BOOL)generateDirectoryWithMD5:(NSURL *)encryptedURL {
    
    NSString *encrytedURLString = [self encryptURLWithMD5:encryptedURL];
    
    // Devide the encrytedString into two part
    //
    NSRange pathStringRange = NSMakeRange(0, encrytedURLString.length/2);
    NSRange fileStringRange = NSMakeRange(encrytedURLString.length/2, encrytedURLString.length/2);
    
    NSString *pathString = [encrytedURLString substringWithRange:pathStringRange];
    NSString *fileString = [encrytedURLString substringWithRange:fileStringRange];
    
    // Fetch the document directory
    //
    NSString *documentDirectory = [_userFileDirectoryPath lastObject];
    
    // Generate file path
    //
    for (int i = 0; i < pathString.length; i += 2) {
        
        NSRange folderStringRange = NSMakeRange(i, 2);
        NSString *folderString = [pathString substringWithRange:folderStringRange];
        documentDirectory = [documentDirectory stringByAppendingPathComponent:folderString];
        
    }
    
    // Append file to the path
    //
    NSString *finalPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", fileString]];
    
    // Add to document when the file is not exist
    //
    if (! [[NSFileManager defaultManager]fileExistsAtPath:finalPath]) {
        
        NSError *error = nil;
        
        NSLog(@"File create success");
        
        return [[NSFileManager defaultManager]createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    NSLog(@"File exist : %@", finalPath);
    return NO;
}

#pragma Regular Expression Seacher and Replacement

- (NSString *)encodeURLWithURLString:(NSString *)urlString {
    
    return [self searchString:@"(?<=[\?&])[^&$]+" andReplaceWithString:@"Hah" inURLString:urlString];
    
}

- (NSString *)searchString:(NSString *)searchString andReplaceWithString:(NSString *)replacementString inURLString:(NSString *)urlString{
    
    NSError *error = nil;
    
    // Configure the regular expression
    //
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc]initWithPattern:searchString options:NSRegularExpressionCaseInsensitive error:&error];
    
    // Handle the error
    //
    if (error) {
        NSLog(@"%@", error.userInfo);
    }
    
    // Configure search condition
    //
    
    NSRange matchRange = NSMakeRange(0, urlString.length);
    
    // Searching ...
    //
    NSArray *matches = [regularExpression matchesInString:urlString options:NSMatchingReportCompletion range:matchRange];
    
    // Fetch result and replace the text
    //
    for (int i = (int)matches.count - 1; i >= 0; i--) {
        
        // Fetch the result range in a reverse order
        //
        NSTextCheckingResult *matchResult = [matches objectAtIndex:i];
        NSRange resultRange = matchResult.range;
        NSString *resultString = [urlString substringWithRange:resultRange];
        
        // Encode the result string, for example: 'key=val ue' with encode to 'key=val%20ue'
        //
        NSString *encodedResultString = [resultString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Configure the url string
        //
        urlString = [urlString stringByReplacingOccurrencesOfString:resultString withString:encodedResultString];
        
    }
    
    return urlString;
}

@end
