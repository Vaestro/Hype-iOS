//
//  THLParsePromotion+ParseMapper.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParsePromotion+ParseMapper.h"
#import "THLParseMapper.h"

@implementation THLParsePromotion (ParseMapper)
- (THLPromotion *)map {
	return [THLParseMapper mapPromotion:self];
}

+ (instancetype)unmap:(THLPromotion *)promotion {
	return [THLParseMapper unmapPromotion:promotion];
}

@end
