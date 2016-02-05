//
//  THLHostEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserEntity.h"
@class THLBeacon;

@interface THLHostEntity : THLUserEntity
@property (nonatomic, strong) THLBeacon *beacon;
@end
