//
//  THLEvent.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
#import "THLLocation.h"

@interface THLEvent : THLEntity
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *promoImageURL;
@property (nonatomic, copy) NSString *promoInfo;
@property (nonatomic) float maleCover;
@property (nonatomic) float femaleCover;
@property (nonatomic, strong) THLLocation *location;
@end
