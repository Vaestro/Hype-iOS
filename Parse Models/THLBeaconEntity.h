//
//  THLBeaconEntity.h
//  HypeUp
//
//  Created by Daniel Aksenov on 2/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import "PFObject+Subclass.h"

@interface THLBeaconEntity : PFObject<PFSubclassing>
@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSString *major;
@property (nonatomic, retain) NSString *minor;
@end
