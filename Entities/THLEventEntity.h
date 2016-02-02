//
//  THLEventEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"

@class THLHostEntity;
@class THLLocationEntity;

@interface THLEventEntity : THLEntity
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *info;
@property (nonatomic) int creditsPayout;
@property (nonatomic, strong) THLLocationEntity *location;
@property (nonatomic) float maleCover;
@property (nonatomic) float femaleCover;
@property (nonatomic, strong) THLHostEntity *host;
@property (nonatomic) int maleRatio;
@property (nonatomic) int femaleRatio;
@property (nonatomic) bool requiresApproval;
@end
