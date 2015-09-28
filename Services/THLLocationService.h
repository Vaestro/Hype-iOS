//
//  THLLocationService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLocationServiceInterface.h"

@class CLGeocoder;
@interface THLLocationService : NSObject<THLLocationServiceInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) CLGeocoder *geocoder;
- (instancetype)initWithGeocoder:(CLGeocoder *)geocoder;
@end
