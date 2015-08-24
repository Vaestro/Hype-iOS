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
@class THLEvent;

@interface THLEventDiscoveryCellViewModel : NSObject
@property (nonatomic, readonly) THLEvent *event;

- (instancetype)initWithEvent:(THLEvent *)event;
- (void)configureView:(id<THLEventDiscoveryCellView>)view;
@end
