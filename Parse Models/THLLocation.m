//
//  THLLocation.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLocation.h"
#import <FormatterKit/TTTAddressFormatter.h>

@implementation THLLocation
@dynamic image;
@dynamic name;
@dynamic info;
@dynamic address;
@dynamic city;
@dynamic stateCode;
@dynamic zipcode;
@dynamic neighborhood;
@dynamic coordinate;
@dynamic musicTypes;
@dynamic attireRequirement;
@dynamic timeOpen;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Location";
}

- (NSString *)fullAddress {
    return [[[self class] sharedAddressFormatter] stringFromAddressWithStreet:self.address locality:self.city region:self.stateCode postalCode:self.zipcode country:nil];
}

+ (TTTAddressFormatter *)sharedAddressFormatter {
    static TTTAddressFormatter *_sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [TTTAddressFormatter new];
    });
    
    return _sharedFormatter;
}
@end
