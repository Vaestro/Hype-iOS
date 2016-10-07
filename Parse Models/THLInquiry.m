//
//  THLInquiry.m
//  Hype
//
//  Created by Edgar Li on 10/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLInquiry.h"

@implementation THLInquiry
@dynamic guestlist;
@dynamic owner;
@dynamic matchedPromoter;
@dynamic interestedPromoters;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Inquiry";
}
@end
