//
//  THLLocationEntity.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLLocationEntity.h"
#import <FormatterKit/TTTAddressFormatter.h>

@implementation THLLocationEntity
+ (TTTAddressFormatter *)sharedAddressFormatter {
    static TTTAddressFormatter *_sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [TTTAddressFormatter new];
    });
    
    return _sharedFormatter;
}

- (NSString *)fullAddress {
	return [[[self class] sharedAddressFormatter] stringFromAddressWithStreet:self.address locality:self.city region:self.stateCode postalCode:self.zipcode country:nil];
}
@end
