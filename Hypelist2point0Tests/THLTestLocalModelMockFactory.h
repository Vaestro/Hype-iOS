//
//  THLTestLocalModelMockFactory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

//Local Models
@class THLPromotion;
@class THLUser;
@class THLHost;
@class THLGuest;
@class THLEvent;
@class THLLocation;

@interface THLTestLocalModelMockFactory : NSObject
+ (NSArray *)mockLocalPromotions:(NSInteger)count;
+ (NSArray *)mockLocalHosts:(NSInteger)count;
+ (NSArray *)mockLocalGuests:(NSInteger)count;
+ (NSArray *)mockLocalEvents:(NSInteger)count;
+ (NSArray *)mockLocalLocations:(NSInteger)count;

- (THLPromotion *)mockLocalPromotion;
- (THLHost *)mockLocalHost;
- (THLGuest *)mockLocalGuest;
- (THLEvent *)mockLocalEvent;
- (THLLocation *)mockLocalLocation;
@end
