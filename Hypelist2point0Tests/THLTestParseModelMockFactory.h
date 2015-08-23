//
//  THLTestParseModelMockFactory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
//Parse Models
@class THLParseEvent;
@class THLParsePromotion;
@class THLParseUser;
@class THLParseLocation;

@interface THLTestParseModelMockFactory : NSObject
+ (NSArray *)mockParsePromotions:(NSInteger)count;
+ (NSArray *)mockParseHostUsers:(NSInteger)count;
+ (NSArray *)mockParseGuestUsers:(NSInteger)count;
+ (NSArray *)mockParseAdminUsers:(NSInteger)count;
+ (NSArray *)mockParseEvents:(NSInteger)count;
+ (NSArray *)mockParseLocations:(NSInteger)count;

- (THLParseEvent *)mockParseEvent;
- (THLParsePromotion *)mockParsePromotion;
- (THLParseUser *)mockParseGuestUser;
- (THLParseUser *)mockParseHostUser;
- (THLParseUser *)mockParseAdminUser;
- (THLParseLocation *)mockParseLocation;
@end
