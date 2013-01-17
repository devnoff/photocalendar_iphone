//
//  MySHKConfigurator.m
//  photocalendar
//
//  Created by Yongnam Park on 13. 1. 3..
//  Copyright (c) 2013년 CultStory Inc. All rights reserved.
//

#import "MySHKConfigurator.h"

@implementation MySHKConfigurator


- (NSString*)facebookAppId {
	return @"217489064994975";
}


- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:false];
}

- (NSString*)twitterConsumerKey {
	return @"5f5XXrA0vlC9nwwoslmXA";
}

- (NSString*)twitterSecret {
	return @"bLFssaxCmQg6CwhFlF5rWpmGJOyDTmQG8OjnHtxkHec";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://cultstory.com/apps/photocal/";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"cultstory";
}

- (NSString*)flickrConsumerKey {
    return @"81f6f9e9b81ebb13a78d9297bad034f1";
}

- (NSString*)flickrSecretKey {
    return @"e4503544d8e7b503";
}
// The user defined callback url
- (NSString*)flickrCallbackUrl{
    return @"app://flickr";
}



- (NSNumber*)autoOrderFavoriteSharers {
    return [NSNumber numberWithBool:NO];
}

/* Name of the plist file that defines the class names of the sharers to use. Usually should not be changed, but this allows you to subclass a sharer and have the subclass be used. Also helps, if you want to exclude some sharers - you can create your own plist, and add it to your project. This way you do not need to change original SHKSharers.plist, which is a part of subproject - this allows you upgrade easily as you did not change ShareKit itself
 
 You can specify also your own bundle here, if needed. For example:
 return [[[NSBundle mainBundle] pathForResource:@"Vito" ofType:@"bundle"] stringByAppendingPathComponent:@"VKRSTestSharers.plist"]
 */
- (NSString*)sharersPlistName {
	return [[NSBundle mainBundle] pathForResource:@"Sharer" ofType:@"plist"];
}


// SHKActionSheet settings
- (NSNumber*)showActionSheetMoreButton {
	return [NSNumber numberWithBool:true];// Setting this to true will show More... button in SHKActionSheet, setting to false will leave the button out.
}

/*
 Favorite Sharers
 ----------------
 These values are used to define the default favorite sharers appearing on ShareKit's action sheet.
 */

- (NSArray*)defaultFavoriteImageSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook",@"SHKMail", @"SHKCopy", nil];
}


- (NSNumber*)maxFavCount {
	return [NSNumber numberWithInt:4];
}



@end
