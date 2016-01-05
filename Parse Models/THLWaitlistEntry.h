//
//  THLWaitlistEntry.h
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import "PFObject+Subclass.h"

@interface THLWaitlistEntry : PFObject<PFSubclassing>
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *code;
@property (nonatomic) BOOL approved;

@end
