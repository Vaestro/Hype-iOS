//
//  THLChooseHostDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLParseEventService;
@class THLEvent;
@class BFTask;
@interface THLChooseHostDataManager : NSObject

@property (nonatomic, readonly) THLParseEventService *eventService;
- (instancetype)initWithEventService:(THLParseEventService *)eventService;

- (BFTask *)getPromotionsForEvent:(THLEvent *)event;
@end
