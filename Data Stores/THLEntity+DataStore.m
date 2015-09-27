//
//  THLEntity+DataStore.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity+DataStore.h"

@implementation THLEntity (DataStore)
- (NSString *)key {
	return self.objectId;
}
@end
