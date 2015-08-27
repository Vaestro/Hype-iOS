//
//  THLEventDiscoveryCellViewModel.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryCellViewModel.h"
#import "THLEventDiscoveryCellView.h"
#import "THLEvent.h"

@interface THLEventDiscoveryCellViewModel()
@property (nonatomic, strong) THLEvent *event;
@end


@implementation THLEventDiscoveryCellViewModel
- (instancetype)initWithEvent:(THLEvent *)event {
	if (self = [super init]) {
		_event = event;
	}
	return self;
}

- (void)configureView:(id<THLEventDiscoveryCellView>)cellView {
	[cellView setLocationName:_event.location.name];
	[cellView setEventName:_event.title];
	[cellView setLocationNeighborhood:_event.location.neighborhood];
	[cellView setTime:_event.date.thl_timeString];
	[cellView setImageURL:_event.location.imageURL];
}

@end
