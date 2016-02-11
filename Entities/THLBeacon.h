//
//  THLBeacon.h
//  HypeUp
//
//  Created by Daniel Aksenov on 2/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEntity.h"

@interface THLBeacon : THLEntity
@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSString *major;
@property (nonatomic, retain) NSString *minor;
@end
