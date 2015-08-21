//
//  THLParseUser+ParseMapper.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseUser+ParseMapper.h"
#import "THLParseMapper.h"


@implementation THLParseUser (ParseMapper)
- (THLUser *)map {
	return [THLParseMapper mapUser:self];
}

+ (THLParseUser *)unmap:(THLUser *)user {
	return [THLParseMapper unmapUser:user];
}

@end
