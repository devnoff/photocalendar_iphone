//
//  API.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 8. 29..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API_CONST.h"

typedef void(^CSAsyncRequestSuccessBlock)(NSDictionary*);
typedef void(^CSAsyncRequestFailureBlock)(NSError*);


@interface CSAsyncRequest : NSObject {
@private
    
    NSURLConnection *_connection;
    
    NSInteger _statusCode;
    NSMutableData *_bodyData;
    NSMutableData *_receivedData;
    
    CSAsyncRequestSuccessBlock _successBlock;
    CSAsyncRequestFailureBlock _failureBlock;
    
    NSMutableDictionary *_headers;
    NSString *_requestUrl;
}

@property (nonatomic,strong) NSString *requestURL;

- (void)appendHeaderKey:(NSString*)key
                  value:(NSString*)value;

- (void)appendBody:(NSString *)data
         fieldName:(NSString *)fieldName;

- (void)appendFile:(NSData *)data
         fieldName:(NSString *)fieldName
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType;


- (void)delete:(NSString *)uri;

- (void)post:(NSString*)uri
successBlock:(CSAsyncRequestSuccessBlock)successBlock
 failureBock:(CSAsyncRequestFailureBlock)failureBlock;

- (void)get:(NSString*)uri
successBlock:(CSAsyncRequestSuccessBlock)successBlock
failureBock:(CSAsyncRequestFailureBlock)failureBlock;

- (void)jsonPost:(NSString*)uri
      jsonString:(NSString*)json
    successBlock:(CSAsyncRequestSuccessBlock)successBlock
     failureBock:(CSAsyncRequestFailureBlock)failureBlock;

@end




// http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
typedef enum {
    HTTP_STATUS_CODE_BAD_REQUEST = 400,
    HTTP_STATUS_CODE_NOT_FOUND = 404,
    
    HTTP_STATUS_CODE_SERVICE_UNAVAILABLE = 503,
    HTTP_STATUS_CODE_NERWORK_CONNECTION_TIMEOUT = 599
} HTTP_STATUS_CODE;