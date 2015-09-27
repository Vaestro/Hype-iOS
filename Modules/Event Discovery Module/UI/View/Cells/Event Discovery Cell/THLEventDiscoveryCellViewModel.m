//
//  THLEventDiscoveryCellViewModel.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryCellViewModel.h"
#import "THLEventDiscoveryCellView.h"
#import "THLEventEntity.h"

@implementation THLEventDiscoveryCellViewModel
- (instancetype)initWithEvent:(THLEventEntity *)eventEntity {
	if (self = [super init]) {
		_eventEntity = eventEntity;
	}
	return self;
}

- (void)configureView:(id<THLEventDiscoveryCellView>)cellView {
	[cellView setLocationName:_eventEntity.location.name];
	[cellView setEventName:_eventEntity.title];
	[cellView setLocationNeighborhood:_eventEntity.location.neighborhood];
	[cellView setTime:_eventEntity.date.thl_timeString];
	[cellView setImageURL:_eventEntity.location.imageURL];
}

@end
