//
//  THLParseMapperTestsHelper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

//Parse Models
@class THLParseEvent;
@class THLParsePromotion;
@class THLParseUser;
@class THLParseLocation;

//Local Models
@class THLPromotion;
@class THLUser;
@class THLHost;
@class THLGuest;
@class THLEvent;
@class THLLocation;

@interface THLParseMapperTestsHelper : NSObject
- (THLParseEvent *)mockParseEvent;
- (THLParsePromotion *)mockParsePromotion;
- (THLParseUser *)mockParseGuestUser;
- (THLParseUser *)mockParseHostUser;
- (THLParseUser *)mockParseAdminUser;
- (THLParseLocation *)mockParseLocation;

- (THLPromotion *)mockLocalPromotion;
- (THLHost *)mockLocalHost;
- (THLGuest *)mockLocalGuest;
- (THLEvent *)mockLocalEvent;
- (THLLocation *)mockLocalLocation;

- (BOOL)verifyParseEvent:(THLParseEvent *)parseEvent equalToLocalEvent:(THLEvent *)localEvent;
- (BOOL)verifyParsePromotion:(THLParsePromotion *)parsePromotion equalToLocalPromotion:(THLPromotion *)localPromotion;
- (BOOL)verifyParseUser:(THLParseUser *)parseUser equalToLocalUser:(THLUser *)user;
- (BOOL)verifyParseLocation:(THLParseLocation *)parseLocation equalToLocalLocation:(THLLocation *)location;
@end
