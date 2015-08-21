//
//  THLParseLocation+ParseMapper.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseLocation+ParseMapper.h"
#import "THLParseMapper.h"

@implementation THLParseLocation (ParseMapper)
- (THLLocation *)map {
	return [THLParseMapper mapLocation:self];
}

+ (instancetype)unmap:(THLLocation *)location {
	return [THLParseMapper unmapLocation:location];
}

@end
