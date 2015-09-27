//
//  THLEventDiscoveryCellViewModel.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDiscoveryCellView.h"

@protocol THLEventDiscoveryCellView;
@class THLEventEntity;

@interface THLEventDiscoveryCellViewModel : NSObject
@property (nonatomic, readonly) THLEventEntity *eventEntity;

- (instancetype)initWithEvent:(THLEventEntity *)event;
- (void)configureView:(id<THLEventDiscoveryCellView>)view;
@end
