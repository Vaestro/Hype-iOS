//
//  THLParseMapper.h
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

/**
 *  Exposes an interface for mapping Parse models to local app models.
 */
@interface THLParseMapper : NSObject

#pragma mark - Mapping Parse -> Local
+ (THLEvent *)mapEvent:(THLParseEvent *)parseEvent;
+ (THLPromotion *)mapPromotion:(THLParsePromotion *)parsePromotion;
+ (THLUser *)mapUser:(THLParseUser *)parseUser;
+ (THLLocation *)mapLocation:(THLParseLocation *)parseLocation;

#pragma mark - Unmapping Local -> Parse
+ (THLParseEvent *)unmapEvent:(THLEvent *)localEvent;
+ (THLParsePromotion *)unmapPromotion:(THLPromotion *)localPromotion;
+ (THLParseUser *)unmapUser:(THLUser *)localUser;
+ (THLParseLocation *)unmapLocation:(THLLocation *)localLocation;
@end
