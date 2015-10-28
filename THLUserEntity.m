//
//  THLUserEntity.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserEntity.h"

@implementation THLUserEntity


- (NSString *)fullName {
	return [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
