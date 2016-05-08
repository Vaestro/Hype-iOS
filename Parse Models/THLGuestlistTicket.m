//
//  THLGuestlistTicket.m
//  Hype
//
//  Created by Daniel Aksenov on 5/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLGuestlistTicket.h"


@implementation THLGuestlistTicket
@dynamic sender;
@dynamic guestlist;
@dynamic qrCode;
@dynamic scanned;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"GuestlistTicket";
}
@end
