//
//  THLLocationService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLLocationService.h"
#import "LMGeocoder.h"
@import CoreLocation;

@implementation THLLocationService
- (instancetype)initWithGeocoder:(CLGeocoder *)geocoder {
	if (self = [super init]) {
		_geocoder = geocoder;
	}
	return self;
}

- (BFTask<CLPlacemark *> *)geocodeAddress:(NSString *)address {
	BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
	[_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
		if (error) {
			[completionSource setError:error];
		} else {
			[completionSource setResult:[placemarks first]];
		}
	}];
	return completionSource.task;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
