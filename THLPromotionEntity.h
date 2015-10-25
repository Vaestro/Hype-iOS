//
//  THLPromotionEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLHostEntity;
@class THLEventEntity;

@interface THLPromotionEntity : THLEntity
@property (nonatomic, strong) NSDate *time;
@property (nonatomic) int maleRatio;
@property (nonatomic) int femaleRatio;
@property (nonatomic, strong) THLHostEntity *host;
@property (nonatomic, strong) THLEventEntity *event;
@property (nonatomic, retain) NSString *eventId;
@end
