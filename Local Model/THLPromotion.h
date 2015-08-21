//
//  THLPromotion.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLEvent;
@class THLHost;

@interface THLPromotion : THLEntity
@property (nonatomic, strong) NSDate *time;
@property (nonatomic) int maleRatio;
@property (nonatomic) int femaleRatio;
@property (nonatomic, strong) THLEvent *event;
@property (nonatomic, strong) THLHost *host;
@end
