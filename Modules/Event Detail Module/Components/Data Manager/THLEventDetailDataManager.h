//
//  THLEventDetailDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@protocol THLLocationServiceInterface;

@interface THLEventDetailDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLLocationServiceInterface> locationService;
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService;

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address;
@end
