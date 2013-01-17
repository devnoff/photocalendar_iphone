//
//  FoursquareAPI.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 14..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "FoursquareAPI.h"
#import "SBJson.h"


#define CLIENT_ID @"UILGT3CJCUZQYLP3LQRLZBW0GY3N4QKYKBIWWQA1GVKBFI0B"
#define CLIENT_SECRET @"YNTS1XBAZTKDUIIDPFR2X14DVTMOUGQ4LJMZRW0WSXTTXCOL"

#define HTTP_STATUS_CODE_BadRequest 400
#define HTTP_STATUS_CODE_Unauthorized 401


@implementation FoursquareAPI

@synthesize delegate=_delegate;

- (id)init {
    if ((self = [super init])) {
        _receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}


- (void)dealloc {
    if (_connection) {
        [_connection cancel];
        [_connection release];
    }
    
    [_receivedData release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark venues

- (void)search:(NSString*)query withLocation:(CLLocation *)location {
    NSString *url = @"https://api.foursquare.com/v2/venues/search";
    NSString *api = [NSString stringWithFormat:@"%@?ll=%f,%f&llAcc=500&radius=500&client_id=%@&client_secret=%@&v=20110926", url, location.coordinate.latitude, location.coordinate.longitude, CLIENT_ID, CLIENT_SECRET];
    if (nil != query || 0 < [query length]) {
        api = [api stringByAppendingFormat:@"&query=%@", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    //NSLog(@"API url: %@", api);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_receivedData setLength:0];
    
    if (_connection) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"didFailWithError: %@", [error description]);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_delegate foursquareAPIDidError:error];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    _statusCode = [httpResponse statusCode];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"didReceiveData");
    
    [_receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"connectionDidFinishLoading");
    
    if (HTTP_STATUS_CODE_BadRequest <= _statusCode) {
        [_delegate foursquareAPIDidFail:_statusCode];
    } else {
        [_delegate foursquareAPIDidFinish:_receivedData];
    }
}

@end
