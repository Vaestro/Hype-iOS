//
//  THLParseMapperTestsHelper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLTestLocalModelMockFactory.h"
#import "THLTestParseModelMockFactory.h"

@interface THLParseMapperTestsHelper : NSObject
- (BOOL)verifyParseEvent:(THLParseEvent *)parseEvent equalToLocalEvent:(THLEvent *)localEvent;
- (BOOL)verifyParsePromotion:(THLParsePromotion *)parsePromotion equalToLocalPromotion:(THLPromotion *)localPromotion;
- (BOOL)verifyParseUser:(THLParseUser *)parseUser equalToLocalUser:(THLUser *)user;
- (BOOL)verifyParseLocation:(THLParseLocation *)parseLocation equalToLocalLocation:(THLLocation *)location;
@end
