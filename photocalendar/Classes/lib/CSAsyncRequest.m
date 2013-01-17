//
//  API.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 8. 29..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CSAsyncRequest.h"
#import "SBJson.h"
#import "NSDictionaryAdditions.h"
#import "Reachability.h"


#define HTTP_GET @"GET"
#define HTTP_POST @"POST"
#define HTTP_DELETE @"DELETE"

#define kMultiPartBoundary @"----------zaq1xsw2cde3vfr4bgt5nhy6mj7----------"

// TODO api key



@interface CSAsyncRequest()

- (void)execute:(NSMutableURLRequest *)request;

@end



@implementation CSAsyncRequest
@synthesize requestURL = _requestUrl;

- (id)init {
    if ((self = [super init])) {
        
        _bodyData = [[NSMutableData alloc] init];
        _receivedData = [[NSMutableData alloc] init];
        _headers = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}



- (void)dealloc {

    if (_connection) {
        [_connection cancel];
        [_connection release];
    }
    
    [_bodyData release];
    [_receivedData release];
    	 
    if (_successBlock){
        Block_release(_successBlock);
    }
    if (_failureBlock){
        Block_release(_failureBlock);
    }
    
    self.requestURL = nil;
    
    [super dealloc];
}

- (void)appendHeaderKey:(NSString*)key value:(NSString*)value{
    [_headers setObject:value forKey:key];
}


#pragma mark -
#pragma mark API 인자

- (void)appendBody:(NSString *)data fieldName:(NSString *)fieldName {
    if (!data) return;
    
    [_bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kMultiPartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [_bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", fieldName] dataUsingEncoding:NSUTF8StringEncoding]];
    [_bodyData appendData:[@"Content-Type: application/text\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [_bodyData appendData:[[NSString stringWithFormat:@"%@", data] dataUsingEncoding:NSUTF8StringEncoding]];
}


- (void)appendFile:(NSData *)data fieldName:(NSString *)fieldName fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    if (!data) return;
    
    
    if (nil == mimeType) {
        mimeType = @"application/octet-stream";
    }
    [_bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kMultiPartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [_bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [_bodyData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
    [_bodyData appendData:data];
    [_bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kMultiPartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
}


#pragma mark - Asynchronous RESTful method

- (BOOL)connectedToNetwork {
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (NotReachable == networkStatus) {
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Network connect timeout error", @"message", nil];
        NSError *error = [NSError errorWithDomain:self.requestURL code:HTTP_STATUS_CODE_NERWORK_CONNECTION_TIMEOUT userInfo:errorInfo];
        
        [self executeFailureBlockWithError:error];
        
        return NO;
    }
    
    return YES;
}


- (void)get:(NSString *)uri {
    if (![self connectedToNetwork]) {
        // TODO: 인터넷 연결 에러 알림
        return;
    }
    
    NSString *api = uri;
    //NSLog(@"API url: %@", api);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:60];
    
    [request setHTTPMethod:HTTP_GET];
    
    [self execute:request];
}


- (void)post:(NSString *)uri {
    if (![self connectedToNetwork]) {
        // TODO: 인터넷 연결 에러 알림
        return;
    }
    
    NSString *api = uri;
    //NSLog(@"API url: %@", api);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:60];
    
    [request setHTTPMethod:HTTP_POST];
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kMultiPartBoundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:_bodyData];
    
    [self execute:request];
}




- (void)post:(NSString*)uri successBlock:(CSAsyncRequestSuccessBlock)successBlock failureBock:(CSAsyncRequestFailureBlock)failureBlock{
    _successBlock = Block_copy(successBlock);
    _failureBlock = Block_copy(failureBlock);
    
    self.requestURL = uri;
    
    [self post:uri];
}

- (void)get:(NSString*)uri successBlock:(CSAsyncRequestSuccessBlock)successBlock failureBock:(CSAsyncRequestFailureBlock)failureBlock{
    _successBlock = Block_copy(successBlock);
    _failureBlock = Block_copy(failureBlock);
    
    self.requestURL = uri;
    
    [self get:uri];
}

- (void)jsonPost:(NSString*)uri jsonString:(NSString*)json successBlock:(CSAsyncRequestSuccessBlock)successBlock failureBock:(CSAsyncRequestFailureBlock)failureBlock{
    _successBlock = Block_copy(successBlock);
    _failureBlock = Block_copy(failureBlock);
    
    self.requestURL = uri;
    
    [self postJson:json withUri:uri];
}

- (void)postJson:(NSString*)json withUri:(NSString*)uri{

    
    
    NSString *jsonRequest = json;
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:uri];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"form-data" forHTTPHeaderField:@"Content-Disposition"];
    [request setValue:@"name" forHTTPHeaderField:@"json"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    

    [self execute:request];
}


- (void)delete:(NSString *)uri {
    if (![self connectedToNetwork]) {
        // TODO: 인터넷 연결 에러 알림
        return;
    }
    
    NSString *api = uri;
    //NSLog(@"API url: %@", api);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:60];
    
    [request setHTTPMethod:HTTP_DELETE];
    
    [self execute:request];
}


#pragma mark RESTful method execute

- (void)execute:(NSMutableURLRequest *)request {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_receivedData setLength:0];
    
//    [request addValue:APIKEY forHTTPHeaderField:@"X-API-KEY"];
    NSArray *keys = [_headers allKeys];
    for (NSString *key in keys){
        [request addValue:[_headers objectForKey:keys] forHTTPHeaderField:key];
    }
    
    if (_connection) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


#pragma mark execute block


- (void)executeSuccessBlockWithResult:(NSDictionary*)result{
    _successBlock(result);
}

- (void)executeFailureBlockWithError:(NSError*)error{
    _failureBlock(error);
}


#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", [error description]);
    
    [_bodyData setLength:0];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self executeFailureBlockWithError:error];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    
    [_bodyData setLength:0];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    _statusCode = [httpResponse statusCode];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    
    [_receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *result = [[[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"connectionDidFinishLoading: %@", result);
    // 에러 처리
    id result_ = [result JSONValue];
    if (result_) {
        if (HTTP_STATUS_CODE_BAD_REQUEST <= _statusCode) {
            int errorCode = [result_ integerForKey:kAPI_ERROR_CODE];
            if (0 == errorCode) {
                errorCode = _statusCode;
            }
            NSString *message = [result_ objectForKey:kAPI_ERROR_MESSAGE];
            if (nil == message) {
                message = @"Unknown Error";
            }    
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
            NSError *error = [NSError errorWithDomain:self.requestURL code:errorCode userInfo:errorInfo];
            
            
            if (_failureBlock){
                [self performSelector:@selector(executeFailureBlockWithError:) withObject:error];
            }
            
        } else {
            
            if (_successBlock){
                [self performSelector:@selector(executeSuccessBlockWithResult:) withObject:result_];
            }
        }
    } else {
        NSString *message = @"Unknown Error";
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
        NSError *error = [NSError errorWithDomain:self.requestURL code:HTTP_STATUS_CODE_SERVICE_UNAVAILABLE userInfo:errorInfo];
        
        if (_failureBlock){
            [self performSelector:@selector(executeFailureBlockWithError:) withObject:error];
        }
    }
}

@end
