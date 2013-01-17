//
//  FoursquareAPI.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 14..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol FoursquareAPIDelegate <NSObject>

@required
- (void)foursquareAPIDidFinish:(NSMutableData *)data;
- (void)foursquareAPIDidFail:(NSInteger)statusCode;
- (void)foursquareAPIDidError:(NSError *)error;

@end



@interface FoursquareAPI : NSObject {
    id <FoursquareAPIDelegate> _delegate;
    
    NSURLConnection *_connection;
    
    NSInteger _statusCode;
    NSMutableData *_receivedData;
}


@property (nonatomic, assign) id <FoursquareAPIDelegate> delegate;


- (void)search:(NSString*)query withLocation:(CLLocation *)location;

@end
