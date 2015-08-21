//
//  THLParsePromotion+ParseMapper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParsePromotion.h"
@class THLPromotion;

@interface THLParsePromotion (ParseMapper)
- (THLPromotion *)map;
+ (instancetype)unmap:(THLPromotion *)promotion;
@end
